//
//  UserRepository.swift
//  LydiaExercice
//
//  Created by Karbonyth on 28/03/2023.
//

import Foundation
import CoreData

protocol UserRepository: AnyObject {
    func saveUsersToPersistence(newUsers: [User], context: NSManagedObjectContext?)
    func loadUsersFromPersistence(context: NSManagedObjectContext?) -> [User]
    func purgeUsersFromPersistence(context: NSManagedObjectContext?, completion: @escaping () -> Void)
}
