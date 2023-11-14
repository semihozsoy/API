//
//  Endpoint.swift
//  
//
//  Created by Semih Ozsoy on 9.08.2023.
//

import Foundation

public protocol Endpoint {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var method: RequestMethod { get }
    var header: [String: String]? { get }
    var body: [String: String]? { get }
    var queryItems: [URLQueryItem]? { get }
}

extension Endpoint {
    public var scheme: String {
        return "https"
    }
    
    public var host: String {
        /// host should be which url we want to implement
        return ""
    }
}
