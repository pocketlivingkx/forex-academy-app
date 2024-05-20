//
//  SettingView.swift
//  forex
//
//  Created by msklv on 20.05.24.
//



import Foundation
import UIKit
import SnapKit
import Kingfisher

class SettingView: UIView {
    
    var headerText: String?
    var broukImage = UIImageView()
    var minDepLabel = UILabel()
    var link: String?
    
    init(frame: CGRect, name: String, link: String) {
        super.init(frame: frame)
        self.headerText = name
        self.link = link
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        layer.cornerRadius = 10
        layer.masksToBounds = true
        backgroundColor = UIColor(named: "LessonCellBackground")
        setupLabel()
    }
    
    func setupLabel() {
        self.addSubview(minDepLabel)
        self.addSubview(broukImage)

        broukImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(48)
            make.width.equalTo(48)
            make.right.equalToSuperview().offset(-16)
        }
        
        minDepLabel.snp.makeConstraints { make in
            make.height.equalTo(28)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(14)
            make.right.equalTo(broukImage.snp.left).offset(-14)
        }
       
        broukImage.layer.masksToBounds = true
        broukImage.layer.cornerRadius = 24
        
        minDepLabel.textColor = .white
        minDepLabel.text = headerText
        minDepLabel.font = UIFont(name: "Raleway-Regular", size: 16.0)
        broukImage.image = UIImage(named: "Back")
        let tap = UITapGestureRecognizer(target: self, action: #selector(visit))
        self.addGestureRecognizer(tap)
       // visitButton.addTarget(self, action: #selector(visit), for: .touchUpInside)
    }
    
    @objc func visit() {
        if let url = URL(string: "\(link ?? "")") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
   
}
