//
//  RequestError.swift
//  LydiaExercice
//
//  Created by Stephen Sement on 25/03/2023.
//

import Foundation

enum RequestError: LocalizedError {
    case invalidURL
    case noResponse
    case noData
    case unauthorized
    case forbidden
    case unexpectedStatusCode(statusCode: Int)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Impossible to validate the URL"
        case .noResponse:
            return "No response from server"
        case .noData:
            return "Expected Data but got nothing"
        case .unauthorized:
            return "Unauthorized"
        case .forbidden:
            return "Forbidden"
        case .unexpectedStatusCode(let statusCode):
            return "Unexpected status code: \(statusCode)"
        }
    }
}
