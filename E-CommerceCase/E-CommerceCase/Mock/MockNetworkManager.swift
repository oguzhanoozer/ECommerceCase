import Foundation

class MockNetworkManager: NetworkManagerProtocol {
    static let shared = MockNetworkManager()

    var shouldFail = false
    
    private func parseProducts() -> [Product]? {
        guard let jsonData = MockData.productsJSON.data(using: .utf8) else { return nil }
        return try? JSONDecoder().decode([Product].self, from: jsonData)
    }
    
    private func parseProductDetail() -> Product? {
        guard let jsonData = MockData.productDetailJSON.data(using: .utf8) else { return nil }
        return try? JSONDecoder().decode(Product.self, from: jsonData)
    }
    
    private func parseHeaderProducts() -> [Product]? {
        guard let jsonData = MockData.headerProductsJSON.data(using: .utf8) else { return nil }
        return try? JSONDecoder().decode([Product].self, from: jsonData)
    }
    
    func fetchProducts(page: Int, limit: Int, completion: @escaping (Result<[Product], Error>) -> Void) {
        if shouldFail {
            completion(.failure(NetworkError.noData))
            return
        }
        
        if let allProducts = parseProducts() {
            let startIndex = (page - 1) * limit
            let endIndex = min(startIndex + limit, allProducts.count)
            
            guard startIndex < allProducts.count else {
                completion(.success([]))
                return
            }
            
            let pagedProducts = Array(allProducts[startIndex..<endIndex])
            completion(.success(pagedProducts))
        } else {
            completion(.failure(NetworkError.noData))
        }
    }
    
    func fetchProductDetail(id: Int, completion: @escaping (Result<Product, Error>) -> Void) {
        if shouldFail {
            completion(.failure(NetworkError.noData))
            return
        }
        
        if let product = parseProductDetail() {
            completion(.success(product))
        } else {
            completion(.failure(NetworkError.noData))
        }
    }
    
    func fetchHeaderProducts(completion: @escaping (Result<[Product], Error>) -> Void) {
        if shouldFail {
            completion(.failure(NetworkError.noData))
            return
        }
        
        if let products = parseHeaderProducts() {
            completion(.success(products))
        } else {
            completion(.failure(NetworkError.noData))
        }
    }
} 
