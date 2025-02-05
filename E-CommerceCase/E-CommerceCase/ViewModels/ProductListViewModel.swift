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
    
    // Pagination için gerekli değişkenler
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
        
        let group = DispatchGroup()
        var fetchError: Error?
        
        // İlk sayfa için header ve ürünleri çek
        if currentPage == 1 {
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
        }
        
        // Ürünleri çek
        group.enter()
        networkManager.fetchProducts(page: currentPage, limit: itemsPerPage) { [weak self] result in
            switch result {
            case .success(let newProducts):
                if newProducts.isEmpty {
                    self?.hasMorePages = false
                } else {
                    if self?.currentPage == 1 {
                        self?.products = newProducts
                    } else {
                        self?.products.append(contentsOf: newProducts)
                    }
                    self?.currentPage += 1
                }
            case .failure(let error):
                fetchError = error
            }
            group.leave()
        }
        
        // Her iki istek tamamlandığında UI'ı güncelle
        group.notify(queue: .main) { [weak self] in
            self?.isLoading = false
            if let error = fetchError {
                self?.delegate?.showError(error)
            } else {
                self?.delegate?.productsLoaded()
            }
        }
    }
    
    func loadMoreIfNeeded(at indexPath: IndexPath) {
        let threshold = products.count - 2 // Son 2 ürüne gelindiğinde yeni sayfa yükle
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
