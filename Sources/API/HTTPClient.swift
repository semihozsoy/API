//
//  HTTPClient.swift
//  
//
//  Created by Semih Ozsoy on 14.09.2023.
//

import Foundation

public protocol HTTPClient {
    func sendRequest<T: Decodable>(endpoint: Endpoint,
                                   responseModel: T.Type,
                                   completion: @escaping (Result<T, RequestError>) -> Void)
    
}

public extension HTTPClient {
    func sendRequest<T: Decodable>(endpoint: Endpoint,
                                   responseModel: T.Type,
                                   completion: @escaping (Result<T, RequestError>) -> Void) {
        
        let urlComponents = prepareUrlComponents(with: endpoint)
        
        guard let url = urlComponents.url else {
            return completion(.failure(.invalidUrl))
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.header
        
        if let body = endpoint.body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            do {
                guard let response = response as? HTTPURLResponse else {
                    return completion(.failure(.noResponse))
                }
                switch response.statusCode {
                case 200...299:
                    let decodedResponse = try JSONDecoder().decode(responseModel, from: data!)
                    return completion(.success(decodedResponse))
                case 401:
                    return completion(.failure(.unAuthorized))
                default:
                    return completion(.failure(.unexpectedStatusCode))
                }
            } catch {
                return completion(.failure(.decode))
            }
        }
        .resume()
    }
        
    private func prepareUrlComponents(with endpoint: Endpoint) -> URLComponents {
        var urlComponents = URLComponents()
        urlComponents.scheme = endpoint.scheme
        urlComponents.host = endpoint.host
        urlComponents.path = endpoint.path
        
        if let queryItems = endpoint.queryItems {
            urlComponents.queryItems = convertQueryItems(queryItems)
        }
        
        return urlComponents
    }
    
    private func convertQueryItems(_ stringDictionary: [String: String]?) -> [URLQueryItem] {
            var queryItems: [URLQueryItem] = []
            for (key,value) in stringDictionary ?? [:] {
                if let encodedKey = key.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                   let encodedValue = value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                    let queryItem = URLQueryItem(name: encodedKey, value: encodedValue)
                    queryItems.append(queryItem)
                }
            }
            return queryItems
        }
}
