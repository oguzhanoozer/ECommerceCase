//
//  SceneDelegate.swift
//  E-CommerceCase
//
//  Created by oguzhan on 6.02.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        
        let productListViewController = ProductListViewController()
        let navigationController = UINavigationController(rootViewController: productListViewController)
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
} 
