//
//  UserRepository.swift
//  LydiaExercice
//
//  Created by Karbonyth on 28/03/2023.
//

import Foundation
import CoreData

protocol UserRepository: AnyObject {
    func saveUsers(newUsers: [User])
    func loadUsers() -> [User]
}
