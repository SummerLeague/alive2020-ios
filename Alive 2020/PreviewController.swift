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
    private var exporter: CompositionExporter? = nil
    
    public lazy var viewController: PreviewViewController = {
        let viewController = PreviewViewController()
        viewController.onSubmit = self.onSubmit
        return viewController
    }()
    
    init(compositionExportProvider: CompositionExportProvider) {
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
       
        exporter.progress = { [weak self] progress in
            UIView.animate(withDuration: 0.05, animations: {
                self?.viewController.progressView.progress = progress
            })
        }
        
        exporter.export()
        self.exporter = exporter
    }
}
