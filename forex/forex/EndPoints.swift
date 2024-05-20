//
//  EndPoints.swift
//  forex
//
//  Created by msklv on 13.05.24.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    // Другие методы запроса, если необходимо
}

enum APIEndpoint {
    case users
    case posts
    case lessons
    case token
    case progress(String)
    case quiz
    case quizResult(AllQuizModel)
    case brok
    // Другие кейсы, если необходимо
    
    var baseURL: String {
        return "http://forex-academy-alb-2-335505509.us-east-1.elb.amazonaws.com/api/v1/"
    }
    
    var path: String {
        switch self {
        case .users:
            return "users/"
        case .posts:
            return "posts/"
        case .lessons:
            return "lessons/"
        case .token:
            return "token/"
        case .progress:
            return "lesson-progress/"
        case .quiz:
            return "tests/"
        case .quizResult:
            return "test-attempt/"
        case .brok:
            return "brokers/"
        }
    }
    
    var method: HTTPMethod {
          switch self {
          case .users, .posts, .token, .progress, .quizResult:
              return .post //
          case .lessons, .quiz, .brok:
              return .get
          }
      }
      
    var body: [String: Any]? {
        switch self {
        case .users:
            var userName = generateRandomString(length: 20)
            return ["username": "\(userName)", "password": "passwordForexApplication"]
        case .progress(let number):
            return ["lesson_id": number, "is_lesson_done": "true"]
        case .quizResult(let quiz):
            return ["test_id" : "\( quiz.id!)", "user_answer": "\(quiz.correctAnswer!)"]
        case .lessons, .quiz, .brok:
            return nil
        case .token:
            if let savedUserCreds = UserDefaults.standard.getUserCreds(forKey: "userCredsUD") {
                return ["username": "\(savedUserCreds.name)", "password": "\(savedUserCreds.password)"]
            } else { return nil }
        default:
            return nil
        }
    }

    func generateRandomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyz"
        return String((0..<length).map { _ in letters.randomElement()! })
    }
    
      var url: URL? {
          return URL(string: baseURL + path)
      }
}

 class NetworkLayer {
    
     static func fetchDataFromAPI(endpoint: APIEndpoint, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
         guard let url = endpoint.url else {
             completion(nil, nil, NSError(domain: "InvalidURL", code: -1, userInfo: nil))
             return
         }
         
         var request = URLRequest(url: url)
         request.httpMethod = endpoint.method.rawValue
         //let requestBody = endpoint.body
         
         if let requestBody = endpoint.body {
             do {
                 request.httpBody = try JSONSerialization.data(withJSONObject: requestBody, options: .prettyPrinted)
             } catch let error {
                 print(error.localizedDescription)
             }
             
         }
         request.addValue("application/json", forHTTPHeaderField: "Content-Type")
         request.addValue("application/json", forHTTPHeaderField: "Accept")
         
         if let savedUserCreds = UserDefaults.standard.getUserCreds(forKey: "userCredsUD") {
             print(savedUserCreds.access)
             request.setValue("Bearer \(savedUserCreds.access)", forHTTPHeaderField: "Authorization")
         }
         
         let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
             completion(data, response, error)
         }
         task.resume()
     }
 
}

