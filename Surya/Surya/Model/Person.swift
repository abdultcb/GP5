//
//  Person.swift
//  Surya
//
//  Created by Abdul on 21/02/19.
//  Copyright © 2019 VirtualEmployee. All rights reserved.
//

import UIKit

struct Person: Codable {
    var firstName: String
    var lastName: String
    var email: String
    var profilePhoto: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "firstName"
        case lastName = "lastName"
        case email = "emailId"
        case profilePhoto = "imageUrl"
    }
}

struct Result: Codable {
    var items: [Person]
}
