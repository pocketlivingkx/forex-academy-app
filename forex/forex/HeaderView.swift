//
//  HeaderView.swift
//  forex
//
//  Created by msklv on 12.05.24.
//

import Foundation
import UIKit
import SnapKit

protocol HeaderViewDelegate: AnyObject {
    func backButtonTapped()
}

class HeaderView: UIView {
    
    var headerText: String?
    var isBackNeeded: Bool?
    var headerLabel = UILabel()
    var backButton = UIButton()
    weak var delegate: HeaderViewDelegate?
    init(frame: CGRect, headerText: String, isBackNeeded: Bool) {
        super.init(frame: frame)
        self.headerText = headerText
        self.isBackNeeded = isBackNeeded
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = UIColor(named: "HeaderViewBackground")
       // layer.cornerRadius = 10
        layer.masksToBounds = true
        
        setupLabel()
    }
    
    func setupLabel() {
        self.addSubview(headerLabel)
        self.addSubview(backButton)
        
        headerLabel.snp.makeConstraints { make in
            make.height.equalTo(28)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-10)
        }
        headerLabel.textColor = .white
        headerLabel.text = headerText
        headerLabel.font = UIFont(name: "Raleway-SemiBold", size: 24.0)
        
        backButton.snp.makeConstraints { make in
            make.height.width.equalTo(32)
            make.centerY.equalTo(headerLabel)
            make.left.equalToSuperview().offset(30)
        }

        backButton.setImage(UIImage(named: "BackButtonHeader"), for: .normal)
        backButton.layer.cornerRadius = 16
        backButton.layer.masksToBounds = true
        backButton.addTarget(self, action: #selector(backButtoxn), for: .touchUpInside)
        backButton.isHidden = !(self.isBackNeeded ?? true)
    }
    
    
    override func layoutSubviews() {
           super.layoutSubviews()
           
           let path = UIBezierPath(roundedRect: bounds,
                                   byRoundingCorners: [.bottomLeft, .bottomRight],
                                   cornerRadii: CGSize(width: 20, height: 20))
           let mask = CAShapeLayer()
           mask.path = path.cgPath
           layer.mask = mask
       }
    
    @objc func backButtoxn() {
        delegate?.backButtonTapped()
    }
}
