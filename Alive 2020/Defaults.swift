//
//  Defaults.swift
//  Alive 2020
//
//  Created by Mark Stultz on 7/23/17.
//  Copyright © 2017 Summer League. All rights reserved.
//

import UIKit

class Defaults {
    public static let sharedInstance = Defaults()
    private let userDefaults = UserDefaults.standard
    
    public var user: User? {
        get {
            if let dict = userDefaults.dictionary(forKey: "user") {
                return User(json: dict)
            } else {
                return nil
            }
        }
        set {
            if let json = newValue?.toJson() {
                userDefaults.set(json, forKey: "user")
            } else if userDefaults.object(forKey: "user") != nil {
                userDefaults.removeObject(forKey: "user")
            }
        }
    }
}
