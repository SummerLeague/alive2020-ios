//
//  Story.swift
//  Alive 2020
//
//  Created by Mark Stultz on 7/3/17.
//  Copyright © 2017 Summer League. All rights reserved.
//

import Foundation

struct Story {
    let id: UInt
    let userId: UInt
    let createdAt: Date
    let updatedAt: Date
    let active: Bool
    let primaryStory: Bool
    let storyJobId: UInt
    let outputKeyPrefix: String
    let storyMedia: [StoryMedia]
    
    init?(json: JsonDictionary) {
        guard let id = json.parse("id") else { return nil }
        guard let userId = json.parse("userId") else { return nil }
//        guard let createdAt = json["createdAt"] as? String else { return nil }
//        guard let updatedAt = json["updatedAt"] as? String else { return nil }
        guard let active = json["active"] as? Bool else { return nil }
        guard let primaryStory = json["primaryStory"] as? Bool else { return nil }
        guard let storyJobId = json.parse("storyJobId") else { return nil }
        guard let outputKeyPrefix = json["outputKeyPrefix"] as? String else { return nil }
        
        self.id = id
        self.userId = userId
        self.createdAt = Date()
        self.updatedAt = Date()
        self.active = active
        self.primaryStory = primaryStory
        self.storyJobId = storyJobId
        self.outputKeyPrefix = outputKeyPrefix
        
        if let storyMedia = json["storyMedia"] as? [JsonDictionary] {
            self.storyMedia = storyMedia.flatMap { StoryMedia(json: $0) }
        } else{
            self.storyMedia = [StoryMedia]()
        }
    }
}
