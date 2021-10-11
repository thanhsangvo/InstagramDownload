//
//  LayoutType.swift
//  LayoutType
//
//  Created by Vo Thanh Sang on 07/09/2021.
//

import SwiftUI

enum LayoutType:  CaseIterable {
    case double
    case adaptive
}

extension LayoutType {
    
    var columns: [GridItem] {
        switch self {
            
        case .double:
            return [
                GridItem(.flexible(), spacing: 1),
                GridItem(.flexible(), spacing: 1)
            ]
            
        case .adaptive:
            return [
                GridItem(.adaptive(minimum: 100), spacing: 1)
            ]
        }
    }
    
}
