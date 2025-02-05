import UIKit

class ProductImageView: UIImageView {
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
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentMode = .scaleAspectFit
        backgroundColor = AppColors.primary
        clipsToBounds = true
        
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
    
    func loadImage(from urlString: String) {
        // Reset state
        image = nil
        errorLabel.isHidden = true
        activityIndicator.startAnimating()
        
        guard let url = URL(string: urlString) else {
            showError()
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                
                if let error = error {
                    print("Image loading error: \(error.localizedDescription)")
                    self?.showError()
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode),
                      let data = data,
                      let image = UIImage(data: data) else {
                    self?.showError()
                    return
                }
                
                UIView.transition(with: self ?? UIImageView(),
                                duration: 0.3,
                                options: .transitionCrossDissolve,
                                animations: {
                    self?.image = image
                })
            }
        }
        task.resume()
    }
    
    private func showError() {
        activityIndicator.stopAnimating()
        errorLabel.isHidden = false
        backgroundColor = AppColors.primary.withAlphaComponent(0.1)
    }
} 