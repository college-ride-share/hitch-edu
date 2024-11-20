//
//  UserModel.swift
//  hitch-edu
//
//  Created by Godson Umoren on 11/20/24.
//

import Foundation


struct User: Codable {
    let id: String
    let email: String
    let name: String
    let isDriver: Bool

    init(from userResponse: UserResponse) {
        self.id = userResponse.id
        self.email = userResponse.email
        self.name = userResponse.name
        self.isDriver = userResponse.is_driver
    }
}
