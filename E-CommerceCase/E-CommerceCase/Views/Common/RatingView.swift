import UIKit

class RatingView: UIView {
    private let ratingLabel = BaseLabel(style: .rating)
    private let countLabel = BaseLabel(style: .ratingCount)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(ratingLabel)
        addSubview(countLabel)
        
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            ratingLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            ratingLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            countLabel.leadingAnchor.constraint(equalTo: ratingLabel.trailingAnchor, constant: 4),
            countLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            countLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    func configure(rating: Double, count: Int) {
        ratingLabel.text = "★ \(String(format: "%.1f", rating))"
        countLabel.text = "(\(count))"
    }
} 