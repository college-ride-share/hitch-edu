//
//  UserService.swift
//  hitch-edu
//
//  Created by Godson Umoren on 1/12/25.
//

import Foundation
import Combine

class UserService: APIService {
    private let baseURL = Constants.API.baseURL + "/user"
    
    func uploadProfilePhoto(userId: String, imageData: Data) -> AnyPublisher<UserResponse, APIError> {
            let endpoint = "\(baseURL)/\(userId)/upload-photo"
            
            // Create a multipart form-data boundary
            let boundary = "Boundary-\(UUID().uuidString)"
            var body = Data()
            
            // Add the file data to the multipart form
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"file\"; filename=\"photo.jpg\"\r\n")
            body.append("Content-Type: image/jpeg\r\n\r\n")
            body.append(imageData)
            body.append("\r\n--\(boundary)--\r\n")
        
        
            
            // Create headers
            let headers = [
                "Content-Type": "multipart/form-data; boundary=\(boundary)"
            ]
                    
            // Use APIService's performRequestWithRefresh to handle token expiration
            return performRequest(endpoint, method: .POST, body: body, headers: headers)
                .handleEvents(receiveSubscription: { _ in
                    print("Starting photo upload request to \(endpoint)")
                }, receiveOutput: { response in
                    print("Photo upload response received: \(response)")
                }, receiveCompletion: { completion in
                    if case let .failure(error) = completion {
                        print("Photo upload failed: \(error.localizedDescription)")
                    }
                })
                .eraseToAnyPublisher()
        }
}


fileprivate extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
