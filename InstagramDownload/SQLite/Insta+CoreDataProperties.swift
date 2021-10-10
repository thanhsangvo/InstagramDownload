//
//  Insta+CoreDataProperties.swift
//  Insta
//
//  Created by Vo Thanh Sang on 06/09/2021.
//
//

import Foundation
import CoreData


extension Insta {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Insta> {
        return NSFetchRequest<Insta>(entityName: "Insta")
    }

    @NSManaged public var user: String?
    @NSManaged public var img: Data?
    
    var wrappedUser: String {
        user ?? "Unknown"
    }

}

extension Insta : Identifiable {
    
}
