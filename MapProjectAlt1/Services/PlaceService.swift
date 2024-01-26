//
//  PlaceService.swift
//  MapProjectAlt1
//
//  Created by paulin maxence on 12/01/2024.
//

import Foundation

enum PlaceError: Error {
    case failed
    case failedToDecode
    case invalidStatusCode
    case invalidUserName
}

struct PlaceService {
    func fetchPlaces() async throws -> [Place] {

        let baseURL = "https://11896988-bb49-42bf-8469-ac4a60ee8988-00-2aoem21nn2sd6.worf.replit.dev/"
        let endpoint = baseURL + "api/place"

        guard let url = URL(string: endpoint) else {
            throw PlaceError.invalidUserName
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)

        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw PlaceError.invalidStatusCode
        }
        let decodedData = try JSONDecoder().decode([Place].self, from: data)

        return decodedData
    }
    
    func addUserToPeopleInside(idPlace: String, idCurrentUser: String) async throws {
        let baseURL = "https://11896988-bb49-42bf-8469-ac4a60ee8988-00-2aoem21nn2sd6.worf.replit.dev/"
        let endpoint = baseURL + "api/place/" + idPlace

        guard let url = URL(string: endpoint) else {
            throw PlaceError.invalidUserName
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestData = ["userId": idCurrentUser]
        let jsonData = try JSONSerialization.data(withJSONObject: requestData)
        request.httpBody = jsonData
        
        let (_, response) = try await URLSession.shared.upload(for: request, from: jsonData)

        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw PlaceError.invalidStatusCode
        }
    }
    
    func removeUserToPeopleInside(idPlace: String, idCurrentUser: String) async throws {
        let baseURL = "https://11896988-bb49-42bf-8469-ac4a60ee8988-00-2aoem21nn2sd6.worf.replit.dev/"
        let endpoint = baseURL + "api/place/" + idPlace

        guard let url = URL(string: endpoint) else {
            throw PlaceError.invalidUserName
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestData = ["userId": idCurrentUser]
        let jsonData = try JSONSerialization.data(withJSONObject: requestData)
        request.httpBody = jsonData
        
        let (_, response) = try await URLSession.shared.upload(for: request, from: jsonData)

        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw PlaceError.invalidStatusCode
        }
    }
}
