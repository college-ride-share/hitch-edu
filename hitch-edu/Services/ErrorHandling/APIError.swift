//
//  APIError.swift
//  hitch-edu
//
//  Created by Godson Umoren on 11/20/24.
//

import Foundation

enum APIError: LocalizedError {
    case invalidURL
    case invalidResponse
    case serverError(Int)
    case decodingError(DecodingError)
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL is invalid."
        case .invalidResponse:
            return "The server response was invalid."
        case .serverError(let statusCode):
            return "Server error with status code: \(statusCode)"
        case .decodingError(let decodingError):
            return "Failed to decode the response: \(decodingError.localizedDescription)"
        case .unknown(let error):
            return "An unknown error occurred: \(error.localizedDescription)"
        }
    }
}
