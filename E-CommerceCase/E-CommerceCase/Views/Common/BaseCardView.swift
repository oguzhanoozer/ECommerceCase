//
//  BaseCardView.swift
//  E-CommerceCase
//
//  Created by oguzhan on 6.02.2025.
//

import UIKit

class BaseCardView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError(AppConstants.Error.title)
    }
    
    private func setupUI() {
        backgroundColor = .white
        layer.cornerRadius = AppSizes.CornerRadius.small
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = AppSizes.Shadow.opacity
        layer.shadowOffset = AppSizes.Shadow.offset
        layer.shadowRadius = AppSizes.Shadow.radius
    }
} 
