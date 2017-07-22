//
//  PreviewController.swift
//  Alive 2020
//
//  Created by Mark Stultz on 7/17/17.
//  Copyright © 2017 Summer League. All rights reserved.
//

import UIKit
import AVFoundation

class PreviewController {
    private let compositionExportProvider: CompositionExportProvider
    private let service: Service
    private let queue = DispatchQueue(label: "PreviewController.queue")
    private var exporter: CompositionExporter? = nil
    
    public lazy var viewController: PreviewViewController = {
        let viewController = PreviewViewController()
        viewController.onSubmit = self.onSubmit
        return viewController
    }()
    
    init(service: Service, compositionExportProvider: CompositionExportProvider) {
        self.service = service
        self.compositionExportProvider = compositionExportProvider
    }
    
    func onSubmit() {
        guard exporter == nil else { return }
        
        guard let export = compositionExportProvider.compositionExport(),
            let exporter = CompositionExporter(
                composition: export.composition,
                videoComposition: export.videoComposition) else {
                    return
        }
       
        exporter.progress = onProgress
        exporter.completion = onExport
        exporter.export()
        
        self.exporter = exporter
    }
    
    private func onProgress(progress: Float) {
        viewController.progressView.progress = progress
    }

    private func onExport(url: URL?) {
        guard let url = url else { return }
    
        queue.async {
            self.createJob(completion: { jobInfo in
                guard let jobInfo = jobInfo else { return }
                
                let transfer = Transfer(
                    url: url,
                    bucket: "alive2020-dev-input",
                    key: "\(jobInfo.0.referenceId).mp4",
                    credentials: jobInfo.1)
                transfer.upload()
            })
        }
    }
    
    private func createJob(completion: @escaping ((StoryJob, AwsCredentials)?) -> ()) {
        service.createStoryJob { (job, credentials) in
            if let job = job, let credentials = credentials {
                completion((job, credentials))
            } else {
                completion(nil)
            }
        }
    }
}
