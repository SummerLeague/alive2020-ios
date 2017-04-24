//
//  UploadOperation.swift
//  Alive 2020
//
//  Created by Mark Stultz on 4/23/17.
//  Copyright © 2017 Summer League. All rights reserved.
//

import Foundation

class UploadOperation: Operation {
    let startBlock: ((UploadOperation) -> ())?
    let progressBlock: ((Progress) -> ())?
    let progress = Progress(totalUnitCount: 100)
    
    init(start: ((UploadOperation) -> ())?, progress: ((Progress) -> ())?) {
        startBlock = start
        progressBlock = progress
    }
   
    override func start() {
        startBlock?(self)
        super.start()
    }
    
    override func main() {
        guard !isCancelled else { return }
      
        while true {
            guard progress.completedUnitCount != 100 else { break }
            
            sleep(1)
            progress.completedUnitCount = min(100, progress.completedUnitCount + 20)
            progressBlock?(progress)
        }
    }
}
