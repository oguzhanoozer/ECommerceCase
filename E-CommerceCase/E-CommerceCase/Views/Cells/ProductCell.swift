//
//  ProductCell.swift
//  E-CommerceCase
//
//  Created by oguzhan on 6.02.2025.
//

import UIKit

class ProductCell: UICollectionViewCell {
    private let cardView = BaseCardView()
    
    private let imageContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let imageView = ProductImageView()
    
    private lazy var contentStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, priceLabel])
        stack.axis = .vertical
        stack.spacing = AppSizes.Padding.small
        stack.alignment = .leading
        return stack
    }()
    
    private let titleLabel = BaseLabel(style: .title)
    private let priceLabel = BaseLabel(style: .price)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError(AppConstants.Error.title)
    }
    
    private func setupUI() {
        contentView.addSubview(cardView)
        cardView.addSubview(imageContainerView)
        imageContainerView.addSubview(imageView)
        cardView.addSubview(contentStack)
        
        [cardView, imageContainerView, imageView, 
         contentStack].forEach {
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
            
            contentStack.topAnchor.constraint(equalTo: imageContainerView.bottomAnchor, constant: AppSizes.Padding.medium),
            contentStack.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: AppSizes.Padding.medium),
            contentStack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -AppSizes.Padding.medium),
            contentStack.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -AppSizes.Padding.medium)
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
