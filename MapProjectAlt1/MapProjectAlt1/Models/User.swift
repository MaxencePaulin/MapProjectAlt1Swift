//
//  User.swift
//  MapProjectAlt1
//
//  Created by paulin maxence on 12/01/2024.
//

import Foundation

struct User: Codable, Hashable {
    var _id: String?
    var firstName: String
    var lastName: String
    var biography: String?
    var phoneNumber: String?
    var email: String?
    var avatar: String?
    
}
