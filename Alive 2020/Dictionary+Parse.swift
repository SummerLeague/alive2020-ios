//
//  Dictionary+Parse.swift
//  Alive 2020
//
//  Created by Mark Stultz on 7/15/17.
//  Copyright © 2017 Summer League. All rights reserved.
//

import Foundation

extension Dictionary where Key == String, Value == Any {
    func parse(_ key: String) -> UInt? {
        switch self[key] {
            case let value as NSNumber: return value.uintValue
            case let value as String: return UInt(value)
            case let value as Int: return UInt(value)
            default: return nil
        }
    }
}
