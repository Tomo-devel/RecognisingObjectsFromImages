//
//  ImageAnalysisInteraction.swift
//  RecognisingObjectsFromImages
//
//  Created by 井上智輝 on 2023-05-10.
//

import UIKit
import SwiftUI
import VisionKit

@MainActor
struct LiveTextView: UIViewRepresentable {
    let image: UIImage
    let analyzerConfiguration: ImageAnalyzer.Configuration
    let imageView = LiveTextUIImageView()
    let interaction = ImageAnalysisInteraction()
    
    
    func makeUIView(context: Context) -> UIImageView {
        imageView.image = image
        imageView.addInteraction(interaction)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }
    
    func updateUIView(_ uiView: UIImageView, context: Context) {
        let analyzer = ImageAnalyzer()
        
        Task {
            if let image = imageView.image {
                let analysis = try? await analyzer.analyze(image, configuration: analyzerConfiguration)
                if let analysis = analysis {
                    interaction.analysis = analysis
                    interaction.preferredInteractionTypes = .automatic
                    interaction.selectableItemsHighlighted = true
                    interaction.allowLongPressForDataDetectorsInTextMode = true
                }
            }
        }
    }
}


class LiveTextUIImageView: UIImageView {
    override var intrinsicContentSize: CGSize {
        .zero
    }
}
