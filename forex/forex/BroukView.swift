//
//  BroukView.swift
//  forex
//
//  Created by msklv on 20.05.24.
//


import Foundation
import UIKit
import SnapKit
import Kingfisher

class BroukView: UIView {
    
    var headerText: String?
    var isBackNeeded: Bool?
    var broukImage = UIImageView()
    var headerLabel = UILabel()
    var link: String?
    var linkStr: String?
    var deposit: String?
    var minDepLabel = UILabel()
    
    
    var visitButton = OrangeButton(frame: .zero, headerText: "Visit")
    
    init(frame: CGRect, name: String, linkString: String, link: String, depo: String) {
        super.init(frame: frame)
        self.headerText = name
        self.linkStr = linkString
        self.deposit = depo
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
        self.addSubview(headerLabel)
        self.addSubview(visitButton)
        self.addSubview(broukImage)
        self.addSubview(minDepLabel)

        broukImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(46)
            make.width.equalTo(60)
            make.left.equalToSuperview().offset(16)
        }
        
        headerLabel.snp.makeConstraints { make in
            make.height.equalTo(28)
            make.centerY.equalToSuperview().offset(-10)
            make.left.equalTo(broukImage.snp.right).offset(14)
            make.right.equalTo(visitButton.snp.left).offset(-14)
        }
        
        visitButton.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.width.equalTo(75)
            make.centerY.equalToSuperview()
            make.left.equalTo(headerLabel.snp.right).offset(12)
            make.right.equalToSuperview().offset(-16)
        }
        
        minDepLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.left.equalTo(broukImage.snp.right).offset(14)
            make.right.equalTo(visitButton.snp.left).offset(-14)
            make.top.equalTo(headerLabel.snp.bottom).offset(2)
        }
        
        
        visitButton.layer.cornerRadius = 8
        let url = URL(string: link ?? "")
        broukImage.kf.indicatorType = .activity
        broukImage.kf.setImage(with: url)
        broukImage.layer.masksToBounds = true
        broukImage.layer.cornerRadius = 8
        headerLabel.textColor = .white
        headerLabel.text = headerText
        headerLabel.font = UIFont(name: "Raleway-SemiBold", size: 24.0)
        
        minDepLabel.textColor = .white
        minDepLabel.text = "Min deposit: \(deposit ?? "") $"
        minDepLabel.font = UIFont(name: "Raleway-Regular", size: 14.0)
        
        
        
        visitButton.addTarget(self, action: #selector(visit), for: .touchUpInside)
    }
    
    @objc func visit() {
        if let url = URL(string: "\(linkStr ?? "")") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
   
}
