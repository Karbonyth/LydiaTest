//
//  RepositoryManagement.swift
//  LydiaExercice
//
//  Created by Karbonyth on 29/03/2023.
//

import Foundation
import CoreData

protocol RepositoryManagement: AnyObject {
    func getContext() -> NSManagedObjectContext?
}

