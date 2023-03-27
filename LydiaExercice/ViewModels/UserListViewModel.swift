//
//  UserListViewModel.swift
//  LydiaExercice
//
//  Created by Karbonyth on 25/03/2023.
//

import UIKit

protocol UserListDelegate: AnyObject {
    func willStartFetchingUsers()
    func didFinishFetchingUsers()
    func didFailFetchingUsers(with error: Error)
}

class UserListViewModel {
    
    private let api: APIServiceable
    private(set) var users: [User]
    private var currentPage = 1
    private var currentSeed = ""
    private(set) var isFetchingUsers = false
    private(set) var fetchedUsersCount: Int = 0
    
    weak var delegate: UserListDelegate?
    
    init(delegate: UserListDelegate? = nil,
         api: APIServiceable = APIService(),
         users: [User] = []) {
        self.delegate = delegate
        self.api = api
        self.users = users
        currentSeed = generateRandomSeed()
    }
    
    func fetchUsers() {
        guard !isFetchingUsers else { return }
        isFetchingUsers = true
        
        delegate?.willStartFetchingUsers()
        Task {
            do {
                if !users.isEmpty { self.currentPage += 1 }
                let data = try await api.requestPaginatedUsers(nb: 20, page: currentPage, seed: currentSeed)
                let newUsers = data.results.map({ User(from: $0) })
                users += newUsers
                self.fetchedUsersCount = newUsers.count
                self.delegate?.didFinishFetchingUsers()
            } catch let error {
                self.delegate?.didFailFetchingUsers(with: error)
            }
            self.isFetchingUsers = false
        }
    }
    
    func generateRandomSeed() -> String {
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
