//
//  BroukViewController.swift
//  forex
//
//  Created by msklv on 20.05.24.
//

import UIKit
import FirebaseAnalytics

class BroukViewController: UIViewController {
    
    let headerView = HeaderView(frame: .zero, headerText: "Top 3 brokers", isBackNeeded: false)
    var broukes = [ResultBrouk]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "MainViewBackground")
        view.addSubview(headerView)
        
        headerView.snp.makeConstraints { make in
            make.height.equalTo(UIView.hasTopSafeArea ? 115 : 70)
            make.left.right.top.equalToSuperview()
        }
        
        
        fetchBrouk()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Analytics.logEvent("BrokersScreen", parameters: nil)
    }
    
    func createBroukView() {
        var sv = UIStackView()
        sv.axis = .vertical
        view.addSubview(sv)
        sv.backgroundColor = .clear
        sv.spacing = 16
        
        sv.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(212)
            make.width.equalTo(360)
        }
        
        var firstView = UIView()
        firstView.backgroundColor = .clear
        
        var ffirstView = UIView()
        ffirstView.backgroundColor = .clear
        
        var fffirstView = UIView()
        fffirstView.backgroundColor = .clear
  
        var viewBroukOne = BroukView(frame: .zero, name: broukes[0].brokerName ?? "", linkString:  broukes[0].link ?? "" , link:  broukes[0].brokerImage ?? "", depo: "\(broukes[0].minDeposit ?? 0)")
        var viewBroukTwo = BroukView(frame: .zero, name: broukes[1].brokerName ?? "", linkString:  broukes[1].link ?? "" , link:  broukes[1].brokerImage ?? "", depo: "\(broukes[1].minDeposit ?? 0)")
        var viewBroukThree = BroukView(frame: .zero, name: broukes[2].brokerName ?? "", linkString:  broukes[2].link ?? "" , link:  broukes[2].brokerImage ?? "", depo: "\(broukes[2].minDeposit ?? 0)")
        
        sv.addArrangedSubview(firstView)
        sv.addArrangedSubview(ffirstView)
        sv.addArrangedSubview(fffirstView)

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
        
        fffirstView.addSubview(viewBroukThree)
        
        viewBroukThree.snp.makeConstraints { make in
            make.edges.equalToSuperview()

            make.height.equalTo(60)
            make.width.equalToSuperview()
        }
    }
    
    
    
    
    
    func fetchBrouk() {
        NetworkLayer.fetchDataFromAPI(endpoint: .brok) { data, respons, error in
            if let error = error {
                print("Error:", error.localizedDescription)
                return
            }
            
            
            if let data = data {
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    if let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
                        print(json,jsonData)
                        
                        if let lessonsModel: BrokersModel = try? JSONDecoder().decode(BrokersModel.self, from: jsonData) {
                            self.broukes = lessonsModel.results ?? [ResultBrouk]()
                            print(self.broukes)
                            DispatchQueue.main.async {
                                self.createBroukView()
                            }
                        }
                    }
                } catch {
                        print("Error decoding JSON:", error)
                        
                   
                }
            }
        }
    }
    
}
