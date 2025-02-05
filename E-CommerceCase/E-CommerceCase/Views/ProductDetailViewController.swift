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
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel.delegate = self
        ActivityIndicatorView.shared.show(in: view)
        viewModel.fetchProductDetail()
        
        // Back yazısını kaldır
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .white
        scrollView.showsVerticalScrollIndicator = false
        
        // Scroll view için inset'i artıralım
        scrollView.contentInset = UIEdgeInsets(
            top: AppSizes.Padding.large,
            left: 0,
            bottom: AppSizes.Padding.extraLarge * 1.5,  // Alt padding'i artırdık
            right: 0
        )
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentStack)
        
        [scrollView, contentStack].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let padding = AppSizes.Padding.large  // medium yerine large kullanıyoruz
        
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
        
        // Stack view spacing'leri
        contentStack.spacing = AppSizes.Padding.large
        contentStack.setCustomSpacing(AppSizes.Padding.extraLarge, after: headerStack)
        contentStack.setCustomSpacing(AppSizes.Padding.extraLarge, after: imageView)
        contentStack.setCustomSpacing(AppSizes.Padding.medium, after: priceAndRatingStack)  // Price/rating ile category arası az olsun
        contentStack.setCustomSpacing(AppSizes.Padding.extraLarge, after: categoryLabel)  // Category ile description arası fazla olsun
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
    
    func showError(_ error: Error) {
        ActivityIndicatorView.shared.hide()
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
} 
