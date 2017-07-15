//
//  AwsCredentials.swift
//  Alive 2020
//
//  Created by Mark Stultz on 7/11/17.
//  Copyright © 2017 Summer League. All rights reserved.
//

import Foundation

struct AwsCredentials {
    let accessKeyId: String
    let secretAccessKey: String
    let sessionToken: String
    let expiration: String
    
    init?(json: JsonDictionary) {
        guard let accessKeyId = json["accessKeyId"] as? String else { return nil }
        guard let secretAccessKey = json["secretAccessKey"] as? String else { return nil }
        guard let sessionToken = json["sessionToken"] as? String else { return nil }
        guard let expiration = json["expiration"] as? String else { return nil }
        
        self.accessKeyId = accessKeyId
        self.secretAccessKey = secretAccessKey
        self.sessionToken = sessionToken
        self.expiration = expiration
    }
}
