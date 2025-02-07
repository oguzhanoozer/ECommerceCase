//
//  AppSizes.swift
//  E-CommerceCase
//
//  Created by oguzhan on 6.02.2025.
//

import UIKit

struct AppSizes {
    struct Padding {
        static let small: CGFloat = 4
        static let medium: CGFloat = 8
        static let large: CGFloat = 12
        static let extraLarge: CGFloat = 16
    }
    
    struct CornerRadius {
        static let small: CGFloat = 8
        static let medium: CGFloat = 12
    }
    
    struct ImageSize {
        static let productCell: CGFloat = 150
        static let headerCell: CGFloat = 150
        static let productDetail: CGFloat = 300
    }
    
    struct FontWeight {
        static let regular = UIFont.Weight.regular
        static let medium = UIFont.Weight.medium
        static let semibold = UIFont.Weight.semibold
        static let bold = UIFont.Weight.bold
        static let heavy = UIFont.Weight.heavy
    }
    
    struct FontSize {
        static let tiny: CGFloat = 12
        static let small: CGFloat = 14
        static let medium: CGFloat = 16
        static let large: CGFloat = 18
        static let extraLarge: CGFloat = 20
        static let title: CGFloat = 24
        static let headline: CGFloat = 28
    }
    
    struct Shadow {
        static let opacity: Float = 0.1
        static let radius: CGFloat = 4
        static let offset = CGSize(width: 0, height: 2)
    }
} 
