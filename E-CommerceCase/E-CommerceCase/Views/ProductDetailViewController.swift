import UIKit

class ProductDetailViewController: UIViewController {
    private let viewModel: ProductDetailViewModel
    
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = false
        return sv
    }()
    
    private let imageView = ProductImageView()  // ProductImageView kullan
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: AppSizes.FontSize.extraLarge, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: AppSizes.FontSize.medium)
        label.textColor = .gray
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: AppSizes.FontSize.title, weight: .bold)
        label.textColor = AppColors.accent
        return label
    }()
    
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
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: AppSizes.FontSize.medium)
        label.numberOfLines = 0
        return label
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
        headerStackView.addArrangedSubview(spacerView)  // Spacer'ı ekle
        headerStackView.addArrangedSubview(ratingLabel)
        
        scrollView.addSubview(imageView)
        scrollView.addSubview(categoryLabel)
        scrollView.addSubview(priceLabel)
        scrollView.addSubview(descriptionLabel)
        
        [scrollView, headerStackView, imageView,
         titleLabel, categoryLabel, priceLabel, descriptionLabel].forEach {
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
            
            categoryLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: AppSizes.Padding.extraLarge),
            categoryLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: AppSizes.Padding.extraLarge),
            
            priceLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: AppSizes.Padding.extraLarge),
            priceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: AppSizes.Padding.extraLarge),
            
            descriptionLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: AppSizes.Padding.extraLarge),
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