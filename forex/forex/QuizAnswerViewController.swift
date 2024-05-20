//
//  QuizAnswerViewController.swift
//  forex
//
//  Created by msklv on 18.05.24.
//

import UIKit
import AlertKit

class QuizAnswerViewController: UIViewController, HeaderViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    
    let headerView = HeaderView(frame: .zero, headerText: "Quizzes", isBackNeeded: true)
    var allQuiz = [AllQuizModel]()
    let answerButton = OrangeButton(frame: .zero, headerText: "Confirm")
    
    let quizTableView = UITableView()
    var selectedIndexPath: Int?
    let headerLabel = UILabel()
    var currentQuestion = 0
    var selectedIndex = 3
    var answers = [String]()
    var buttonCallback: (() -> Void)?
    
    var isShow = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        quizTableView.dataSource = self
        quizTableView.delegate = self
        quizTableView.register(QuizVariantsTableViewCell.self, forCellReuseIdentifier: "CustomCell")
        quizTableView.backgroundColor = .clear
        
        view.addSubview(quizTableView)
        
        view.backgroundColor = UIColor(named: "MainViewBackground")
        view.addSubview(headerView)
        headerView.delegate = self
        headerView.snp.makeConstraints { make in
            make.height.equalTo(UIView.hasTopSafeArea ? 115 : 70)
            make.left.right.top.equalToSuperview()
        }
        
        headerLabel.numberOfLines = 0
        headerLabel.font = UIFont(name: "Raleway-SemiBold", size: 16.0)
        headerLabel.textColor = .white
        headerLabel.textAlignment = .center
        quizTableView.isScrollEnabled = false
        view.addSubview(headerLabel)
        
        headerLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(headerView.snp.bottom).offset(20)
            make.height.equalTo(120)
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
        }
        
        quizTableView.snp.makeConstraints { make in
            make.height.equalTo(250)
            make.width.equalToSuperview().multipliedBy(0.95)
            make.centerX.equalToSuperview()
            make.top.equalTo(headerLabel.snp.bottom).offset(20)
        }
        
        
        
        answerButton.addTarget(self, action: #selector(confirm), for: .touchUpInside)
        view.addSubview(answerButton)
        answerButton.isEnabled = false
        answerButton.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.80)
            make.height.equalTo(56)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-24)
        }
        
        setupQuestion()
        
    }
    
    func setupQuestion() {
        if currentQuestion + 1 == allQuiz.count {
            self.buttonCallback?()
            
            self.navigationController?.popViewController(animated: true)
        } else {
            headerLabel.text = "Question \(currentQuestion + 1 ) of \(allQuiz.count) \n\n  \(allQuiz[currentQuestion].question ?? "")"
            answers = [allQuiz[currentQuestion].answer1 ?? "", allQuiz[currentQuestion].answer2 ?? "", allQuiz[currentQuestion].answer3 ?? ""]
            selectedIndex = 3
            selectedIndexPath = nil
            isShow = false
            quizTableView.reloadData()
        }
    }
    
    @objc func confirm() {
        isShow = true
        quizTableView.reloadData()
        if selectedIndex + 1 == allQuiz[currentQuestion].correctAnswer {
            AlertKitAPI.present(
                title: "Right answer",
                icon: .done,
                style: .iOS17AppleMusic,
                haptic: .success
            )
            getResult()
        } else {
            AlertKitAPI.present(
                title: "Wrong answer",
                icon: .error,
                style: .iOS17AppleMusic,
                haptic: .error
            )
            
           
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.currentQuestion += 1
                self.setupQuestion()
            }
        }
        
    }
    
    
    func getResult() {
        NetworkLayer.fetchDataFromAPI(endpoint: .quizResult(allQuiz[currentQuestion])) { data, response, error in
            
            if let error = error {
                print("Error:", error.localizedDescription)
                return
            }
            
            
            if let data = data {
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    if let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
                        print(json,jsonData)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            self.currentQuestion += 1
                            self.setupQuestion()
                            
                        }
                    }
                } catch {
                    print("Error decoding JSON:", error)
                }
            } else {
                print("No response data")
            }
        }
    }
    
    func backButtonTapped() {
        self.buttonCallback?()
        navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: - UITableViewDataSource methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return answers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! QuizVariantsTableViewCell
        cell.titleLabel.text = answers[indexPath.row]
        cell.readedStatusImageView.image = selectedIndexPath == indexPath.row ? UIImage(named: "LessonRead") :  UIImage(named: "LessonUnread")
        cell.contentViewCell.layer.borderColor = indexPath.row == ((allQuiz[currentQuestion].correctAnswer ?? 0) - 1) ? UIColor.green.cgColor : UIColor.clear.cgColor
        cell.contentViewCell.layer.borderWidth = isShow ? 2.0 : 0.0
        return cell
    }
    
    // MARK: - UITableViewDelegate methods
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let text = allQuiz[indexPath.row].answer1 ?? ""
        
        let font = UIFont.systemFont(ofSize: 14)
        
        let textHeight = text.height(withConstrainedWidth: tableView.bounds.width - 80, font: font)
        
        let cellHeight = textHeight + 20
        
        return cellHeight + 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath.row
        selectedIndex = indexPath.row
        answerButton.isEnabled = selectedIndex != 3
        tableView.reloadData()
    }
    
}


class QuizVariantsTableViewCell: UITableViewCell {
    
    var titleLabel = UILabel()
    var contentViewCell = UIView()
    var readedStatusImageView = UIImageView(image: UIImage(named: "LessonUnread"))
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        contentViewCell.backgroundColor = UIColor(named: "LessonCellBackground")
        contentViewCell.layer.cornerRadius = 12
        addSubview(contentViewCell)
        contentViewCell.addSubview(titleLabel)
        contentViewCell.addSubview(readedStatusImageView)
        
        titleLabel.font = UIFont(name: "Raleway-SemiBold", size: 16.0)
        titleLabel.textColor = .white
        
        
        titleLabel.numberOfLines = 0
        
        contentViewCell.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(10)
            make.bottom.right.equalToSuperview().offset(-10)
        }
        
        readedStatusImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.width.equalTo(30)
            make.left.equalToSuperview().offset(12)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(readedStatusImageView.snp.centerY)
            make.left.equalTo(readedStatusImageView.snp.right).offset(8)
            make.right.equalToSuperview().offset(-28)
        }
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
