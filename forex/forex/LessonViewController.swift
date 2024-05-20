//
//  LessonViewController.swift
//  forex
//
//  Created by msklv on 12.05.24.
//

import UIKit
import FirebaseAnalytics

class LessonViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let lessonTableView = UITableView()
    let headerView = HeaderView(frame: .zero, headerText: "School", isBackNeeded: false)
    let data = ["Lorem ipsum dolor sit amet", "Consectetur adipiscing elit", "Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua"]

    let headerLabel = UILabel()
    
    var lessonsTitleArray = [AllLessonsModel]()
    var lessonsContent = [[String]]()
    
    var descriptionTableViewLabel = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "MainViewBackground")
        view.addSubview(headerView)
        
        headerView.snp.makeConstraints { make in
            make.height.equalTo(UIView.hasTopSafeArea ? 115 : 70)
            make.left.right.top.equalToSuperview()
        }
        
        lessonTableView.dataSource = self
        lessonTableView.delegate = self
        lessonTableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "CustomCell")
        lessonTableView.backgroundColor = .clear
        
        view.addSubview(lessonTableView)
        
        headerLabel.text = "List of available courses:"
        headerLabel.font = UIFont(name: "Raleway-SemiBold", size: 20.0)
        headerLabel.textColor = .white
        
        view.addSubview(headerLabel)
        
        headerLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(headerView.snp.bottom).offset(20)
            make.bottom.equalTo(lessonTableView.snp.top).offset(-20)
        }
        
        lessonTableView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.95)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-((UIView.hasTopSafeArea ? 104 : 84) + 30))
        }
        
        if let savedUserCreds = UserDefaults.standard.getUserCreds(forKey: "userCredsUD") {
            fetchLessonAll()
        } else {
            fetchUser()
            print("User credentials not found in UserDefaults")
        }
        DispatchQueue.main.async {
            ActivityIndicatorManager.shared.showActivityIndicator()

        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Analytics.logEvent("LessonScreen", parameters: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //ActivityIndicatorManager.shared.showActivityIndicator()

    }
    
    func fetchUser() {
   
        NetworkLayer.fetchDataFromAPI(endpoint: .users) { data, response, error in
            if let error = error {
                print("Error:", error.localizedDescription)
                return
            }
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    if let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
                        if let userCreds: UserCreds = try? JSONDecoder().decode(UserCreds.self, from: jsonData) {
                            
                            let userCredsUD = UserCredsUserDefaults(name: userCreds.username ?? "", password: "passwordForexApplication", id: userCreds.id ?? "", access: userCreds.tokens?.access ?? "", refresh: userCreds.tokens?.refresh ?? "")
                            UserDefaults.standard.saveUserCreds(userCredsUD, forKey: "userCredsUD")
                            
                            self.fetchLessonAll()
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
    
    func fetchLessonAll()  {
        if let savedUserCreds = UserDefaults.standard.getUserCreds(forKey: "userCredsUD") {
            
            NetworkLayer.fetchDataFromAPI(endpoint: .lessons) { data, response, error in
                print("fetchLessonAll")

                if let httpResponse = response as? HTTPURLResponse {
                    switch httpResponse.statusCode {
                    case 403:
                        print("Access forbidden")
                        self.reOpenToken {
                            self.fetchLessonAll()
                        }
                        return
                        
                    default:
                        print("otherStatusCode")
                    }
                }
                if let error = error {
                    print("Error:", error.localizedDescription)
                    return
                }
                
                
                if let data = data {
                    
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        if let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
                            
                            if let lessonsModel: [AllLessonsModel] = try? JSONDecoder().decode([AllLessonsModel].self, from: jsonData) {
                                self.lessonsTitleArray = lessonsModel
                            
                              
                                
                                DispatchQueue.main.async {
                                    self.lessonTableView.reloadData()
                                    ActivityIndicatorManager.shared.hideActivityIndicator()

                                }
                            }
                        }
                    } catch {
                        print("Error decoding JSON:", error)
                    }
                } else {
                    print("No response data")
                }
            }
            
        } else {
            print("User credentials not found in UserDefaults")
        }
    }
    
    func separateTextByTags(_ text: String) -> [String] {
        let pattern = "(<im>.*?</im>)|(<i>.*?</i>)|([^<]*(?:<(?!/?im>|/?i>)[^<]*)*)"
        
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
            return []
        }

        // Поиск совпадений
        let matches = regex.matches(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count))

        var result = [String]()
        for match in matches {
            let range = match.range
            if range.location != NSNotFound, let range = Range(range, in: text) {
                let substring = String(text[range])
                if !substring.isEmpty {
                    result.append(substring)
                }
            }
        }

        return result.filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
    }
   
    
    func reOpenToken(completion: @escaping(()-> Void)) {
        print("fetchLessonAll")

        NetworkLayer.fetchDataFromAPI(endpoint: .token) { data, response, error in
            
            if let error = error {
                print("Error:", error.localizedDescription)
                return
            }
            
            
            if let data = data {
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    if let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
                        if let lessonsModel: UserUpdateTokens = try? JSONDecoder().decode(UserUpdateTokens.self, from: jsonData) {
                            if let savedUserCreds = UserDefaults.standard.getUserCreds(forKey: "userCredsUD") {
                                
                              var newUDModel = savedUserCreds
                                
                                newUDModel.access = lessonsModel.access ?? ""
                                newUDModel.refresh = lessonsModel.access ?? ""
                                
                                var udNew = UserCredsUserDefaults(name: newUDModel.name, password: newUDModel.password, id: newUDModel.id, access: newUDModel.access, refresh: newUDModel.refresh)
                              
                                UserDefaults.standard.saveUserCreds(udNew, forKey: "userCredsUD")
                                completion()
                            }
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
    
    
    // MARK: - UITableViewDataSource methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lessonsTitleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomTableViewCell
        
        cell.titleLabel.text = lessonsTitleArray[indexPath.row].title ?? ""
        cell.numberLabel.text = "\(indexPath.row + 1)"
        cell.timeLabel.text = calculateReadingTime(for: lessonsTitleArray[indexPath.row].content ?? "")
        cell.readedStatusImageView.image = lessonsTitleArray[indexPath.row].isDone ?? true ? UIImage(named: "LessonRead") :  UIImage(named: "LessonUnread")
        return cell
    }
    
    // MARK: - UITableViewDelegate methods
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let text = lessonsTitleArray[indexPath.row].title ?? ""

        let font = UIFont.systemFont(ofSize: 14)

        let textHeight = text.height(withConstrainedWidth: tableView.bounds.width - 140, font: font)
        
        let cellHeight = textHeight + 20
        
        return cellHeight + 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var firstLesson = lessonsTitleArray[indexPath.row].content
        
        var zxc = self.separateTextByTags(firstLesson ?? "")
        var answer = [String]()
        for xxx in zxc {
            var gg = xxx.replacingOccurrences(of: "\r\n\r\n", with: "\n\n").replacingOccurrences(of: "<im>", with: "").replacingOccurrences(of: "</im>", with: "").replacingOccurrences(of: "<fr>", with: "").replacingOccurrences(of: "</fr>", with: "")
            answer.append(gg)
        }
        
        let vc = SingleLessonViewController()
        vc.arraz = answer
        vc.numberLesson = lessonsTitleArray[indexPath.row].id ?? 0
        vc.buttonCallback = {
            self.fetchLessonAll()
               }
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func calculateReadingTime(for articleText: String) -> String {
        let wordsPerMinute = 200
        
        let wordsCount = articleText.split(separator: " ").count
        
        let minutes = Double(wordsCount) / Double(wordsPerMinute)
        let roundedMinutes = Int(ceil(minutes))
        
        if roundedMinutes == 1 {
            return "1 min"
        } else {
            return "\(roundedMinutes) min"
        }
    }

}

// Расширение для расчета высоты текста
extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(boundingBox.height)
    }
}



