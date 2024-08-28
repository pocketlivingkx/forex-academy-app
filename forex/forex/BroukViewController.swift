//
//  BroukViewController.swift
//  forex
//
//  Created by msklv on 20.05.24.
//

import UIKit
import FirebaseAnalytics
import Kingfisher

class BroukViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    

    
    let headerView = HeaderView(frame: .zero, headerText: "Top brokers", isBackNeeded: false)
    var broukes = [ResultBrouk]()
    var tv = UITableView()
    var desctiptionL = UITextView()
    var descrpResult = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "MainViewBackground")
        view.addSubview(headerView)
        
        headerView.snp.makeConstraints { make in
            make.height.equalTo(UIView.hasTopSafeArea ? 115 : 70)
            make.left.right.top.equalToSuperview()
        }
        
        view.addSubview(tv)
        view.addSubview(desctiptionL)
        desctiptionL.backgroundColor = .clear
        desctiptionL.textColor = .white
        
        desctiptionL.font = UIFont(name: "Raleway-Regular", size: 18.0)
        desctiptionL.textAlignment = .center
        desctiptionL.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-((UIView.hasTopSafeArea ? 104 : 84) + 4))
            make.height.equalTo(100)
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
        }
        
        tv.snp.makeConstraints { make in
            //make.left.equalToSuperview().offset(30)
            //make.right.equalToSuperview().offset(-30)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.92)
            make.height.equalTo(tv.snp.width)
           // make.top.equalTo(headerView.snp.bottom).offset(30)
            make.bottom.equalTo(desctiptionL.snp.top).offset(-20)
        }
        
        tv.delegate = self
        tv.dataSource = self
        let nib = UINib(nibName: "FAQTableViewCell", bundle: nil)
        tv.backgroundColor = .clear
        tv.register(nib, forCellReuseIdentifier: "FAQTableViewCell")
        tv.separatorStyle = .none
        tv.rowHeight = UITableView.automaticDimension
        
        tv.backgroundColor = .clear
        fetchBrouk()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        broukes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FAQTableViewCell", for: indexPath) as! FAQTableViewCell
        
        cell.contentView.backgroundColor = .clear
        cell.dep.text = "Min deposit " + "\(broukes[indexPath.row].minDeposit ?? 0)" + " $"
        cell.iiimage.kf.indicatorType = .activity
        cell.namee.text = broukes[indexPath.row].brokerName ?? ""
        cell.descr.text = broukes[indexPath.row].description ?? ""
        
        let url = URL(string: broukes[indexPath.row].brokerImage ?? "")


       // cell.iiimage.kf.setImage(with: broukes[indexPath.row].link ?? "")
        cell.iiimage.kf.setImage(with: url)
       // cell.qwe.setImage(UIImage(named: cellData.isExpanded ? "more" : "more2"), for: .normal)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let url = URL(string: "\(broukes[indexPath.row].link ?? "")") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func updateDescrpText() {
        desctiptionL.text = descrpResult
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Analytics.logEvent("BrokersScreen", parameters: nil)
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
                            self.broukes = lessonsModel.data ?? [ResultBrouk]()
                            self.descrpResult = lessonsModel.broker_info ?? ""
                            print(self.broukes)
                            DispatchQueue.main.async {
                                self.tv.reloadData()
                                self.updateDescrpText()
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
