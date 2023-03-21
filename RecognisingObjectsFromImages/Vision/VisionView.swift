//
//  VisionView.swift
//  RecognisingObjectsFromImages
//
//  Created by 井上智輝 on 2023-03-15.
//

import SwiftUI

struct VisionView: View {
    @StateObject var model: VisionModel = .init()
    @State var isShowLibrary: Bool = false
    @State var isShowCameraView: Bool = false
    @State var image: UIImage?
    let modeName: String
    let mode: Mode
    
    var body: some View {
        
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
                Image(uiImage: image!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()
                
                NavigationLink {
                    if mode == .face {
                        FaceDetectionView(model: model,
                                          image: image!,
                                          mode: mode)
                    } else {
                        ResultView(model: model,
                                   image: image!,
                                   mode: mode)
                    }
                    
                } label: {
                    HStack {
                        Text("読み取る")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .padding(2)
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(BorderedProminentButtonStyle())
                .padding()
            }
        }
        .navigationTitle(modeName)
        .toolbar {
            ToolbarItem {
                HStack {
                    Button {
                        isShowLibrary.toggle()
                        
                    } label: {
                        Label("ライブラリを開く", systemImage: "photo")
                    }
                    .sheet(isPresented: $isShowLibrary) {
                        PhotoLibrary(image: $image)
                    }
                    
                    Button {
                        isShowCameraView.toggle()
                        
                    } label: {
                        Label("写真を撮る", systemImage: "camera")
                    }
                    .fullScreenCover(isPresented: $isShowCameraView) {
                        CameraView(image: $image,
                                   isShowCameraView: $isShowCameraView)
                    }
                }
            }
        }
    }
}

struct VisionView_Previews: PreviewProvider {
    static var previews: some View {
        VisionView(modeName: "",
                   mode: .text)
    }
}
