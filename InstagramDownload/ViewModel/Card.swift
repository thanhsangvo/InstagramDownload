//
//  Card.swift
//  Card
//
//  Created by Vo Thanh Sang on 04/09/2021.
//

import SwiftUI

struct VideoModel: Identifiable, Decodable, Hashable {
    
    var id = UUID().uuidString
    var downloadLink: String
    
}
