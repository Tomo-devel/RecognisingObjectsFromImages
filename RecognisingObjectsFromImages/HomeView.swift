//
//  ModeView.swift
//  RecognisingObjectsFromImages
//
//  Created by 井上智輝 on 2023-03-15.
//

import SwiftUI


enum Framework: CaseIterable {
    case vision
    case visionkit
    
    func changeJP() -> String {
        switch self {
        case .vision:
            return "Vision"
            
        case .visionkit:
            return "VisionKit"
        }
    }
}

enum VisionMode: CaseIterable {
    case text
    case barcode
    case face
    
    func changeJP() -> String {
        switch self {
        case .text:
            return "テキスト"
            
        case .barcode:
            return "バーコード"
            
        case .face:
            return "フェイス"
        }
    }
}

enum VisionKitMode: CaseIterable {
    case live
    case image
    
    func changeJP() -> String {
        switch self {
        case .live:
            return "ライブビデオから認識"
            
        case .image:
            return "画像から認識"
        }
    }
}


struct HomeView: View {
    @State var isShowCameraView: Bool = false
    @State var isShowPhotoLibrary: Bool = false
    @State var image: UIImage?
    
    var body: some View {
        
        VStack {
            List(Framework.allCases, id: \.self) { framework in
                Section {
                    if framework == .vision {
                        ForEach(VisionMode.allCases, id: \.self) { mode in
                            NavigationLink {
                                VisionView(mode: mode)
                                
                            } label: {
                                Text(mode.changeJP())
                            }
                        }
                        
                    } else {
                        ForEach(VisionKitMode.allCases, id: \.self) { mode in
                            NavigationLink {
                                VisionKitView(mode: mode)
                                
                            } label: {
                                Text(mode.changeJP())
                            }
                        }
                    }
                    
                } header: {
                    Text(framework.changeJP())
                }
            }
        }
    }
}

struct ModeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
