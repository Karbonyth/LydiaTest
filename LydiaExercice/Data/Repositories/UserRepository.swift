//
//  UserRepository.swift
//  LydiaExercice
//
//  Created by Karbonyth on 28/03/2023.
//

import Foundation
import CoreData

protocol UserRepository: RepositoryManagement {
    func saveUsersToPersistence(newUsers: [User])
    func loadUsersFromPersistence() -> [User]
    func purgeUsersFromPersistence()
}
