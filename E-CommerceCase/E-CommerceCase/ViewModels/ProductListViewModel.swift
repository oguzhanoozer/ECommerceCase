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
    
    private var currentPage = 1
    private var isLoading = false
    private var hasMorePages = true
    private let itemsPerPage = 6
    
    init(networkManager: NetworkManagerProtocol = MockNetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    func fetchProducts() {
        guard !isLoading else { return }
        isLoading = true
        
        // İlk sayfa için header ürünlerini çek
        if currentPage == 1 {
            fetchHeaderProducts()
        } else {
            fetchProductList()
        }
    }
    
    private func fetchHeaderProducts() {
        networkManager.fetchHeaderProducts { [weak self] result in
            switch result {
            case .success(let products):
                self?.headerProducts = products
                self?.fetchProductList()
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.isLoading = false
                    self?.delegate?.showError(error)
                }
            }
        }
    }
    
    private func fetchProductList() {
        networkManager.fetchProducts(page: currentPage, limit: itemsPerPage) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isLoading = false
                
                switch result {
                case .success(let newProducts):
                    if newProducts.isEmpty {
                        self.hasMorePages = false
                    } else {
                        if self.currentPage == 1 {
                            self.products = newProducts
                        } else {
                            self.products.append(contentsOf: newProducts)
                        }
                        self.currentPage += 1
                    }
                    self.delegate?.productsLoaded()
                    
                case .failure(let error):
                    self.delegate?.showError(error)
                }
            }
        }
    }
    
    func loadMoreIfNeeded(at indexPath: IndexPath) {
        let threshold = products.count - 2
        if indexPath.item >= threshold && hasMorePages && !isLoading {
            fetchProducts()
        }
    }
    
    func refreshData() {
        currentPage = 1
        hasMorePages = true
        products.removeAll()
        headerProducts.removeAll()
        fetchProducts()
    }
} 
