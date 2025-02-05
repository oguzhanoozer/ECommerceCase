import UIKit

class BaseLabel: UILabel {
    enum Style {
        case title
        case subtitle
        case price
        case description
        case category
        case rating
        case ratingCount
        
        var font: UIFont {
            switch self {
            case .title:
                return TextStyle.heading
            case .subtitle:
                return TextStyle.heading
            case .price:
                return TextStyle.heading
            case .description:
                return TextStyle.body
            case .category:
                return TextStyle.caption
            case .rating:
                return TextStyle.body
            case .ratingCount:
                return TextStyle.caption
            }
        }
        
        var textColor: UIColor {
            switch self {
            case .title, .subtitle, .description:
                return AppColors.secondary
            case .price:
                return AppColors.accent
            case .category, .ratingCount:
                return .gray
            case .rating:
                return .systemYellow
            }
        }
        
        var numberOfLines: Int {
            switch self {
            case .title:
                return 2
            case .description:
                return 0
            default:
                return 1
            }
        }
    }
    
    convenience init(style: Style) {
        self.init(frame: .zero)
        font = style.font
        textColor = style.textColor
        numberOfLines = style.numberOfLines
    }
    
    var padding: UIEdgeInsets = .zero {
        didSet {
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
    
    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right
        return contentSize
    }
} 