//
//  NetworkingService.swift
//  LydiaExercice
//
//  Created by Stephen Sement on 25/03/2023.
//

// TODO: Overload sendRequest without generic for requests without decode (ie. POST)

import Foundation

protocol HTTPClient {
    func sendRequest<T: Decodable>(endpoint: Endpoints,
                                   responseModel: T.Type) async throws -> T
}

extension HTTPClient {
    func sendRequest<T: Decodable>(endpoint: Endpoints,
                                   responseModel: T.Type) async throws -> T {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = endpoint.scheme
        urlComponents.host = endpoint.host
        urlComponents.path = endpoint.path
        urlComponents.queryItems = endpoint.queryItems

        guard let url = urlComponents.url else {
            throw RequestError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.header
        
        print(request)
        
        if let body = endpoint.body {
            request.httpBody = try? JSONEncoder().encode(body)
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let response = response as? HTTPURLResponse else {
                throw RequestError.noResponse
            }
            switch response.statusCode {
            case 200...299:
                let decodedResponse = try JSONDecoder().decode(responseModel, from: data)
                return decodedResponse
            case 401:
                throw RequestError.unauthorized
            default:
                throw RequestError.unexpectedStatusCode
            }
        } catch let error {
            throw error
        }

    }
}
