import UIKit

class ProductImageView: UIImageView {
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
        clipsToBounds = true
        backgroundColor = .white
    }
    
    func loadImage(from urlString: String) {
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        UIView.transition(with: self ?? UIImageView(),
                                       duration: 0.3,
                                       options: .transitionCrossDissolve,
                                       animations: {
                            self?.image = image
                        })
                    }
                }
            }.resume()
        }
    }
} 