//
//  RepositoryManagement+CoreData.swift
//  LydiaExercice
//
//  Created by Karbonyth on 29/03/2023.
//

import Foundation
import CoreData

extension RepositoryManagement {
    
    func getContext() -> NSManagedObjectContext? {
        let container = NSPersistentContainer(name: "LydiaExercice")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })

        return container.viewContext
    }
    
}