class CustomTableViewCell: UITableViewCell {
    var titleLabel = UILabel()
    var contentViewCell = UIView()
    var numberLabel = UILabel()
    var readedStatusImageView = UIImageView(image: UIImage(named: "LessonUnread"))
    var timeLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        numberLabel.backgroundColor = UIColor(named: "NumberLabelLessonCellBackground")
        contentViewCell.addSubview(numberLabel)
        contentViewCell.backgroundColor = UIColor(named: "LessonCellBackground")
        contentViewCell.layer.cornerRadius = 12
        numberLabel.textAlignment = .center
        addSubview(contentViewCell)
        contentViewCell.addSubview(titleLabel)
        contentViewCell.addSubview(readedStatusImageView)
        numberLabel.layer.cornerRadius = 22
        
        timeLabel.font = UIFont(name: "Raleway-Regular", size: 12.0)
        timeLabel.textColor = .lightGray

        numberLabel.font =  UIFont.boldSystemFont(ofSize: 24)
        titleLabel.font = UIFont(name: "Raleway-SemiBold", size: 16.0)
        titleLabel.textColor = .white
        timeLabel.textColor =  UIColor(named: "TimesLabelLessonCellBackground")

        numberLabel.textColor = .white
        numberLabel.clipsToBounds = true

        titleLabel.numberOfLines = 0
        contentViewCell.addSubview(timeLabel)
        
        contentViewCell.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(10)
            make.bottom.right.equalToSuperview().offset(-10)
        }
        
        numberLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.width.equalTo(44)
            make.left.equalToSuperview().offset(12)
        }
        
        readedStatusImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.width.equalTo(44)
            make.right.equalToSuperview().offset(-12)
        }
        
       
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-10)
            make.left.equalTo(numberLabel.snp.right).offset(8)
            make.right.equalTo(readedStatusImageView.snp.left).offset(-8)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.left.right.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(2)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
