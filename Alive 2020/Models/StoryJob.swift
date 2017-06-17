//
//  StoryJob.swift
//  Alive 2020
//
//  Created by Mark Stultz on 5/14/17.
//  Copyright © 2017 Summer League. All rights reserved.
//

import Foundation

struct StoryJob {
    let referenceId: String
    
    init?(json: JsonDictionary) {
        guard let referenceId = json["referenceId"] as? String else { return nil }
        
        self.referenceId = referenceId
    }
}
