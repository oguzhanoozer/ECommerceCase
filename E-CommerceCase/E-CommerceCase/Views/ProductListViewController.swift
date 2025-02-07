//
//  ProductListViewController.swift
//  E-CommerceCase
//
//  Created by oguzhan on 6.02.2025.
//

import UIKit

class ProductListViewController: UIViewController {
    // MARK: - Properties
    private let viewModel: ProductListViewModel
    private var selectedCellFrame: CGRect?
    
    // MARK: - UI Components
    private let topBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = createLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = AppColors.primary
        cv.delegate = self
        cv.dataSource = self
        cv.register(ProductCell.self, forCellWithReuseIdentifier: AppConstants.CellIdentifiers.productCell)
        cv.register(HeaderView.self, 
                   forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                   withReuseIdentifier: AppConstants.CellIdentifiers.headerCell)
        return cv
    }()
    
    // MARK: - Lifecycle
    init(viewModel: ProductListViewModel = ProductListViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError(AppConstants.Error.title)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchData()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = AppColors.primary
        
        view.addSubview(topBackgroundView)
        view.addSubview(collectionView)
        
        [topBackgroundView, collectionView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            topBackgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            topBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topBackgroundView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func createLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = AppSizes.Padding.medium
        layout.minimumInteritemSpacing = AppSizes.Padding.medium
        layout.sectionInset = .zero
        return layout
    }
    
    // MARK: - Data
    private func fetchData() {
        viewModel.delegate = self
        ActivityIndicatorView.shared.show(in: view)
        viewModel.fetchProducts()
    }
    
    private func navigateToDetail(with id: Int) {
        let detailViewModel = ProductDetailViewModel(productId: id)
        let detailVC = ProductDetailViewController(viewModel: detailViewModel)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: - UICollectionViewDataSource
extension ProductListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppConstants.CellIdentifiers.productCell, for: indexPath) as? ProductCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: viewModel.products[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: AppConstants.CellIdentifiers.headerCell,
                                                                             for: indexPath) as? HeaderView else {
            return UICollectionReusableView()
        }
        
        headerView.delegate = self
        headerView.configure(with: viewModel.headerProducts)
        return headerView
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ProductListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding = AppSizes.Padding.medium * 3
        let width = (collectionView.bounds.width - padding) / 2
        return CGSize(width: width, height: width * 1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 220)
    }
}

// MARK: - UICollectionViewDelegate
extension ProductListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? ProductCell {
            selectedCellFrame = cell.convert(cell.bounds, to: nil)
        }
        let product = viewModel.products[indexPath.item]
        navigateToDetail(with: product.id)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        viewModel.loadMoreIfNeeded(at: indexPath)
    }
}

// MARK: - ProductListViewModelDelegate
extension ProductListViewController: ProductListViewModelDelegate {
    func productsLoaded() {
        ActivityIndicatorView.shared.hide()
        collectionView.reloadData()
    }
    
}

// MARK: - HeaderViewDelegate
extension ProductListViewController: HeaderViewDelegate {
    func headerView(_ headerView: HeaderView, didSelectItemAt index: Int) {
        let product = viewModel.headerProducts[index]
        navigateToDetail(with: product.id)
    }
} 
