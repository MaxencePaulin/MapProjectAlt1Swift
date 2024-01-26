//
//  UserViewModel.swift
//  MapProjectAlt1
//
//  Created by paulin maxence on 22/01/2024.
//

import Foundation

@MainActor
class UserViewModel: ObservableObject {
    
    enum State {
        case notAvailable
        case loading
        case success(data: User)
        case failed(error: Error)
    }
    
    
    private let service: UserService
    
    @Published var state: State = .notAvailable
    
    init(service: UserService){
        self.service = service
    }
    
    func addUser(_id: String?, firstName: String, lastName: String, biography: String, phoneNumber: String, email: String, avatar: String) async -> Any {
        if (_id != "") {
            let user = await updateUser(_id: _id!, firstName: firstName, lastName: lastName, biography: biography, phoneNumber: phoneNumber, email: email, avatar: avatar)
            return user
        } else {
            self.state = .loading
            do{
                let user = try await service.addUser(firstName: firstName, lastName: lastName, biography: biography, phoneNumber: phoneNumber, email: email, avatar: avatar)
                self.state = .success(data: user)
                return user
            } catch {
                // The error variable is implicit in catch method
                self.state = .failed(error: error)
                print(error)
                return -1
            }
        }
    }
    
    func updateUser(_id: String, firstName: String, lastName: String, biography: String, phoneNumber: String, email: String, avatar: String) async -> Any {
        self.state = .loading
        do {
            let user = try await service.updateUser(_id: _id, firstName: firstName, lastName: lastName, biography: biography, phoneNumber: phoneNumber, email: email, avatar: avatar)
            self.state = .success(data: user)
            return user
        } catch {
            self.state = .failed(error: error)
            print(error)
            return -1
        }
    }
    
    func getUser(_id: String!) async -> Any {
        self.state = .loading
        do {
            let user = try await service.getUser(_id: _id)
            self.state = .success(data: user)
            return user
        } catch {
            self.state = .failed(error: error)
            print(error)
            return -1
        }
        
    }
}
