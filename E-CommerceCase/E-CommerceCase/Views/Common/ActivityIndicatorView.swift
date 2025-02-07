//
//  ActivityIndicatorView.swift
//  E-CommerceCase
//
//  Created by oguzhan on 6.02.2025.
//

import UIKit

class ActivityIndicatorView {
    static var shared: ActivityIndicatorView = ActivityIndicatorView()
    
    private var activityIndicator: UIActivityIndicatorView?
    private var containerView: UIView?
    
    func show(in view: UIView) {
        containerView = UIView()
        guard let containerView = containerView else { return }
        containerView.frame = view.bounds
        containerView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        activityIndicator = UIActivityIndicatorView(style: .large)
        guard let activityIndicator = activityIndicator else { return }
        activityIndicator.color = .white
        activityIndicator.center = containerView.center
        
        containerView.addSubview(activityIndicator)
        view.addSubview(containerView)
        
        activityIndicator.startAnimating()
    }
    
    func hide() {
        activityIndicator?.stopAnimating()
        containerView?.removeFromSuperview()
        activityIndicator = nil
        containerView = nil
    }
} 
