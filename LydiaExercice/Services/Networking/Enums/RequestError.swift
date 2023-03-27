//
//  RequestError.swift
//  LydiaExercice
//
//  Created by Karbonyth on 25/03/2023.
//

import Foundation

enum RequestError: LocalizedError {
    case decode
    case invalidURL
    case noResponse
    case noData
    case unauthorized
    case unexpectedStatusCode
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .decode:
            return "Decode error"
        case .invalidURL:
            return "URL is not valid"
        case .noResponse:
            return "No response from server"
        case .noData:
            return "Expected Data but got nothing"
        case .unauthorized:
            return "Unauthorized"
        case .unexpectedStatusCode:
            return "Unexpected status code"
        case .unknown:
            return "Unknown Error"
        }
    }
}
