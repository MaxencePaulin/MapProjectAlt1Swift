//
//  UserService.swift
//  MapProjectAlt1
//
//  Created by paulin maxence on 12/01/2024.
//

import Foundation

enum UserError: Error {
    case failed
    case failedToDecode
    case invalidStatusCode
    case invalidUserName
}

struct UserService {
    
    func addUser(firstName: String = "", lastName: String = "", biography: String = "", phoneNumber: String = "", email: String = "", avatar: String = "") async throws -> User {
        
        let baseURL = "https://11896988-bb49-42bf-8469-ac4a60ee8988-00-2aoem21nn2sd6.worf.replit.dev/"
        let endpoint = baseURL + "api/user"

        guard let url = URL(string: endpoint) else {
            throw UserError.invalidUserName
        }
        
        let user = User(firstName: firstName, lastName: lastName, biography: biography, phoneNumber: phoneNumber, email: email, avatar: avatar)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let encoder = JSONEncoder()
        let jsonData = try encoder.encode(user)
        request.httpBody = jsonData
        
        let (data, response) = try await URLSession.shared.upload(for: request, from: jsonData)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 201 else {
            throw UserError.invalidStatusCode
        }

        let decodedData = try JSONDecoder().decode(User.self, from: data)
        
        return decodedData
    }
    
    func updateUser(_id: String = "", firstName: String = "", lastName: String = "", biography: String = "", phoneNumber: String = "", email: String = "", avatar: String = "") async throws -> User {
        let baseURL = "https://11896988-bb49-42bf-8469-ac4a60ee8988-00-2aoem21nn2sd6.worf.replit.dev/"
        let endpoint = baseURL + "api/user/" + _id

        guard let url = URL(string: endpoint) else {
            throw UserError.invalidUserName
        }
        
        let user = User(firstName: firstName, lastName: lastName, biography: biography, phoneNumber: phoneNumber, email: email, avatar: avatar)
        
        guard let jsonData = try? JSONEncoder().encode(user) else {
            print("Error encoding user data")
            throw UserError.failed
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        let (data, response) = try await URLSession.shared.upload(for: request, from: jsonData)

        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            print(response)
            throw UserError.invalidStatusCode
        }

        let decodedData = try JSONDecoder().decode(User.self, from: data)

        return decodedData
    }
    
    func getUser(_id: String) async throws -> User {
        let baseURL = "https://11896988-bb49-42bf-8469-ac4a60ee8988-00-2aoem21nn2sd6.worf.replit.dev/"
        let endpoint = baseURL + "api/user/" + _id

        guard let url = URL(string: endpoint) else {
            throw UserError.invalidUserName
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)

        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw UserError.invalidStatusCode
        }

        let decodedData = try JSONDecoder().decode(User.self, from: data)

        return decodedData
        
    }
}
