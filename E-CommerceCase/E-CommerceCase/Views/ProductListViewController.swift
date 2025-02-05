import UIKit

class ProductListViewController: UIViewController {
    private let viewModel: ProductListViewModel
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = AppSizes.Padding.medium
        layout.minimumInteritemSpacing = AppSizes.Padding.medium
        layout.sectionInset = UIEdgeInsets(top: 0,
                                         left: AppSizes.Padding.medium,
                                         bottom: AppSizes.Padding.medium,
                                         right: AppSizes.Padding.medium)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = AppColors.primary
        cv.delegate = self
        cv.dataSource = self
        cv.register(ProductCell.self, forCellWithReuseIdentifier: AppConstants.CellIdentifiers.productCell)
        cv.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: AppConstants.CellIdentifiers.headerCell)
        return cv
    }()
    
    private var selectedCellFrame: CGRect?
    
    init(viewModel: ProductListViewModel = ProductListViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel.delegate = self
        ActivityIndicatorView.shared.show(in: view)
        viewModel.fetchProducts()
    }
    
    private func setupUI() {
        view.backgroundColor = AppColors.primary
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
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
        
        let product = viewModel.products[indexPath.item]
        cell.configure(with: product)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: AppConstants.CellIdentifiers.headerCell, for: indexPath) as? HeaderView else {
                return UICollectionReusableView()
            }
            headerView.delegate = self
            headerView.configure(with: viewModel.headerProducts)
            return headerView
        }
        return UICollectionReusableView()
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
        return CGSize(width: collectionView.bounds.width, height: 190)
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
    
    func showError(_ error: Error) {
        ActivityIndicatorView.shared.hide()
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - HeaderViewDelegate
extension ProductListViewController: HeaderViewDelegate {
    func headerView(_ headerView: HeaderView, didSelectItemAt index: Int) {
        let product = viewModel.headerProducts[index]
        navigateToDetail(with: product.id)
    }
} 
