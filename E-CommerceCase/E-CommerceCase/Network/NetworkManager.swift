import Foundation

protocol NetworkManagerProtocol {
    func fetchProducts(completion: @escaping (Result<[Product], Error>) -> Void)
    func fetchProductDetail(id: Int, completion: @escaping (Result<Product, Error>) -> Void)
    func fetchHeaderProducts(completion: @escaping (Result<[Product], Error>) -> Void)
}

class NetworkManager: NetworkManagerProtocol {
    static let shared = NetworkManager()
    private init() {}
    
    private let timeoutInterval: TimeInterval = 10
    
    func fetchProducts(completion: @escaping (Result<[Product], Error>) -> Void) {
        let urlString = AppConstants.API.baseURL + AppConstants.API.products
        
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.timeoutInterval = timeoutInterval
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else { return }
            
            do {
                let products = try JSONDecoder().decode([Product].self, from: data)
                completion(.success(products))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func fetchProductDetail(id: Int, completion: @escaping (Result<Product, Error>) -> Void) {
        let urlString = AppConstants.API.baseURL + AppConstants.API.productDetail + "\(id)"
        
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.timeoutInterval = timeoutInterval
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else { return }
            
            do {
                let product = try JSONDecoder().decode(Product.self, from: data)
                completion(.success(product))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func fetchHeaderProducts(completion: @escaping (Result<[Product], Error>) -> Void) {
        let urlString = AppConstants.API.baseURL + AppConstants.API.products + "?limit=5"
        
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.timeoutInterval = timeoutInterval
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else { return }
            
            do {
                let products = try JSONDecoder().decode([Product].self, from: data)
                completion(.success(products))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
} 
