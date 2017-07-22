//
//  StoryMedia.swift
//  Alive 2020
//
//  Created by Mark Stultz on 7/3/17.
//  Copyright © 2017 Summer League. All rights reserved.
//

import Foundation

struct StoryMedia {
    let id: UInt
    let storyId: UInt
    let createdAt: Date
    let updatedAt: Date
    let key: String
    let duration: UInt
    let width: UInt
    let height: UInt
    let url: URL
    let type: String
    
    init?(json: JsonDictionary) {
        guard let id = json.parse("id") else { return nil }
        guard let storyId = json.parse("storyId") else { return nil }
//        guard let createdAt = json["createdAt"] as? String else { return nil }
//        guard let updatedAt = json["updatedAt"] as? String else { return nil }
        guard let key = json["key"] as? String else { return nil }
        guard let duration = json.parse("duration") else { return nil }
        guard let width = json.parse("width") else { return nil }
        guard let height = json.parse("height") else { return nil }
        guard let urlString = json["url"] as? String else { return nil }
        guard let url = URL(string: urlString) else { return nil }
        guard let type = json["type"] as? String else { return nil }
        
        self.id = id
        self.storyId = storyId
        self.createdAt = Date()
        self.updatedAt = Date()
        self.key = key
        self.duration = duration
        self.width = width
        self.height = height
        self.url = url
        self.type = type
    }
}
