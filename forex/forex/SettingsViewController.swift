//
//  SettingsViewController.swift
//  forex
//
//  Created by msklv on 12.05.24.
//

import UIKit
import FirebaseAnalytics

class SettingsViewController: UIViewController {

    
    let headerView = HeaderView(frame: .zero, headerText: "Settings", isBackNeeded: false)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "MainViewBackground")
        view.addSubview(headerView)
        
        headerView.snp.makeConstraints { make in
            make.height.equalTo(UIView.hasTopSafeArea ? 115 : 70)
            make.left.right.top.equalToSuperview()
        }

        createBroukView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Analytics.logEvent("SettingsScreen", parameters: nil)
    }
    
    func createBroukView() {
        var sv = UIStackView()
        sv.axis = .vertical
        view.addSubview(sv)
        sv.backgroundColor = .clear
        sv.spacing = 16
        
        sv.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(136)
            make.width.equalTo(360)
        }
        
        var firstView = UIView()
        firstView.backgroundColor = .clear
        
        var ffirstView = UIView()
        ffirstView.backgroundColor = .clear
        
        var viewBroukOne = SettingView(frame: .zero, name: "Terms and conditions", link: "www.google.com")
        var viewBroukTwo = SettingView(frame: .zero, name: "Privacy Policy", link: "www.yandex.ru")
        
        sv.addArrangedSubview(firstView)
        sv.addArrangedSubview(ffirstView)

        firstView.addSubview(viewBroukOne)
        
        viewBroukOne.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(60)
            make.width.equalToSuperview()
        }
        
        ffirstView.addSubview(viewBroukTwo)
        
        viewBroukTwo.snp.makeConstraints { make in
            make.edges.equalToSuperview()

            make.height.equalTo(60)
            make.width.equalToSuperview()
        }
        
      
    }

}
