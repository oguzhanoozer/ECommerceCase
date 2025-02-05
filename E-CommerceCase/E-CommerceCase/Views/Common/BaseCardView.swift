import UIKit

class BaseCardView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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