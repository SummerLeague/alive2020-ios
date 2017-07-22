//
//  CompositionExporter.swift
//  Alive 2020
//
//  Created by Mark Stultz on 7/22/17.
//  Copyright © 2017 Summer League. All rights reserved.
//

import Foundation
import AVFoundation

class CompositionExporter {
    let session: AVAssetExportSession
    var progressTimer: Timer? = nil
    var progress: ((Float) -> ())? = nil
    var completion: ((URL?) -> ())? = nil
    
    init?(composition: AVComposition, videoComposition: AVVideoComposition) {
        guard let session = AVAssetExportSession(
            asset: composition,
            presetName: AVAssetExportPresetHighestQuality) else {
                return nil
        }
        
        session.outputFileType = AVFileTypeMPEG4
        session.outputURL = temporaryUrl(extension: "mp4")
        session.videoComposition = videoComposition
        
        self.session = session
    }
    
    public func export() {
        print(session.status)
        guard session.status == .unknown else { return }
       
        startTimer()
        
        session.exportAsynchronously { [weak self] in
            self?.complete()
        }
    }
    
    private func startTimer() {
        progressTimer?.invalidate()
        progressTimer = Timer.scheduledTimer(
            withTimeInterval: 0.005,
            repeats: true) { [weak self] timer in
                if let progress = self?.session.progress,
                    let callback = self?.progress {
                        callback(progress)
                }
        }
    }
    
    private func complete() {
        progressTimer?.invalidate()
       
        if session.status == .completed {
            completion?(nil)
        } else {
            completion?(session.outputURL)
        }
            
//        let library = ALAssetsLibrary()
//        library.writeVideoAtPath(jj
//            toSavedPhotosAlbum: url,
//            completionBlock: { (url, error) in
//                print("\(url), \(error)")
//        })
    }
}
