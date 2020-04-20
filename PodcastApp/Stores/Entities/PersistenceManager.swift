//
//  PersistenceManager.swift
//  PodcastApp
//
//  Created by Gavin Butler on 14-04-2020.
//  Copyright © 2020 Gavin Butler. All rights reserved.
//

import Foundation
import CoreData

class PersistenceManager {
    
    static var shared = PersistenceManager()
    
    private let persistentContainer: NSPersistentContainer
    private var isLoaded = false
    
    var mainContext: NSManagedObjectContext {
        precondition(isLoaded)
        return persistentContainer.viewContext
    }
    
    func newBackgroundContext() -> NSManagedObjectContext {
        precondition(isLoaded)
        return persistentContainer.newBackgroundContext()
    }
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "Subscriptions")
    }
    
    func initializeModel(then completion: @escaping () -> Void) {
        persistentContainer.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                fatalError("Core Data Error: \(error.localizedDescription)")
            } else {
                self.isLoaded = true
                print("Loaded Store: \(storeDescription.url?.absoluteString ?? "nil")")
                completion()
            }
        }
    }
    
    
}
