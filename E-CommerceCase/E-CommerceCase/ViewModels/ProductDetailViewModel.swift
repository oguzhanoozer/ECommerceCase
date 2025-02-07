//
//  ProductDetailViewModel.swift
//  E-CommerceCase
//
//  Created by oguzhan on 6.02.2025.
//

import Foundation

class ProductDetailViewModel {
    private let networkManager: NetworkManagerProtocol
    let productId: Int
    private(set) var product: Product?
    
    weak var delegate: ProductListViewModelDelegate?
    
    init(productId: Int, networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.productId = productId
        self.networkManager = networkManager
    }
    
    func fetchProductDetail() {
        networkManager.fetchProductDetail(id: productId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let product):
                    self?.product = product
                    self?.delegate?.productsLoaded()
                case .failure(let error):
                    self?.delegate?.showError(error)
                }
            }
        }
    }
} 
