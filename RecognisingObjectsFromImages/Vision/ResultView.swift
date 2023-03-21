//
//  ResultView.swift
//  RecognisingObjectsFromImages
//
//  Created by 井上智輝 on 2023-03-16.
//

import SwiftUI

struct ResultView: View {
    @ObservedObject var model: VisionModel
    @State var isSee: Bool = true
    @State var labelText: String = "eye"
    let image: UIImage
    let mode: Mode
    
    var body: some View {
        
        VStack {
            if mode == .face {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()
                
                Text(model.text)
                
            } else {
                if isSee {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding()
                }
                
                List(model.result, id: \.self) { result in
                    if result.prefix(4) == "http" {
                        NavigationLink {
                            WebView(url: result)
                            
                        } label: {
                            Text(result)
                                .contextMenu {
                                    Button {
                                        UIPasteboard.general.string = result
                                        
                                    } label: {
                                        Label("リンクをコピー", systemImage: "doc.on.doc")
                                    }
                                }
                        }

                    } else {
                        Text(result)
                            .contextMenu {
                                Button {
                                    UIPasteboard.general.string = result
                                    
                                } label: {
                                    Label("リンクをコピー", systemImage: "doc.on.doc")
                                }
                            }
                    }
                }
            }
        }
        .toolbar {
            Button {
                isSee.toggle()
                
                if isSee {
                    labelText = "eye"
                    
                } else {
                    labelText = "eye.slash"
                }
                
            } label: {
                Label("画像を表示", systemImage: labelText)
            }
        }
        .task {
            model.detectedFromImage(image: image,
                                    mode: mode,
                                    frameWidth: 0.0)
        }
    }
}

struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        ResultView(model: VisionModel(),
                   image: UIImage(),
                   mode: .text)
    }
}
