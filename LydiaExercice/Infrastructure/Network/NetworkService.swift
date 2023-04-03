//
//  NetworkingService.swift
//  LydiaExercice
//
//  Created by Stephen Sement on 25/03/2023.
//

import Foundation

protocol HTTPClient {
    func sendRequest<T: Decodable>(endpoint: Endpoints,
                                   responseModel: T.Type) async throws -> T
    func sendRequest(endpoint: Endpoints) async throws
}

extension HTTPClient {
    func sendRequest<T: Decodable>(endpoint: Endpoints,
                                   responseModel: T.Type) async throws -> T {
        
        guard let url = buildURL(for: endpoint) else {
            throw RequestError.invalidURL
        }
        
        do {
            let request = try buildURLRequest(for: endpoint, with: url)
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let response = response as? HTTPURLResponse else {
                throw RequestError.noResponse
            }
            guard !data.isEmpty else {
                throw RequestError.noData
            }

            switch response.statusCode {
            case 200...299:
                let decodedResponse = try JSONDecoder().decode(responseModel, from: data)
                return decodedResponse
            case 401:
                throw RequestError.unauthorized
            case 403:
                throw RequestError.forbidden
            default:
                throw RequestError.unexpectedStatusCode(statusCode: response.statusCode)
            }
        } catch let error {
            throw error
        }

    }
    
    func sendRequest(endpoint: Endpoints) async throws {
        
        guard let url = buildURL(for: endpoint) else {
            throw RequestError.invalidURL
        }
        
        do {
            let request = try buildURLRequest(for: endpoint, with: url)
            let (_, response) = try await URLSession.shared.data(for: request)
            guard let response = response as? HTTPURLResponse else {
                throw RequestError.noResponse
            }
            switch response.statusCode {
            case 200...299:()
            case 401:
                throw RequestError.unauthorized
            case 403:
                throw RequestError.forbidden
            default:
                throw RequestError.unexpectedStatusCode(statusCode: response.statusCode)
            }
        } catch let error {
            throw error
        }
    }

}

extension HTTPClient {
    
    /// Builds an URL from the information (scheme, host, path, and query items) present in the endpoint definition
    func buildURL(for endpoint: Endpoints) -> URL? {
        
        var urlComponents = URLComponents()

        urlComponents.scheme = endpoint.scheme
        urlComponents.host = endpoint.host
        urlComponents.path = endpoint.path
        urlComponents.queryItems = endpoint.queryItems
        
        return urlComponents.url
    }
    
    /// Builds an URLRequest from the information (HTTP method, HTTP headers, and body) present in the endpoint definition, as well as a valid URL created with the **buildURL(for:)** function.
    func buildURLRequest(for endpoint: Endpoints, with url: URL) throws -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.header

        if let body = endpoint.body {
            do {
                request.httpBody = try JSONEncoder().encode(body)
            } catch let error {
                throw error
            }
        }
        
        return request
    }
    
}
