//
//  VisionKitView.swift
//  RecognisingObjectsFromImages
//
//  Created by 井上智輝 on 2023-03-15.
//

import SwiftUI
import VisionKit

struct VisionKitView: View {
    @State var isScanning: Bool = false
    @State var isShowAlert: Bool = false
    @State var isShowLibrary: Bool = false
    @State var isShowCameraView: Bool = false
    @State var topLeft: [Double] = [0.0, 0.0]
    @State var topRight: [Double] = [0.0, 0.0]
    @State var bottomLeft: [Double] = [0.0, 0.0]
    @State var bottomRight: [Double] = [0.0, 0.0]
    @State var code: String = ""
    @State var image: UIImage?
    let mode: VisionKitMode
    
    var body: some View {
        
        VStack {
            if mode == .live {
                VStack {
                    DataScanner(isScanning: $isScanning,
                                isShowAlert: $isShowAlert,
                                topLeft: $topLeft,
                                topRight: $topRight,
                                bottomLeft: $bottomLeft,
                                bottomRight: $bottomRight,
                                code: $code)
                    
                    ScrollView {
                        Text(code)
                            .padding()
                            .textSelection(.enabled)
                    }
                }
                .task {
                    isScanning.toggle()
                }
                
            } else {
                VStack {
                    if image == nil {
                        Button {
                            isShowLibrary.toggle()
                            
                        } label: {
                            Label("写真を選ぶ", systemImage: "photo")
                                .font(.title)
                        }
                        .sheet(isPresented: $isShowLibrary) {
                            PhotoLibrary(image: $image)
                        }
                        
                        Button {
                            isShowCameraView.toggle()
                            
                        } label: {
                            Label("写真を撮る", systemImage: "camera")
                                .font(.title)
                        }
                        .padding()
                        .fullScreenCover(isPresented: $isShowCameraView) {
                            CameraView(image: $image,
                                       isShowCameraView: $isShowCameraView)
                        }
                        
                    } else {
                        LiveTextView(image: image!,
                                     analyzerConfiguration: .init([.machineReadableCode, .text]))
                    }
                }
                .toolbar {
                    Button {
                        image = nil
                        isShowCameraView.toggle()
                        
                    } label: {
                        Label("写真を撮る", systemImage: "camera")
                    }
                    .fullScreenCover(isPresented: $isShowCameraView) {
                        CameraView(image: $image,
                                   isShowCameraView: $isShowCameraView)
                    }
                    
                    Button {
                        image = nil
                        isShowLibrary.toggle()
                        
                    } label: {
                        Label("写真を選ぶ", systemImage: "photo")
                    }
                    .sheet(isPresented: $isShowLibrary) {
                        PhotoLibrary(image: $image)
                    }
                }
            }
        }
        .navigationTitle(mode.changeJP())
        .alert(isPresented: $isShowAlert) {
            Alert(title: Text("使用許可"),
                  message: Text("この機能を使用するにはカメラの使用許可が必要です。"),
                  primaryButton: .cancel(),
                  secondaryButton: .default(Text("設定"), action: {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }))
        }
    }
}

struct VisionKitView_Previews: PreviewProvider {
    static var previews: some View {
        VisionKitView(mode: .image)
    }
}
