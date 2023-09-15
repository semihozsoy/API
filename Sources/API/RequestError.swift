//
//  RequestError.swift
//  
//
//  Created by Semih Ozsoy on 9.08.2023.
//

import Foundation

public enum RequestError: Error {
    case decode
    case invalidUrl
    case noResponse
    case unAuthorized
    case unexpectedStatusCode
    case unknown
}
