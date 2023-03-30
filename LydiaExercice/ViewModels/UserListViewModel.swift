//
//  UserListViewModel.swift
//  LydiaExercice
//
//  Created by Stephen Sement on 25/03/2023.
//

import UIKit
import CoreData

enum UserListUpdateType {
    case initial
    case fetch(newBatch: Bool)
}

protocol UserListDelegate: AnyObject {
    func willStartFetchingUsers()
    func didFetchUsers(updateType: UserListUpdateType)
    func didFailFetchingUsers(with error: Error)
    func didPurgeUsers()
}

class UserListViewModel: UserRepository {
    
    private let dataSource: UserRemoteDataSource
    private var users: [User]
    private var currentPage = 0
    private var currentSeed = ""
    private var initialLoad = true
    private(set) var isFetchingUsers = false
    private(set) var fetchedUsersCount: Int = 0
    
    private var searchText: String = ""
    
    weak var delegate: UserListDelegate?
    
    init(delegate: UserListDelegate? = nil,
         dataSource: UserRemoteDataSource = UserRemoteDataSource(),
         users: [User] = []) {
        self.delegate = delegate
        self.dataSource = dataSource
        self.users = users
        currentSeed = loadSeedFromPersistence() ?? generateRandomSeed()
    }
    
    func getUserCount(filteredBy text: String = "") -> Int {
        if text.isEmpty {
            return users.count
        } else {
            return getUsers(filteredBy: text).count
        }
    }
    
    func getUser(at index: Int) -> User {
        getUsers(filteredBy: searchText)[index]
    }
    
    func getUsers(filteredBy text: String = "") -> [User] {
        if text.isEmpty {
            return users
        } else {
            return users.filter( {$0.name.first.lowercased().contains(text.lowercased())} )
        }
    }
    
    func addUser(user: User) {
        users.append(user)
    }
    
    func setSearchFilter(with text: String) {
        searchText = text
    }
    
    func fetchUsers(fetchType: UserListUpdateType) {
        switch fetchType {
        case .initial:
            loadInitialUsers()
            delegate?.didFetchUsers(updateType: .initial)
            
        case .fetch(let newBatch):
            guard !isFetchingUsers else { return }
            delegate?.willStartFetchingUsers()
            Task {
                do {
                    self.isFetchingUsers = true
                    try await loadUsersFromRemote(newBatch: newBatch)
                    self.isFetchingUsers = false
                    delegate?.didFetchUsers(updateType: .fetch(newBatch: newBatch))
                } catch let error {
                    self.isFetchingUsers = false
                    self.delegate?.didFailFetchingUsers(with: error)
                }
            }

        }
    }
    
    func purgeData() {
        users.removeAll()

        purgeUsersFromPersistence()
        delegate?.didPurgeUsers()
    }
    


}

// MARK: Private Logic
private extension UserListViewModel {

    func loadInitialUsers() {
        self.users += loadUsersFromPersistence()
    }
    
    func loadUsersFromRemote(newBatch: Bool) async throws {
        if newBatch {
            users.removeAll()
            currentPage = 0
            currentSeed = generateRandomSeed()
        }
        self.currentPage += 1
        let newUsers = try await dataSource.fetchUsers(page: currentPage, seed: currentSeed)
        users += newUsers
        self.fetchedUsersCount = newUsers.count
        saveUsersToPersistence(newUsers: newUsers)
    }
    
    func generateRandomSeed() -> String {
        purgeSeedFromPersistence()
        let alphabet = "abcdefghijklmnopqrstuvwxyz"
        let length = Int.random(in: 3...6)
        var seed = ""
        for _ in 0..<length {
            let randomIndex = Int.random(in: 0..<alphabet.count)
            let randomLetter = alphabet[alphabet.index(alphabet.startIndex, offsetBy: randomIndex)]
            seed.append(randomLetter)
        }
        
        saveSeedToPersistence(seed: seed)
        return seed
    }
}
