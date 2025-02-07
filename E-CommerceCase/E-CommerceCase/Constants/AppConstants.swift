//
//  AppConstants.swift
//  E-CommerceCase
//
//  Created by oguzhan on 6.02.2025.
//

struct AppConstants {
    struct API {
        static let baseURL = "https://fakestoreapi.com"
        static let products = "/products"
        static let productDetail = "/products/"
    }
    
    struct CellIdentifiers {
        static let productCell = "ProductCell"
        static let headerCell = "HeaderCell"
    }
    
    struct Error{
        static let title = "init(coder:) has not been implemented"
    }
    
    struct Alert {
        static let error = "Error!"
        static let okButton = "OK"
    }
}
