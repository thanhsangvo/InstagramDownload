//
//  Downloaded.swift
//  Downloaded
//
//  Created by Vo Thanh Sang on 04/09/2021.
//

import SwiftUI

struct DownloadedView: View {
    
    @State private var userFilter = ""

    var body: some View {
        
        VStack {
            
            SearchImage(searchtxt: $userFilter)
            
            ImageLayout()
        }
        
    }
    
}

struct DownloadedView_Previews: PreviewProvider {
    static var previews: some View {
        DownloadedView()
    }
}
