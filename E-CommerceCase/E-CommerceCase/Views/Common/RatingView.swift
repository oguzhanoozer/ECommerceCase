import UIKit

class RatingView: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        font = .systemFont(ofSize: AppSizes.FontSize.small)
        textColor = .systemYellow
    }
    
    func configure(rating: Double, count: Int) {
        text = "★ \(String(format: "%.1f", rating)) (\(count))"
    }
} 