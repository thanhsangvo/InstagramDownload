//
//  ContentView.swift
//  InstagramDownload
//
//  Created by Vo Thanh Sang on 10/04/2021.
//

import SwiftUI

struct ContentView: View {
    
    let persistenceController = PersistenceController.shared

    var body: some View {
        
        TabView {
            
//            Home()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
//                .tabItem {
//                    Label("Image", systemImage: "house")
//                }
            
            DownloadVideoView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .tabItem {
                    Label("Video", systemImage: "video")
                }
            
            DownloadedView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .tabItem {
                    Label("Downloaded", systemImage: "square.and.arrow.down")
                }
            

//
            

        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
