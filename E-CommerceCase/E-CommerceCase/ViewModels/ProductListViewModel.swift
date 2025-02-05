import Foundation

protocol ProductListViewModelDelegate: AnyObject {
    func productsLoaded()
    func showError(_ error: Error)
}

class ProductListViewModel {
    private let networkManager: NetworkManagerProtocol
    weak var delegate: ProductListViewModelDelegate?
    
    private(set) var products: [Product] = []
    private(set) var headerProducts: [Product] = []
    
    init(networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    func fetchProducts() {
        let group = DispatchGroup()
        var fetchError: Error?
        
        // Header ürünlerini çek
        group.enter()
        networkManager.fetchHeaderProducts { [weak self] result in
            switch result {
            case .success(let products):
                self?.headerProducts = products
            case .failure(let error):
                fetchError = error
            }
            group.leave()
        }
        
        // Tüm ürünleri çek
        group.enter()
        networkManager.fetchProducts { [weak self] result in
            switch result {
            case .success(let products):
                self?.products = products
            case .failure(let error):
                fetchError = error
            }
            group.leave()
        }
        
        // Her iki istek tamamlandığında UI'ı güncelle
        group.notify(queue: .main) { [weak self] in
            if let error = fetchError {
                self?.delegate?.showError(error)
            } else {
                self?.delegate?.productsLoaded()
            }
        }
    }
} 
