//
//  UserListViewModel.swift
//  LydiaExercice
//
//  Created by Karbonyth on 25/03/2023.
//

import UIKit
import CoreData

protocol UserListDelegate: AnyObject {
    func willStartFetchingUsers()
    func didFinishFetchingUsers()
    func didFailFetchingUsers(with error: Error)
}

class UserListViewModel: UserRepository {
    
    private let dataSource: UserRemoteDataSource
    private(set) var users: [User]
    private var currentPage = 0
    private var currentSeed = ""
    private var initialLoad = true
    private(set) var isFetchingUsers = false
    private(set) var fetchedUsersCount: Int = 0
    
    lazy var context: NSManagedObjectContext = {
        let container = NSPersistentContainer(name: "LydiaExercice")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container.viewContext
    }()
    
    weak var delegate: UserListDelegate?
    
    init(delegate: UserListDelegate? = nil,
         dataSource: UserRemoteDataSource = UserRemoteDataSource(),
         users: [User] = []) {
        self.delegate = delegate
        self.dataSource = dataSource
        self.users = users
        self.users += loadUsers()
        currentSeed = generateRandomSeed()
    }
    
    func fetchUsers() {
        guard !isFetchingUsers else { return }
        isFetchingUsers = true
        
        delegate?.willStartFetchingUsers()
        Task {
            do {
                self.currentPage += 1
                let newUsers = try await dataSource.fetchUsers(page: currentPage, seed: currentSeed)
                users += newUsers
                self.fetchedUsersCount = newUsers.count
                saveUsers(newUsers: newUsers)
                self.delegate?.didFinishFetchingUsers()
            } catch let error {
                self.delegate?.didFailFetchingUsers(with: error)
            }
            self.isFetchingUsers = false
        }
    }
    
    private func generateRandomSeed() -> String {
        let alphabet = "abcdefghijklmnopqrstuvwxyz"
        let length = Int.random(in: 3...6)
        var seed = ""
        for _ in 0..<length {
            let randomIndex = Int.random(in: 0..<alphabet.count)
            let randomLetter = alphabet[alphabet.index(alphabet.startIndex, offsetBy: randomIndex)]
            seed.append(randomLetter)
        }
        return seed
    }
}
