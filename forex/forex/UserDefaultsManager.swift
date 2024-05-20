//
//  UserDefaultsManager.swift
//  forex
//
//  Created by msklv on 13.05.24.
//

import Foundation

extension UserDefaults {
    
    func saveUserCreds(_ userCreds: UserCredsUserDefaults, forKey key: String) {
        do {
            let encoder = JSONEncoder()
            let jsonData = try encoder.encode(userCreds)
            self.set(jsonData, forKey: key)
        } catch {
            print("Error encoding user credentials:", error)
        }
    }
    
    func getUserCreds(forKey key: String) -> UserCredsUserDefaults? {
        if let jsonData = self.data(forKey: key) {
            do {
                let decoder = JSONDecoder()
                let userCreds = try decoder.decode(UserCredsUserDefaults.self, from: jsonData)
                return userCreds
            } catch {
                print("Error decoding user credentials:", error)
                return nil
            }
        } else {
            return nil
        }
    }
}
