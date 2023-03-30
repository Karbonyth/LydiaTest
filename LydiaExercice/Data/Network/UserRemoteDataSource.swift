//
//  UserRemoteDataSource.swift
//  LydiaExercice
//
//  Created by Stephen Sement on 28/03/2023.
//

import Foundation

protocol UserRemoteDataSourceProtocol: AnyObject {
    func fetchUsers(page: Int, seed: String) async throws -> [User]
}

class UserRemoteDataSource: UserRemoteDataSourceProtocol {
    private let api: APIServiceable
    
    init(api: APIServiceable = APIService()) {
        self.api = api
    }
    
    func fetchUsers(page: Int, seed: String) async throws -> [User] {
        do {
            let data = try await api.requestPaginatedUsers(nb: 20, page: page, seed: seed)
            let newUsers = data.results.map({ User(from: $0) })
            return newUsers
        } catch let error {
            throw error
        }
    }
}
