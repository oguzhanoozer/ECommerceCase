//
//  ProductDetailViewController.swift
//  E-CommerceCase
//
//  Created by oguzhan on 6.02.2025.
//

import UIKit

class ProductDetailViewController: UIViewController {
    // MARK: - Properties
    private let viewModel: ProductDetailViewModel
    
    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let imageView = ProductImageView()
    
    private lazy var contentStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            headerStack,
            imageView,
            priceAndRatingStack,
            categoryLabel,
            descriptionLabel
        ])
        stack.axis = .vertical
        stack.spacing = AppSizes.Padding.large
        return stack
    }()
    
    private let titleLabel = BaseLabel(style: .title)
    private let categoryLabel = BaseLabel(style: .subtitle)
    private let priceLabel = BaseLabel(style: .price)
    private let descriptionLabel = BaseLabel(style: .body)
    private let ratingLabel = BaseLabel(style: .rating)
    
    private lazy var headerStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, ratingLabel])
        stack.axis = .horizontal
        stack.spacing = AppSizes.Padding.extraLarge * 2
        stack.alignment = .top
        
        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        ratingLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        ratingLabel.firstBaselineAnchor.constraint(equalTo: titleLabel.firstBaselineAnchor).isActive = true
        
        return stack
    }()
    
    private lazy var priceAndRatingStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [priceLabel, ratingLabel])
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        return stack
    }()
    
    // MARK: - Lifecycle
    init(viewModel: ProductDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError(AppConstants.Error.title)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel.delegate = self
        ActivityIndicatorView.shared.show(in: view)
        viewModel.fetchProductDetail()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .white
        scrollView.showsVerticalScrollIndicator = false
        
        scrollView.contentInset = UIEdgeInsets(
            top: AppSizes.Padding.large,
            left: 0,
            bottom: AppSizes.Padding.extraLarge * 1.5,
            right: 0
        )
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentStack)
        
        [scrollView, contentStack].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let padding = AppSizes.Padding.large
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentStack.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            contentStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -(padding * 2)),
            
            imageView.heightAnchor.constraint(equalToConstant: AppSizes.ImageSize.productDetail)
        ])
        
        contentStack.spacing = AppSizes.Padding.large
        contentStack.setCustomSpacing(AppSizes.Padding.extraLarge, after: headerStack)
        contentStack.setCustomSpacing(AppSizes.Padding.extraLarge, after: imageView)
        contentStack.setCustomSpacing(AppSizes.Padding.medium, after: priceAndRatingStack)  
        contentStack.setCustomSpacing(AppSizes.Padding.extraLarge, after: categoryLabel)
    }
    
    private func updateUI() {
        guard let product = viewModel.product else { return }
        
        titleLabel.text = product.title
        categoryLabel.text = product.category
        priceLabel.text = "$\(String(format: "%.2f", product.price))"
        descriptionLabel.text = product.description
        ratingLabel.text = "★ \(String(format: "%.1f", product.rating.rate)) (\(product.rating.count))"
        imageView.loadImage(from: product.image)
    }
    
    func getImageFrame() -> CGRect {
        return imageView.convert(imageView.bounds, to: nil)
    }
}

// MARK: - ProductListViewModelDelegate
extension ProductDetailViewController: ProductListViewModelDelegate {
    func productsLoaded() {
        ActivityIndicatorView.shared.hide()
        updateUI()
    }
} 
