//
//  Files.swift
//  Alive 2020
//
//  Created by Mark Stultz on 7/17/17.
//  Copyright © 2017 Summer League. All rights reserved.
//

import Foundation

func temporaryUrl(extension ext: String) -> URL {
    let name = "\(UUID().uuidString).\(ext)"
    let path = "\(NSTemporaryDirectory())\(name)"
    return URL(fileURLWithPath: path)
}
