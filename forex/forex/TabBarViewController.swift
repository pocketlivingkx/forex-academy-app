
import Foundation
import UIKit
import SnapKit
import FirebaseAnalytics


class TabBarViewController: UITabBarController {
    
    var tabBarItems: [UIView] = []
    
    let customTabBar = UIView()

    let uiimage0 = UIImageView(image: UIImage(named: "0-"))
    let uiimage1 = UIImageView(image: UIImage(named: "1-"))
    let uiimage2 = UIImageView(image: UIImage(named: "2-"))
    let uiimage3 = UIImageView(image: UIImage(named: "3-"))

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customTabBar.backgroundColor = UIColor(named: "HeaderViewBackground")!  //UIColor(named: "TabBarBackground") // Цвет таббара
       // customTabBar.layer.cornerRadius = 15
        
        customTabBar.frame = CGRect(x: 0, y: view.bounds.height - (UIView.hasTopSafeArea ? 104 : 84), width: view.bounds.width , height: UIView.hasTopSafeArea ? 104 : 84)
        
        
        view.addSubview(customTabBar)
        
        tabBar.isHidden = true
        
        
          let lessonViewController = LessonViewController()
        
        
          let quizViewController =  QuizViewController()
        
        let broukViewController = BroukViewController()

        
          let SettingsVC = SettingsViewController()
        
        

        let stackView = UIStackView()
        //stackView.spacing = 24
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        customTabBar.addSubview(stackView)
        
        
        stackView.addArrangedSubview(uiimage0)
        stackView.addArrangedSubview(uiimage1)
        stackView.addArrangedSubview(uiimage2)
        stackView.addArrangedSubview(uiimage3)

        viewControllers = [lessonViewController, quizViewController, broukViewController ,SettingsVC]
        
        stackView.snp.makeConstraints { make in
            make.height.equalTo(52)
            make.top.equalTo(customTabBar.snp.top).offset(16)
            make.width.equalTo(customTabBar.snp.width).multipliedBy(0.8)
            make.centerX.equalToSuperview()
        }
        uiimage0.isUserInteractionEnabled = true
        uiimage1.isUserInteractionEnabled = true

        uiimage2.isUserInteractionEnabled = true
        uiimage3.isUserInteractionEnabled = true

        uiimage0.tag = 0
        uiimage1.tag = 1
        uiimage2.tag = 2
        uiimage3.tag = 3

        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(tabBarTapped(_:)))
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(tabBarTapped(_:)))
        let tapGesture3 = UITapGestureRecognizer(target: self, action: #selector(tabBarTapped(_:)))
        let tapGesture4 = UITapGestureRecognizer(target: self, action: #selector(tabBarTapped(_:)))

        uiimage0.addGestureRecognizer(tapGesture1)
        uiimage1.addGestureRecognizer(tapGesture2)
        uiimage2.addGestureRecognizer(tapGesture3)
        uiimage3.addGestureRecognizer(tapGesture4)

        selectTab(index: 0)
        

  
          
        
        
    }
    
 
    
    @objc func tabBarTapped(_ sender: UITapGestureRecognizer) {
        
        
        if let index = sender.view?.tag {
            selectTab(index: index)
        }
    }
    
    
    func selectTab(index: Int) {
        selectedIndex = index
        uiimage0.image =  UIImage(named:index != 0 ? "0-" : "0-0")
        uiimage1.image = UIImage(named:index != 1 ?"1-" : "1-1")
        uiimage2.image = UIImage(named:index != 2 ? "2-" : "2-2")
        uiimage3.image = UIImage(named:index != 3 ? "3-" : "3-3")

    }
    
}



