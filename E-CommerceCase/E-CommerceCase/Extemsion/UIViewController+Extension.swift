//
//  UIViewController+Extension.swift
//  E-CommerceCase
//
//  Created by oguzhan on 7.02.2025.
//

import UIKit

extension UIViewController{
    func showError(_ error: Error) {
        ActivityIndicatorView.shared.hide()
        let alert = UIAlertController(title: AppConstants.Alert.error, message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: AppConstants.Alert.okButton, style: .default))
        present(alert, animated: true)
    }
}
