//
//  Place.swift
//  MapProjectAlt1
//
//  Created by paulin maxence on 12/01/2024.
//

import Foundation
import MapKit

struct Place: Codable, Hashable, Identifiable {
    var id: UUID?
    var _id: String
    var name: String
    var latitude: Double
    var longitude: Double
    var type: String?
    var description: String?
    var opening: String?
    var closing: String?
    var peopleInside: [User]?
}
