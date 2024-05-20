//
//  OrangeButton.swift
//  forex
//
//  Created by msklv on 12.05.24.
//

import Foundation

import Foundation
import UIKit
import SnapKit

class OrangeButton: UIButton {
    
    var buttonText: String?
    
    var headerLabel = UILabel()
    
    init(frame: CGRect, headerText: String) {
        super.init(frame: frame)
        self.buttonText = headerText
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = UIColor(named: "OrangeButtonBackground")
        layer.cornerRadius = 27
        layer.masksToBounds = true
        setTitle(buttonText, for: .normal)
        setTitleColor(.white, for: .normal)
        setTitleColor(.gray, for: .highlighted)
        titleLabel?.textAlignment = .center
        titleLabel?.font = UIFont(name: "Raleway-Bold", size: 20.0)
    }
    
}
