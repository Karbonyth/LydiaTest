//
//  Endpoints.swift
//  LydiaExercice
//
//  Created by Stephen Sement on 25/03/2023.
//

import Foundation

var API_HOST = "randomuser.me"
var API_PATH = "/api/"

protocol Endpoint {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var method: RequestMethod { get }
    var header: [String:String]? { get }
    var body: Codable? { get }
    var queryItems: [URLQueryItem] { get }
}

extension Endpoint {
    var scheme: String {
        return "https"
    }
    
    var host: String {
        return API_HOST
    }
    
    var path: String {
        return API_PATH
    }
}

enum RequestMethod: String {
    case delete = "DELETE"
    case get = "GET"
    case patch = "PATCH"
    case post = "POST"
    case put = "PUT"
}

enum Endpoints {
    case requestPaginatedUsers(nb: Int, page: Int, seed: String)
}

extension Endpoints: Endpoint {
    var header: [String : String]? {
        nil
    }
    
    var body: Codable? {
        /// Create Extension, customize body for requests, create body codable structs. Not needed here.
        nil
    }
    
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .requestPaginatedUsers(let nb, let page, let seed):
            return [
                URLQueryItem(name: "page", value: String(page)),
                URLQueryItem(name: "results", value: String(nb)),
                URLQueryItem(name: "seed", value: seed)
            ]
        }
    }
    
    var method: RequestMethod {
        switch self {
        case .requestPaginatedUsers:
            return .get
        }
    }
}

