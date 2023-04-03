//
//  LocalRepositoryManagement.swift
//  LydiaExercice
//
//  Created by Stephen Sement on 29/03/2023.
//

import Foundation
import CoreData

enum CoreDataContextType {
    case main
    case background
}

protocol LocalRepositoryManagementProtocol: AnyObject {
    func getContext(_ type: CoreDataContextType) -> NSManagedObjectContext?
}

final class LocalRepositoryManagement: LocalRepositoryManagementProtocol {
    
    static let shared = LocalRepositoryManagement()
    
    private(set) lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "LydiaExercice")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func getContext(_ type: CoreDataContextType) -> NSManagedObjectContext? {
        switch type {
        case .main:
            return persistentContainer.viewContext
        case .background:
            return persistentContainer.newBackgroundContext()
        }
    }
}

