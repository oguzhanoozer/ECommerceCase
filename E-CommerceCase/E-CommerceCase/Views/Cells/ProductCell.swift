import UIKit

class ProductCell: UICollectionViewCell {
    private let cardView = BaseCardView()
    
    private let imageContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let imageView = ProductImageView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: AppSizes.FontSize.small, weight: .medium)
        label.numberOfLines = 2
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: AppSizes.FontSize.medium, weight: .bold)
        label.textColor = .gray
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(cardView)
        cardView.addSubview(imageContainerView)
        imageContainerView.addSubview(imageView)
        cardView.addSubview(titleLabel)
        cardView.addSubview(priceLabel)
        
        [cardView, imageContainerView, imageView, 
         titleLabel, priceLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: AppSizes.Padding.medium),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppSizes.Padding.medium),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppSizes.Padding.medium),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -AppSizes.Padding.medium),
            
            imageContainerView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: AppSizes.Padding.medium),
            imageContainerView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: AppSizes.Padding.medium),
            imageContainerView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -AppSizes.Padding.medium),
            imageContainerView.heightAnchor.constraint(equalToConstant: AppSizes.ImageSize.productCell),
            
            imageView.centerXAnchor.constraint(equalTo: imageContainerView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: imageContainerView.centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: imageContainerView.widthAnchor, multiplier: 0.8),
            imageView.heightAnchor.constraint(equalTo: imageContainerView.heightAnchor, multiplier: 0.8),
            
            titleLabel.topAnchor.constraint(equalTo: imageContainerView.bottomAnchor, constant: AppSizes.Padding.medium),
            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: AppSizes.Padding.medium),
            titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -AppSizes.Padding.medium),
            
            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: AppSizes.Padding.small),
            priceLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: AppSizes.Padding.medium),
            priceLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -AppSizes.Padding.medium),
            priceLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -AppSizes.Padding.medium)
        ])
    }
    
    func configure(with product: Product) {
        titleLabel.text = product.title
        priceLabel.text = "$\(String(format: "%.2f", product.price))"
        imageView.loadImage(from: product.image)
    }
    
    func getImageFrame() -> CGRect {
        return imageView.convert(imageView.bounds, to: nil)
    }
} 