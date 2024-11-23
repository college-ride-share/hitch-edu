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
    let firstname: String
    let lastname: String
    let dob: String
    let isDriver: Bool

    init(from userResponse: UserResponse) {
        self.id = userResponse.id
        self.email = userResponse.email
        self.firstname = userResponse.firstname
        self.lastname = userResponse.lastname
        self.dob = userResponse.dob
        self.isDriver = userResponse.is_driver
    }
}
