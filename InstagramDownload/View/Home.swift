//
//  Home.swift
//  InstagramDownload
//
//  Created by Vo Thanh Sang on 10/04/2021.
//

import SwiftUI

struct Home: View {
    
    @StateObject var apiGraph = APIGraph()

    @State var urlText = ""
    @State var image : Data = .init(count: 0)

    let total : CGFloat = 1
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                
                if apiGraph.image.count != 0 {
                    
                    Image(uiImage: UIImage(data: apiGraph.image)!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(20)
                        .frame(width: UIScreen.main.bounds.width - 50, height: 400)
                        .shadow(color: Color.black.opacity(0.3), radius: 5, x: 5, y: 5)
                        .padding(.bottom)
                        .contextMenu {
                            Button {
                                self.apiGraph.saveImage(apiGraph.image)
                                
                            } label: {
                                Text("Save to Photo")
                            }
                        }
                    
                }
                else {
                    Spacer()
                    
                    Text("Past url post below then tap button Download ")
                        .font(.title)
                        .foregroundColor(Color.white)
                    
                    Spacer()
                }
                                
                TextField("URL post on Instagram ", text: $urlText)
                    .padding()
                    .foregroundColor(.blue)
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(color: Color.black.opacity(0.3), radius: 5, x: 5, y: 5)
                
                HStack {
                    
                    Button(action: {
                        
                        self.apiGraph.fetchData(self.urlText)

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
            .navigationTitle("User \(apiGraph.author_name)")
            .blur(radius: apiGraph.showDownloadProgess ? 15 : 0)
            .navigationBarItems(trailing: ButtonReset)
            .preferredColorScheme(.dark)

                                    
        }
        .alert(isPresented: $apiGraph.showAlert, content: {
            Alert(title: Text("Messager"), message: Text(apiGraph.alertMsg))
        })
        .overlay(
            ZStack {
                if apiGraph.showDownloadProgess {
                    ProgressView("Downloading...", value: apiGraph.downloadProgress, total: total)
                        .padding()
                    
                }
            }
        )
        
    }
    var ButtonReset: some View {
        
        Button(action: {
            
            self.urlText = ""
            self.apiGraph.image = .init(count: 0)
            
        }, label: {
            
            Image(systemName: "arrow.counterclockwise")
                .foregroundColor(.red)
        })
    }

}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
