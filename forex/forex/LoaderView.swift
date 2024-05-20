//
//  LoaderView.swift
//  forex
//
//  Created by msklv on 17.05.24.
//

import Foundation
import UIKit

class ActivityIndicatorManager {
    
    static let shared = ActivityIndicatorManager()
    
    private let activityIndicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .gray // Цвет индикатора
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private var containerView: UIView?
    
    func showActivityIndicator() {
        guard let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else {
            return
        }
        
        containerView = UIView(frame: keyWindow.bounds)
        containerView?.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        containerView?.addSubview(activityIndicatorView)
        activityIndicatorView.centerXAnchor.constraint(equalTo: containerView!.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: containerView!.centerYAnchor).isActive = true
        
        keyWindow.addSubview(containerView!)
        activityIndicatorView.startAnimating()
    }
    
    func hideActivityIndicator() {
        activityIndicatorView.stopAnimating()
        containerView?.removeFromSuperview()
    }
}

// Пример использования:
// Для показа индикатора: ActivityIndicatorManager.shared.showActivityIndicator()
// Для скрытия индикатора: ActivityIndicatorManager.shared.hideActivityIndicator()
