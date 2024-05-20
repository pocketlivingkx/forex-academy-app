//
//  QuizViewController.swift
//  forex
//
//  Created by msklv on 18.05.24.
//

import UIKit
import FirebaseAnalytics

class QuizViewController: UIViewController {

    let headerView = HeaderView(frame: .zero, headerText: "Quizzes", isBackNeeded: false)
    let headerLabel = UILabel()
    let quizView = UIView()
    let quizStartLabel = UILabel()
    var startedQuizButton = OrangeButton(frame: .zero, headerText: "Start")
    let progressView = UIProgressView(progressViewStyle: .default)
    var allQuiz = [AllQuizModel]()
    
    var percentProgressLabel = UILabel()
    var intProgressLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(named: "MainViewBackground")
        view.addSubview(headerView)
        
        headerView.snp.makeConstraints { make in
            make.height.equalTo(UIView.hasTopSafeArea ? 115 : 70)
            make.left.right.top.equalToSuperview()
        }
        
        
        headerLabel.text = "Test your knowledge by taking our quiz and see how you score! Track your progress and improve with each attempt."
        headerLabel.numberOfLines = 0
        headerLabel.font = UIFont(name: "Raleway-SemiBold", size: 16.0)
        headerLabel.textColor = .white
        headerLabel.textAlignment = .center
        
        view.addSubview(headerLabel)
        
        headerLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(headerView.snp.bottom).offset(20)
            make.height.equalTo(120)
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
        }
        
        
        view.addSubview(quizView)
        
        quizView.backgroundColor = UIColor(named: "LessonCellBackground")
        quizView.layer.cornerRadius = 16
        quizView.addShadow(offset: CGSize(width: 0, height: 4), color: .black, radius: 6.0, opacity: 0.3)
        
        quizView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(quizView.snp.width).multipliedBy(0.66)
            make.top.equalTo(headerLabel.snp.bottom).offset(40)
        }
        
        
        quizStartLabel.text = "Test your knowledge!"
        quizStartLabel.font = UIFont(name: "Raleway-SemiBold", size: 24.0)
        quizStartLabel.numberOfLines = 0
        quizStartLabel.textColor = .white
        quizStartLabel.textAlignment = .center
        
        
        
        
        percentProgressLabel.text = "Progress:"
        percentProgressLabel.font = UIFont(name: "Raleway-Regular", size: 14.0)
        percentProgressLabel.numberOfLines = 1
        percentProgressLabel.textColor = .white
        percentProgressLabel.textAlignment = .left
        
        intProgressLabel.text = "0/100"
        intProgressLabel.font = UIFont(name: "Raleway-Regular", size: 14.0)
        intProgressLabel.numberOfLines = 1
        intProgressLabel.textColor = .white
        intProgressLabel.textAlignment = .right
        intProgressLabel.isHidden = true
        
        quizView.addSubview(quizStartLabel)
        quizView.addSubview(intProgressLabel)
        quizView.addSubview(percentProgressLabel)

        
    
        
        
        startedQuizButton.addTarget(self, action: #selector(startQuiz), for: .touchUpInside)
        quizView.addSubview(startedQuizButton)
        
        startedQuizButton.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.80)
            make.height.equalTo(56)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-14)
        }
        
        
        progressView.progress = 0
        
        progressView.trackTintColor = UIColor(named: "ProgressBackgroundEmpty")
        progressView.progressTintColor = UIColor(named: "ProgressBackground")
        
        quizView.addSubview(progressView)
        
        progressView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(4)
            make.bottom.equalTo(startedQuizButton.snp.top).offset(-12)
        }
        
        
        percentProgressLabel.snp.makeConstraints { make in
            make.left.equalTo(progressView.snp.left)
            make.bottom.equalTo(progressView.snp.top).offset(-8)
            make.height.equalTo(16)
        }
        
        
        intProgressLabel.snp.makeConstraints { make in
            make.right.equalTo(progressView.snp.right)
            make.bottom.equalTo(progressView.snp.top).offset(-8)
            make.height.equalTo(16)
        }
        
        quizStartLabel.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.8)
            make.top.equalTo(quizView.snp.top).offset(16)
            make.centerX.equalToSuperview()
            make.height.equalTo(30)
        }
        
        fetchQuiz()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Analytics.logEvent("QuizScreen", parameters: nil)
    }
    
    @objc func startQuiz() {
        
        let vc = QuizAnswerViewController()
        
        vc.buttonCallback = {
            self.fetchQuiz()
        }
        vc.allQuiz = Array(allQuiz.filter {$0.isAnswerCorrect == false}.prefix(10))
        

        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func fetchQuiz() {
        
        NetworkLayer.fetchDataFromAPI(endpoint: .quiz) { data, response, error in
            
            if let data = data {
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    if let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
                        
                        if let lessonsModel: [AllQuizModel] = try? JSONDecoder().decode([AllQuizModel].self, from: jsonData) {
                            self.allQuiz = lessonsModel
                        
                            
                            
                            DispatchQueue.main.async {
                                self.updateProgress()

                            }
                        }
                    }
                } catch {
                    print("Error decoding JSON:", error)
                }
            }
            
        }
        
    }
    
    
    func updateProgress() {
        var correctAnswer = allQuiz.map { $0.isAnswerCorrect}.filter { $0 == true}
        percentProgressLabel.text = "Progress: \(Int(correctAnswer.count * 100 / allQuiz.count))%"
        intProgressLabel.text = "\(correctAnswer.count)/\(allQuiz.count)"
        intProgressLabel.isHidden = false 
        progressView.progress = Float(correctAnswer.count * 100 / allQuiz.count) / 100

    }

   
}
