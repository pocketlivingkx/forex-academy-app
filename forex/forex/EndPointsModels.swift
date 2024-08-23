//
//  EndPointsModels.swift
//  forex
//
//  Created by msklv on 13.05.24.
//

import Foundation
import Foundation


// MARK: - AfterLoginUser

struct UserCreds: Codable {
    let id, username, firstName, lastName: String?
    let email: String?
    let tokens: Tokens?

    enum CodingKeys: String, CodingKey {
        case id, username
        case firstName = "first_name"
        case lastName = "last_name"
        case email, tokens
    }
}

// MARK: - Tokens

struct Tokens: Codable {
    let refresh, access: String?
}



// MARK: - AllLessonsModel

struct AllLessonsModel: Codable {
    let id: Int?
    let title, content: String?
    let isDone: Bool?
    let order: Int?

    enum CodingKeys: String, CodingKey {
        case id, title, content
        case isDone = "is_done"
        case order
    }
}

// MARK: - UserUpdateTokens

struct UserUpdateTokens: Codable {
    let refresh, access: String?
}

// MARK: - UserDefaults UserModel

struct UserCredsUserDefaults: Codable {
    let name: String
    let password: String
    let id: String
    var access: String
    var refresh: String
}



struct AllQuizModel: Codable {
    let id: Int?
    let question, answer1, answer2, answer3: String?
    let answer4, answer5: String?
    let correctAnswer: Int?
    let isAnswerCorrect: Bool?

    enum CodingKeys: String, CodingKey {
        case id, question, answer1, answer2, answer3, answer4, answer5
        case correctAnswer = "correct_answer"
        case isAnswerCorrect = "is_answer_correct"
    }
}



struct BrokersModel: Codable {
    let brokerInfo: String?
    let data: [ResultBrouk]?
}

// MARK: - Result

struct ResultBrouk: Codable {
    let brokerName: String?
    let minDeposit: Int?
    let link: String?
    let brokerImage: String?
    let description: String?

    enum CodingKeys: String, CodingKey {
        case brokerName = "broker_name"
        case minDeposit = "min_deposit"
        case link
        case brokerImage = "broker_image"
        case description = "description"
    }
}
