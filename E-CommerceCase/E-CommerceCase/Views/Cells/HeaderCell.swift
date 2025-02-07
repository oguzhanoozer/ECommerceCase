//
//  HeaderCell.swift
//  E-CommerceCase
//
//  Created by oguzhan on 6.02.2025.
//

import UIKit

class HeaderCell: UICollectionViewCell {
    // MARK: - UI Components
    private let containerView = BaseView()
    private let imageView = ProductImageView()
    
    private let titleLabel = BaseLabel(style: .title)
    private let categoryLabel = BaseLabel(style: .subtitle)
    private let priceLabel = BaseLabel(style: .price)
    private let ratingLabel = BaseLabel(style: .rating)
    
    private lazy var priceAndRatingStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [priceLabel, ratingLabel])
        stack.axis = .horizontal
        stack.spacing = AppSizes.Padding.large
        stack.alignment = .center
        stack.distribution = .equalSpacing
        return stack
    }()
    
    private lazy var infoStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            titleLabel,
            categoryLabel,
            UIView(),
            priceAndRatingStack
        ])
        stack.axis = .vertical
        stack.spacing = AppSizes.Padding.small
        stack.alignment = .fill
        
        if let spacerView = stack.arrangedSubviews[2] as? UIView {
            spacerView.setContentHuggingPriority(.defaultLow, for: .vertical)
            spacerView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        }
        
        priceAndRatingStack.widthAnchor.constraint(equalTo: stack.widthAnchor).isActive = true
        
        return stack
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError(AppConstants.Error.title)
    }
    
    // MARK: - Setup
    private func setupUI() {
        backgroundColor = .clear
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 12
        containerView.clipsToBounds = true
        
        contentView.addSubview(containerView)
        containerView.addSubview(imageView)
        containerView.addSubview(infoStack)
        
        [containerView, imageView, infoStack].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
            
            infoStack.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            infoStack.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 12),
            infoStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            infoStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12)
        ])
    }
    
    // MARK: - Configure
    func configure(with product: Product) {
        titleLabel.text = product.title
        categoryLabel.text = product.category
        priceLabel.text = "$\(String(format: "%.2f", product.price))"
        ratingLabel.text = "★ \(String(format: "%.1f", product.rating.rate)) (\(product.rating.count))"
        imageView.loadImage(from: product.image)
    }
} 
