import UIKit

class BaseView: UICollectionReusableView {
    // MARK: - Properties
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.text = "!"
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.textColor = .red
        label.isHidden = true
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupUI() {
        backgroundColor = .white
        
        addSubview(activityIndicator)
        addSubview(errorLabel)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            errorLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            errorLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    // MARK: - Public Methods
    func showLoading() {
        errorLabel.isHidden = true
        activityIndicator.startAnimating()
    }
    
    func hideLoading() {
        activityIndicator.stopAnimating()
    }
    
    func showError() {
        activityIndicator.stopAnimating()
        errorLabel.isHidden = false
        backgroundColor = .white.withAlphaComponent(0.1)
    }
    
    func resetState() {
        errorLabel.isHidden = true
        activityIndicator.stopAnimating()
        backgroundColor = .white
    }
} 