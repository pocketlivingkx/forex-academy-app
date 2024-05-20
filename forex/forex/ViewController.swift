//
//  ViewController.swift
//  forex
//
//  Created by msklv on 12.05.24.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    let headerView = HeaderView(frame: .zero, headerText: "Welcome!", isBackNeeded: false)
    
    var loadingImage = UIImageView(image: UIImage(named: "Loading"))
    
    
    var loadingText: UILabel = {
        let label = UILabel()
        label.text = "Loading..."
        label.font = UIFont(name: "Raleway-SemiBold", size: 32.0)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    var loadingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        return stackView
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "MainViewBackground")
        view.addSubview(headerView)
        
        headerView.snp.makeConstraints { make in
            make.height.equalTo(UIView.hasTopSafeArea ? 115 : 70)
            make.left.right.top.equalToSuperview()
        }
        
        view.addSubview(loadingStackView)
        
        loadingStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        loadingStackView.addArrangedSubview(loadingImage)
        loadingStackView.addArrangedSubview(loadingText)
      
        startAnimation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func startAnimation() {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.fromValue = 0.0
        rotationAnimation.toValue = CGFloat.pi * 2.0
        rotationAnimation.duration = 5.0
        rotationAnimation.repeatCount = Float.infinity
        loadingImage.layer.add(rotationAnimation, forKey: "rotationAnimation")
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            //self.createPathToApp()
            let isOnboardingShown = UserDefaults.standard.bool(forKey: "isOnboardingShown")
            if !isOnboardingShown {
                self.startOnboarding()
            } else {
                self.startApp()
            }
          
        }
    }
    
    func startOnboarding() {
        UserDefaults.standard.set(true, forKey: "isOnboardingShown")

        let vc = FirstOnboardingViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func startApp() {
        UserDefaults.standard.set(true, forKey: "isOnboardingShown")

        let vc = TabBarViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

}

