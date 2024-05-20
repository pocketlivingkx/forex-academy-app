//
//  FirstOnboardingViewController.swift
//  forex
//
//  Created by msklv on 12.05.24.
//

import UIKit

class FirstOnboardingViewController: UIViewController {
    
    
    let headerView = HeaderView(frame: .zero, headerText: "Welcome!", isBackNeeded: false)
    let continueButton = OrangeButton(frame: .zero, headerText: "Continue")
    
    var progressImage = UIImageView(image: UIImage(named: "Progress1"))
    var loadingImage = UIImageView(image: UIImage(named: "FirstImageFromOnboarding"))
    
    var descriptionOneLabel: UILabel = {
        let label = UILabel()
        label.text = "Uncover what moves the markets"
        label.font = UIFont(name: "Raleway-SemiBold", size: 20.0)
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    var descriptionTwoLabel: UILabel = {
        let label = UILabel()
        label.text = "Our trading school reward you with game money (XP) as you progress and learn about financial markets"
        label.font = UIFont(name: "Raleway-Regular", size: 14.0)
        label.textColor = .lightGray
        label.numberOfLines = 0
        label.textAlignment = .center
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
        view.addSubview(continueButton)
        view.addSubview(progressImage)
        view.addSubview(loadingStackView)

        continueButton.addTarget(self, action: #selector(nextOnboarding), for: .touchUpInside)

        continueButton.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.65)
            make.height.equalTo(56)
            make.bottom.equalToSuperview().offset(-60)
            make.centerX.equalToSuperview()
        }
        
        progressImage.snp.makeConstraints { make in
            make.width.equalTo(continueButton.snp.width).multipliedBy(0.3)
            make.height.equalTo(2)
            make.bottom.equalTo(continueButton.snp.top).offset(-6)
            make.centerX.equalToSuperview()
        }
        
        headerView.snp.makeConstraints { make in
            make.height.equalTo(UIView.hasTopSafeArea ? 115 : 70)
            make.left.right.top.equalToSuperview()
        }

        loadingStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.75)
            make.top.equalTo(headerView.snp.bottom).offset(20)
        }
        
        loadingStackView.addArrangedSubview(loadingImage)
        loadingStackView.addArrangedSubview(descriptionOneLabel)
        loadingStackView.addArrangedSubview(descriptionTwoLabel)
    }
    
    
    @objc func nextOnboarding() {
        let vc = SecondOnboardingViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
