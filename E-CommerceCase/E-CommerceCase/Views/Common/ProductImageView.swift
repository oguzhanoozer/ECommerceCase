//
//  ProductImageView.swift
//  E-CommerceCase
//
//  Created by oguzhan on 6.02.2025.
//

import UIKit

class ProductImageView: BaseView {
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError(AppConstants.Error.title)
    }
    
    private func setupImageView() {
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func loadImage(from urlString: String) {
        resetState()
        showLoading()
        
        guard let url = URL(string: urlString) else {
            showError()
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.hideLoading()
                
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
                
                UIView.transition(with: self?.imageView ?? UIImageView(),
                                duration: 0.3,
                                options: .transitionCrossDissolve,
                                animations: {
                    self?.imageView.image = image
                })
            }
        }
        task.resume()
    }
} 
