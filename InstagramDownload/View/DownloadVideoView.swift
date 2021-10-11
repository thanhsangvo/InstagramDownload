//
//  DownloadVideoView.swift
//  InstagramDownload
//
//  Created by Vo Thanh Sang on 09/10/2021.
//

import SwiftUI
import AVKit

struct DownloadVideoView: View {
    
    @StateObject var apiGraph = APIGraph()

    @State var urlText = ""
    
    let screen = UIScreen.main.bounds
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                
                VStack {
                    
                    if apiGraph.linkVideo != "" {
                        
                        playerView(url: $apiGraph.linkVideo)
                            .frame(height: screen.height * 0.5)
                            .contextMenu {
                                Button {
                                    self.apiGraph.saveVideoToAlbum(urlVideo: apiGraph.linkVideo)
                                } label: {
                                    Text("Save to Photo")
                                }
                            }
                        
                    } else {
                        
                        Text("Past url post below then tap button Download ")
                            .font(.title)
                            .foregroundColor(Color.white)
                    }
                }

                
                TextField("URL video post on Instagram ", text: $urlText)
                    .padding()
                    .foregroundColor(.blue)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                
                HStack {
                    
                    Button(action: {
                        apiGraph.startDownloadVideo(urlString: urlText)

                    }, label: {
                        Text("Download")
                            .fontWeight(.semibold)
                            .padding(.vertical)
                            .padding(.horizontal)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .clipShape(Capsule())
                            .shadow(color: Color.black.opacity(0.3), radius: 6, x: 5, y: 5)
                    })
                }
                .padding(.top)
            }
            .padding(.horizontal)
            .navigationBarItems(trailing: ButtonReset)
            .preferredColorScheme(.dark)
        }
    }
    
    var ButtonReset: some View {
        
        Button(action: {
            
            self.urlText = ""
            
        }, label: {
            
            Image(systemName: "arrow.counterclockwise")
                .foregroundColor(.red)
        })
    }
}

struct DownloadVideoView_Previews: PreviewProvider {
    static var previews: some View {
        DownloadVideoView()
    }
}

struct playerView: UIViewControllerRepresentable {
    
    @Binding var url : String
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<playerView>) -> AVPlayerViewController {
        
        let controller = AVPlayerViewController()
        let player = AVPlayer(url: URL(string: url)!)
        controller.player = player
        return controller
        
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: UIViewControllerRepresentableContext<playerView>) {
        
        
    }
}
