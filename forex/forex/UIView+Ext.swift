//
//  UIView+Ext.swift
//  forex
//
//  Created by msklv on 12.05.24.
//

import Foundation
import UIKit

extension UIView {
    static var hasTopSafeArea: Bool {
        if let window = UIApplication.shared.windows.first {
            let topSafeAreaHeight = window.safeAreaInsets.top
            return topSafeAreaHeight > 20
        }
        return false
    }
    
    
    
        func addShadow(offset: CGSize = CGSize(width: 0, height: 2),
                       color: UIColor = .black,
                       radius: CGFloat = 4.0,
                       opacity: Float = 0.5) {
            self.layer.masksToBounds = false
            self.layer.shadowOffset = offset
            self.layer.shadowColor = color.cgColor
            self.layer.shadowRadius = radius
            self.layer.shadowOpacity = opacity
        }
    
}
