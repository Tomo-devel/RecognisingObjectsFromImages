//
//  VisionViewModel.swift
//  RecognisingObjectsFromImages
//
//  Created by 井上智輝 on 2023-03-15.
//

import UIKit
import Vision

struct PathPoint {
    let x, y: Double
    
    struct FaceCoordinate: Identifiable {
        let id = UUID()
        let point1, point2, point3, point4: PathPoint
    }
}

struct Point {
    let x, y: Double
    let width, height: Double
}


class VisionModel: ObservableObject {
    @Published var facePoint: [PathPoint.FaceCoordinate] = []
    @Published var result: [String] = []
    @Published var text: String = ""
    var storage: [String] = []
    var strings: String = ""
    var request = VNRequest()
    
    
    func detectedFromImage(image: UIImage, mode: VisionMode, frameWidth: Double) {
        facePoint.removeAll()
        storage.removeAll()
        strings = ""
        
        switch mode {
        case .text:
            let request = VNRecognizeTextRequest { (request, error) in
                if let results = request.results as? [VNRecognizedTextObservation] {
                    let recognizedStrings = results.compactMap { observation in
                        observation.topCandidates(1).first?.string
                    }
                    
                    DispatchQueue.main.async {
                        print(recognizedStrings)
                        
                        recognizedStrings.forEach { char in
                            self.strings += char
                        }
                        
                        self.result = self.strings.components(separatedBy: CharacterSet(charactersIn: ",、\n。"))
                    }
                }
            }
            
            request.recognitionLanguages = ["ja-jp"]
            
            self.request = request
            
        case .barcode:
            let request = VNDetectBarcodesRequest { (request, error) in
                if let results = request.results as? [VNBarcodeObservation] {
                    let barcodes = results.compactMap { observation in
                        observation.payloadStringValue
                    }
                    
                    DispatchQueue.main.async {
                        barcodes.forEach { barcode in
                            self.strings += barcode
                        }
                        
                        self.result = self.strings.components(separatedBy: CharacterSet(charactersIn: ",、\n\r"))
                        self.result = self.result.filter {
                            !$0.isEmpty
                        }
                        print(self.result)
                    }
                }
            }
            
            self.request = request
            
        case .face:
            let request = VNDetectFaceRectanglesRequest { (request, error) in
                if let error {
                    print(error)
                    return
                }
                
                request.results?.forEach({ result in
                    guard let observation = result as? VNFaceObservation else {
                        return
                    }
                    
                    let scale = frameWidth / image.size.width * image.size.height
                    let height = scale * observation.boundingBox.height
                    let y = scale * (1 - observation.boundingBox.origin.y) - height
                    
                    let referenceCoordinates: Point = Point(x: frameWidth * observation.boundingBox.origin.x,
                                                            y: y,
                                                            width: frameWidth * observation.boundingBox.width,
                                                            height: height)
                    
                    let point1: PathPoint = PathPoint(x: referenceCoordinates.x,
                                                      y: referenceCoordinates.y)
                    let point2: PathPoint = PathPoint(x: referenceCoordinates.x,
                                                      y: referenceCoordinates.y + referenceCoordinates.height)
                    let point3: PathPoint = PathPoint(x: referenceCoordinates.x + referenceCoordinates.width,
                                                      y: referenceCoordinates.y + referenceCoordinates.height)
                    let point4: PathPoint = PathPoint(x: referenceCoordinates.x + referenceCoordinates.width,
                                                      y: referenceCoordinates.y)
                    
                    DispatchQueue.main.async {
                        self.facePoint.append(PathPoint.FaceCoordinate(point1: point1,
                                                                       point2: point2,
                                                                       point3: point3,
                                                                       point4: point4))
                        print(self.facePoint)
                    }
                })
            }
            
            self.request = request
        }
        
        guard let cgImage = image.cgImage else {
            return
        }
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        DispatchQueue.global().async {
            do {
                try handler.perform([self.request])
                
            } catch {
                print(error)
            }
        }
    }
}
