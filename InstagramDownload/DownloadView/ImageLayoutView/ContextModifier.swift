//
//  ContextModifier.swift
//  ContextModifier
//
//  Created by Vo Thanh Sang on 07/09/2021.
//

import SwiftUI

struct ContextModifier: ViewModifier {
    
    @Environment(\.managedObjectContext) var managedObjectContext

    @ObservedObject private var apiGraph = APIGraph()
    
    var instagram: Insta
    
    func body(content: Content) -> some View {
        
        content
            .contextMenu {
                Button {
                    apiGraph.writeToPhotoAlbum(image: UIImage(data: instagram.img!)!)
                    
                } label: {
                    Text("Save to Photo")
                }
                
                Button {
                    removeImage(instagram: instagram)
                } label: {
                    Text("Delete")
                        .foregroundColor(.red)
                        .fontWeight(.bold)
                }

            }
            .contentShape(RoundedRectangle(cornerRadius: 5))
            .alert(isPresented: $apiGraph.showAlert, content: {
                Alert(title: Text("Messager"), message: Text(apiGraph.alertMsg))
            })
    }
    
    func removeImage(instagram: Insta) {
        self.managedObjectContext.delete(instagram)
        do {
            try self.managedObjectContext.save()
        }catch{
            print(error)
        }
        
    }
}
