import UIKit

class ProductDetailViewController: UIViewController {
    private let viewModel: ProductDetailViewModel
    
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = false
        return sv
    }()
    
    private let imageView = ProductImageView()  // ProductImageView kullan
    
    private let titleLabel = BaseLabel(style: .title)
    private let categoryLabel: BaseLabel = {
        let label = BaseLabel(style: .category)
        return label
    }()
    private let priceLabel = BaseLabel(style: .price)
    
    private let headerStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.alignment = .center
        sv.spacing = AppSizes.Padding.large
        return sv
    }()
    
    private let spacerView: UIView = {
        let view = UIView()
        view.setContentHuggingPriority(.defaultLow, for: .horizontal)
        view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return view
    }()
    
    private let ratingLabel = RatingView()  // RatingView kullan
    
    private let descriptionLabel = BaseLabel(style: .description)
    
    private let priceAndCategoryStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.alignment = .center
        sv.distribution = .equalSpacing // İçerik arasında eşit boşluk bırakır
        return sv
    }()
    
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
        ActivityIndicatorView.shared.show(in: view)  // Loading göster
        viewModel.fetchProductDetail()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        scrollView.addSubview(headerStackView)
        
        headerStackView.addArrangedSubview(titleLabel)
        headerStackView.addArrangedSubview(spacerView)
        headerStackView.addArrangedSubview(ratingLabel)
        
        scrollView.addSubview(imageView)
        scrollView.addSubview(priceAndCategoryStackView)
        scrollView.addSubview(descriptionLabel)
        
        // Price ve Category'yi stack view'a ekle
        priceAndCategoryStackView.addArrangedSubview(priceLabel)
        priceAndCategoryStackView.addArrangedSubview(categoryLabel)
        
        [scrollView, headerStackView, imageView,
         priceAndCategoryStackView, descriptionLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            headerStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: AppSizes.Padding.extraLarge),
            headerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: AppSizes.Padding.extraLarge),
            headerStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -AppSizes.Padding.extraLarge),
            
            imageView.topAnchor.constraint(equalTo: headerStackView.bottomAnchor, constant: AppSizes.Padding.extraLarge),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: AppSizes.ImageSize.productDetail),
            
            priceAndCategoryStackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: AppSizes.Padding.extraLarge),
            priceAndCategoryStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: AppSizes.Padding.extraLarge),
            priceAndCategoryStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -AppSizes.Padding.extraLarge),
            
            descriptionLabel.topAnchor.constraint(equalTo: priceAndCategoryStackView.bottomAnchor, constant: AppSizes.Padding.extraLarge),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: AppSizes.Padding.extraLarge),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -AppSizes.Padding.extraLarge),
            descriptionLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -AppSizes.Padding.extraLarge)
        ])
        
        // Title'ın genişliğini ayarla
        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        ratingLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    private func updateUI() {
        guard let product = viewModel.product else { return }
        
        titleLabel.text = product.title
        categoryLabel.text = product.category
        priceLabel.text = "$\(String(format: "%.2f", product.price))"
        descriptionLabel.text = product.description
        ratingLabel.configure(rating: product.rating.rate, count: product.rating.count)
        imageView.loadImage(from: product.image)
    }
    
    func getImageFrame() -> CGRect {
        return imageView.convert(imageView.bounds, to: nil)
    }
}

extension ProductDetailViewController: ProductListViewModelDelegate {
    func productsLoaded() {
        ActivityIndicatorView.shared.hide()  // Loading gizle
        updateUI()
    }
    
    func showError(_ error: Error) {
        ActivityIndicatorView.shared.hide()  // Loading gizle
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
} 