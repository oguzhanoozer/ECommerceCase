import UIKit

class BaseLabel: UILabel {
    enum Style {
        case title      // Ürün başlığı için
        case price      // Fiyat için
        case subtitle   // Kategori gibi ikincil bilgiler için
        case body       // Açıklama metni için
        case rating     // Rating için
        case ratingCount // Rating sayısı için
        
        var font: UIFont {
            switch self {
            case .title:
                return .systemFont(ofSize: 16, weight: .semibold)
            case .price:
                return .systemFont(ofSize: 18, weight: .bold)
            case .subtitle:
                return .systemFont(ofSize: 14, weight: .regular)
            case .body:
                return .systemFont(ofSize: 14, weight: .regular)
            case .rating:
                return .systemFont(ofSize: 16, weight: .semibold)
            case .ratingCount:
                return .systemFont(ofSize: 12, weight: .regular)
            }
        }
        
        var textColor: UIColor {
            switch self {
            case .title, .body:
                return .black
            case .price:
                return AppColors.accent
            case .subtitle, .ratingCount:
                return .gray
            case .rating:
                return .systemYellow
            }
        }
        
        var numberOfLines: Int {
            switch self {
            case .title:
                return 2
            case .body:
                return 0
            default:
                return 1
            }
        }
    }
    
    init(style: Style, text: String? = nil) {
        super.init(frame: .zero)
        self.text = text
        configure(with: style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(with style: Style) {
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