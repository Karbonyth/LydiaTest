//
//  RepositoryManagement+CoreData.swift
//  LydiaExercice
//
//  Created by Karbonyth on 29/03/2023.
//

import UIKit
import CoreData

extension RepositoryManagement {

    func getContext() -> NSManagedObjectContext? {
        var context: NSManagedObjectContext?
        
        if Thread.isMainThread {
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            context = appDelegate?.persistentContainer.viewContext
        } else {
            DispatchQueue.main.sync {
                let appDelegate = UIApplication.shared.delegate as? AppDelegate
                context = appDelegate?.persistentContainer.viewContext
            }
        }
        
        return context
    }
    
}
