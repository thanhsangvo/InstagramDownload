//
//  PersistenceController.swift
//  PersistenceController
//
//  Created by Vo Thanh Sang on 05/09/2021.
//

import CoreData

struct PersistenceController {

    // A singleton for our entire app to use
        static let shared = PersistenceController()

        // Storage for Core Data
        let container: NSPersistentContainer
        
        func save() {
            let context = container.viewContext
            
            if context.hasChanges {
                do {
                    try context.save()
                    print("Coredata saved")
                } catch {
                    // Show some error here
                    let nsError = error as NSError
                    fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                }
            }
        }

        // A test configuration for SwiftUI previews
        static var preview: PersistenceController = {
            
            let result = PersistenceController(inMemory: true)

            let viewContext = result.container.viewContext

            do {
                try viewContext.save()
            } catch {
                
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }

            return result
        }()

        // An initializer to load Core Data, optionally able
        // to use an in-memory store.
        init(inMemory: Bool = false) {
            // If you didn't name your model Main you'll need
            // to change this name below.
            container = NSPersistentContainer(name: "Model")

            if inMemory {
                container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
            }

            container.loadPersistentStores { description, error in
                if let error = error {
                    fatalError("Error: \(error.localizedDescription)")
                }
            }
        }
}
