//
//  SingleLessonViewController.swift
//  forex
//
//  Created by msklv on 16.05.24.
//

import UIKit
import SnapKit
import Kingfisher

class SingleLessonViewController: UIViewController, HeaderViewDelegate {
    let headerView = HeaderView(frame: .zero, headerText: "School", isBackNeeded: true)
        //https://forex-academy-images.s3.amazonaws.com/1_introduction_header.png
    
    
    var arraz = [String]()
    var numberLesson = 0
    var buttonCallback: (() -> Void)?
    let contentView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "MainViewBackground")
        view.addSubview(headerView)
        headerView.delegate = self
        headerView.snp.makeConstraints { make in
            make.height.equalTo(UIView.hasTopSafeArea ? 115 : 70)
            make.left.right.top.equalToSuperview()
        }
        
        setupScrollView()

    }

    
    func backButtonTapped() {
            navigationController?.popViewController(animated: true)
        }
    
    func setupScrollView() {
        
        
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(20)
            make.bottom.left.right.equalToSuperview()
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            //make.edges.equalToSuperview()
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-30)
            make.width.equalTo(view.snp.width)
        }
        
        let stackView = UIStackView()
             stackView.axis = .vertical
             stackView.spacing = 10
             stackView.alignment = .center

        contentView.addSubview(stackView)
             stackView.snp.makeConstraints { make in
                 make.top.equalToSuperview().offset(20)
                 make.leading.trailing.equalToSuperview().inset(20)
                 make.bottom.lessThanOrEqualToSuperview().offset(-20)
             }
        
        for element in arraz {
            var views = UIView()
            
            if isValidURL(element) {
                let imageView = UIImageView()
                //imageView.contentMode = .scaleAspectFit
                stackView.addArrangedSubview(views)
                imageView.layer.cornerRadius = 16
                imageView.layer.masksToBounds = true
                views.addSubview(imageView)
                views.layer.cornerRadius = 16
                views.layer.masksToBounds = true
                views.clipsToBounds = true
                imageView.clipsToBounds = true
                let url = URL(string: element)
                imageView.kf.indicatorType = .activity
                imageView.kf.setImage(with: url)

                views.snp.makeConstraints { make in
                    make.width.equalToSuperview().multipliedBy(0.95)
                    make.height.equalTo(views.snp.width).multipliedBy(0.7)
                }
                
                imageView.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
            } else {
              
                    var withView = element.contains("<i>")
                    let label = UILabel()
                var elements = element.replacingOccurrences(of: "<i>", with: "").replacingOccurrences(of: "</i>", with: "")
                    label.numberOfLines = 0
                    label.font = UIFont(name: "Raleway-Medium", size: 16.0)
                    label.textColor =  withView ? .white : UIColor(named: "TimesLabelLessonCellBackground")
                views.layer.cornerRadius = 14
                views.layer.masksToBounds = true
                views.clipsToBounds = true
                    label.textAlignment = .left
                    label.numberOfLines = 0
                    label.text = elements
                views.backgroundColor = withView ? UIColor(named: "LessonBG") : .clear
                    let paragraphStyle = NSMutableParagraphStyle()
                    paragraphStyle.lineSpacing = 8
                    
                    let attributedString = NSAttributedString(string: elements, attributes: [
                        .paragraphStyle: paragraphStyle
                    ])
                    
                    label.attributedText = attributedString
                    
                    let attributedText = applyBoldTags(to: elements)
                    
                    label.attributedText = attributedText
                    stackView.addArrangedSubview(views)
                    
                    views.snp.makeConstraints { make in
                        make.width.equalToSuperview()
                        //make.height.equalTo(views.snp.width).multipliedBy(0.7)
                    }
                    views.addSubview(label)
                    
                    label.snp.makeConstraints { make in
                        make.edges.equalToSuperview().inset(10)
                    }
                
            }
        }
        
        var buttonView = UIView()
        var buttonRead = OrangeButton(frame: .zero, headerText: "I have read")
        buttonRead.addTarget(self, action: #selector(readLesson), for: .touchUpInside)
        stackView.addArrangedSubview(buttonView)
        buttonView.addSubview(buttonRead)
        
        buttonView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(100)
        }
        
        buttonRead.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.65)
            make.height.equalTo(56)
            make.centerX.equalToSuperview()
        }

    }
    
    @objc func readLesson() {
        ActivityIndicatorManager.shared.showActivityIndicator()

        
        NetworkLayer.fetchDataFromAPI(endpoint: .progress("\(numberLesson)")) { data, response, error in
            
            if let error = error {
                print("Error:", error.localizedDescription)
                return
            }
            
            
            if let data = data {
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    if let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
                        print(json,jsonData)
                        DispatchQueue.main.async {
                            self.buttonCallback?()
                            self.navigationController?.popViewController(animated: true)
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
    
    func applyBoldTags(to text: String) -> NSAttributedString {
        let regex = try! NSRegularExpression(pattern: "<b>(.*?)</b>", options: [])
        let matches = regex.matches(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count))
        
        let attributedString = NSMutableAttributedString(string: text)
        let customFont = UIFont(name: "Raleway-Bold", size: 20.0) ?? UIFont.boldSystemFont(ofSize: 16.0)
        
        var offset = 0
        for match in matches {
            let adjustedRange = NSRange(location: match.range.location - offset, length: match.range.length)
            if let range = Range(adjustedRange, in: attributedString.string) {
                let boldText = attributedString.string[range]
                let nsRange = NSRange(range, in: attributedString.string)
                
                // Remove the <b> and </b> tags
                let cleanBoldText = boldText.replacingOccurrences(of: "<b>", with: "").replacingOccurrences(of: "</b>", with: "")
                attributedString.replaceCharacters(in: nsRange, with: cleanBoldText)
                
                let cleanRange = NSRange(location: nsRange.location, length: cleanBoldText.utf16.count)
                attributedString.addAttribute(.font, value: customFont, range: cleanRange)
                
                offset += (boldText.utf16.count - cleanBoldText.utf16.count)
            }
        }
        
        return attributedString
    }
    
    
    
    func isValidURL(_ string: String) -> Bool {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        if let match = detector.firstMatch(in: string, options: [], range: NSRange(location: 0, length: string.utf16.count)) {
            return match.range.length == string.utf16.count
        } else {
            return false
        }
    }

}
