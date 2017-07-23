//
//  User.swift
//  Alive 2020
//
//  Created by Mark Stultz on 5/14/17.
//  Copyright © 2017 Summer League. All rights reserved.
//

import Foundation

struct User {
    let id: Int
    let username: String
    let email: String
    let authToken: String
    
    init?(json: JsonDictionary) {
        guard let id = json["id"] as? Int else { return nil }
        guard let username = json["username"] as? String else { return nil }
        guard let email = json["email"] as? String else { return nil }
        guard let authToken = json["authToken"] as? String else { return nil }
        
        self.id = id
        self.username = username
        self.email = email
        self.authToken = authToken
    }
    
    func toJson() -> JsonDictionary {
        return [
            "id": id,
            "username": username,
            "email": email,
            "authToken": authToken
        ]
    }
}
