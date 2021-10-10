//
//  Card.swift
//  Card
//
//  Created by Vo Thanh Sang on 04/09/2021.
//

import SwiftUI

struct Card: Identifiable, Decodable, Hashable {
    
    var id: String
    var author: String
    var url: String
    var download_url: String
    
}


struct VideoModel: Identifiable, Decodable, Hashable {
    
    var id = UUID().uuidString
    var downloadLink: String
    
}
