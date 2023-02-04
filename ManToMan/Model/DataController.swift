//
//  DataController.swift
//  Kyupago
//
//  Created by Kyubo Shim on 2023/01/27.
//


import Foundation
import CoreData

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "RecentLog")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Failed to load data in DataController \(error.localizedDescription)")
            }
        }
    }
    
    func save(context: NSManagedObjectContext) {
        do {
            try context.save()
            print("Data saved successfully. WUHU!!!")
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func addRecent(sentence: String, context: NSManagedObjectContext) {
        let recent = Recent(context: context)
        recent.sentence = sentence
        recent.date = Date()
        
        save(context: context)
    }
}
