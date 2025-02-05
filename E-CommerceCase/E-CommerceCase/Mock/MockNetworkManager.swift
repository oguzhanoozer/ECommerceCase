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
    
    func fetchProducts(completion: @escaping (Result<[Product], Error>) -> Void) {
        if shouldFail {
            completion(.failure(NSError(domain: "", code: -1)))
            return
        }
        
        if let products = parseProducts() {
            completion(.success(products))
        } else {
            completion(.failure(NSError(domain: "", code: -2)))
        }
    }
    
    func fetchProductDetail(id: Int, completion: @escaping (Result<Product, Error>) -> Void) {
        if shouldFail {
            completion(.failure(NSError(domain: "", code: -1)))
            return
        }
        
        if let product = parseProductDetail() {
            completion(.success(product))
        } else {
            completion(.failure(NSError(domain: "", code: -2)))
        }
    }
    
    func fetchHeaderProducts(completion: @escaping (Result<[Product], Error>) -> Void) {
        if shouldFail {
            completion(.failure(NSError(domain: "", code: -1)))
            return
        }
        
        if let products = parseHeaderProducts() {
            completion(.success(products))
        } else {
            completion(.failure(NSError(domain: "", code: -2)))
        }
    }
} 
