//
//  NetworkingServiceable.swift
//  LydiaExercice
//
//  Created by Karbonyth on 25/03/2023.
//

import Foundation

protocol APIServiceable {
    func requestRandomUser(nb: Int) async throws -> UsersRequestCodable
    func requestPaginatedUsers(nb: Int, page: Int, seed: String) async throws -> UsersRequestCodable
}

struct APIService: HTTPClient, APIServiceable {

    func requestRandomUser(nb: Int) async throws -> UsersRequestCodable {
        do {
            return try await sendRequest(endpoint: .requestUsers(nb: nb), responseModel: UsersRequestCodable.self)
        } catch let error {
            throw error
        }
    }
    
    func requestPaginatedUsers(nb: Int, page: Int, seed: String) async throws -> UsersRequestCodable {
        do {
            return try await sendRequest(endpoint: .requestPaginatedUsers(nb: nb, page: page, seed: seed), responseModel: UsersRequestCodable.self)
        } catch let error {
            throw error
        }
    }
    
}
