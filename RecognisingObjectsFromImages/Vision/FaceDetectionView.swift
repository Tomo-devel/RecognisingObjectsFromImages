//
//  FaceDetectionView.swift
//  RecognisingObjectsFromImages
//
//  Created by 井上智輝 on 2023-03-20.
//

import SwiftUI

struct FaceDetectionView: View {
    @ObservedObject var model: VisionModel
    let image: UIImage
    let mode: Mode
    
    var body: some View {
        
        GeometryReader { geometry in
            VStack {
                Spacer()
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()
                    .overlay {
                        ForEach(model.facePoint) { point in
                            Path { path in
                                path.addLines([
                                    CGPoint(x: point.point1.x, y: point.point1.y),
                                    CGPoint(x: point.point2.x, y: point.point2.y),
                                    CGPoint(x: point.point3.x, y: point.point3.y),
                                    CGPoint(x: point.point4.x, y: point.point4.y),
                                    CGPoint(x: point.point1.x, y: point.point1.y)
                                ])
                            }
                            .stroke(.green, lineWidth: 2)
                        }
                    }
                
                Spacer()
            }
            .task {
                model.detectedFromImage(image: image,
                                        mode: mode,
                                        frameWidth: geometry.size.width)
            }
        }
    }
}

struct FaceDetectionView_Previews: PreviewProvider {
    static var previews: some View {
        FaceDetectionView(model: VisionModel(), image: UIImage(), mode: .face)
    }
}
