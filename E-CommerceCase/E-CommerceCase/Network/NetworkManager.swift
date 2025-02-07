//
//  NetworkManager.swift
//  E-CommerceCase
//
//  Created by oguzhan on 6.02.2025.
//

import Foundation

protocol NetworkManagerProtocol {
    func fetchProducts(page: Int, limit: Int, completion: @escaping (Result<[Product], Error>) -> Void)
    func fetchProductDetail(id: Int, completion: @escaping (Result<Product, Error>) -> Void)
    func fetchHeaderProducts(completion: @escaping (Result<[Product], Error>) -> Void)
}

class NetworkManager: NetworkManagerProtocol {
    static let shared = NetworkManager()
    private init() {}
    
    private let timeoutInterval: TimeInterval = 10
    
    private func fetch<T: Decodable>(url: String, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: url) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        let request = URLRequest(url: url, timeoutInterval: timeoutInterval)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func fetchProducts(page: Int, limit: Int, completion: @escaping (Result<[Product], Error>) -> Void) {
        let urlString = AppConstants.API.baseURL + AppConstants.API.products + "?limit=\(limit)"
        fetch(url: urlString, completion: completion)
    }
    
    func fetchProductDetail(id: Int, completion: @escaping (Result<Product, Error>) -> Void) {
        let urlString = AppConstants.API.baseURL + AppConstants.API.productDetail + "\(id)"
        fetch(url: urlString, completion: completion)
    }
    
    func fetchHeaderProducts(completion: @escaping (Result<[Product], Error>) -> Void) {
        let urlString = AppConstants.API.baseURL + AppConstants.API.products + "?limit=5"
        fetch(url: urlString, completion: completion)
    }
}

enum NetworkError: Error {
    case invalidURL
    case noData
} 
