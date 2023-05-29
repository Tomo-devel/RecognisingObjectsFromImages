//
//  DataScanner.swift
//  RecognisingObjectsFromImages
//
//  Created by 井上智輝 on 2023-05-10.
//

import Foundation
import VisionKit
import SwiftUI

struct DataScanner: UIViewControllerRepresentable {
    @Binding var isScanning: Bool
    @Binding var isShowAlert: Bool
    @Binding var topLeft: [Double]
    @Binding var topRight: [Double]
    @Binding var bottomLeft: [Double]
    @Binding var bottomRight: [Double]
    @Binding var code: String
    
    
    func makeUIViewController(context: Context) -> DataScannerViewController {
        let controller = DataScannerViewController(recognizedDataTypes: [.text(), .barcode()],
                                                   qualityLevel: .balanced,
                                                   recognizesMultipleItems: true,
                                                   isPinchToZoomEnabled: true,
                                                   isHighlightingEnabled: true)
        
        controller.delegate = context.coordinator
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: DataScannerViewController, context: Context) {
        if isScanning {
            do {
                try uiViewController.startScanning()
                
            } catch(let error) {
                print(error)
            }
            
        } else {
            uiViewController.stopScanning()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    
    class Coordinator: NSObject, DataScannerViewControllerDelegate {
        var parent: DataScanner
        
        init(_ parent: DataScanner) {
            self.parent = parent
        }
        
        func dataScanner(_ dataScanner: DataScannerViewController, didAdd addedItems: [RecognizedItem], allItems: [RecognizedItem]) {
            for additem in addedItems {
                parent.topLeft = [additem.bounds.topLeft.x, additem.bounds.topLeft.y]
                parent.topRight = [additem.bounds.topRight.x, additem.bounds.topRight.y]
                parent.bottomLeft = [additem.bounds.bottomLeft.x, additem.bounds.bottomLeft.y]
                parent.bottomRight = [additem.bounds.bottomRight.x, additem.bounds.bottomRight.y]
            }
        }
        
        func dataScanner(_ dataScanner: DataScannerViewController, didTapOn item: RecognizedItem) {
            switch item {
            case .text(let text):
                parent.code = text.transcript
                print(text.transcript)
                
            case .barcode(let barcode):
                if let code = barcode.payloadStringValue {
                    parent.code = code
                    print(code)
                }
                
            default:
                break
            }
        }
        
        func dataScanner(_ dataScanner: DataScannerViewController, becameUnavailableWithError error: DataScannerViewController.ScanningUnavailable) {
            switch error {
            case .cameraRestricted:
                print("カメラの使用を許可してください。")
                parent.isShowAlert = true
                
            case .unsupported:
                print("このデバイスをはサポートされていません。")
                
            default:
                print(error.localizedDescription)
            }
        }
    }
}
