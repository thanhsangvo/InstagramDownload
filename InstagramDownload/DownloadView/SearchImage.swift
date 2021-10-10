//
//  SearchImage.swift
//  SearchImage
//
//  Created by Vo Thanh Sang on 05/09/2021.
//

import SwiftUI

struct SearchImage: View {
    
    @Binding var searchtxt : String
    
    var body: some View {
        
        HStack {
            
            Image(systemName: "magnifyingglass")
                .font(.system(size: 20))
                .padding(.horizontal)
            
            TextField("Seach...", text: $searchtxt)
                .frame(height: 40)
            
            if searchtxt != "" {
                
                Button(action: {
                    withAnimation {
                        self.searchtxt = ""
                    }
                }, label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                })
                .padding(.trailing)
            }
        }
        .background(Color.gray.opacity(0.2))
        .cornerRadius(20)
        .padding(.horizontal)
        
    }
}
