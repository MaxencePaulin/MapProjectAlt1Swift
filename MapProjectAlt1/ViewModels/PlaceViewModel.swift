//
//  PlaceViewModel.swift
//  MapProjectAlt1
//
//  Created by paulin maxence on 25/01/2024.
//

import Foundation

@MainActor
class PlaceViewModel: ObservableObject {
    
    enum State {
        case notAvailable
        case loading
        case success(data: [Place])
        case failed(error: Error)
    }
    
    
    private let service: PlaceService
    
    @Published var state: State = .notAvailable
    
    init(service: PlaceService){
        self.service = service
    }
    
    func getPlaces() async {
        self.state = .loading
        do{
            let places = try await service.fetchPlaces()
            print(places)
            self.state = .success(data: places)
        } catch {
            // The error variable is implicit in catch method
            self.state = .failed(error: error)
            print(error)
        }
    }
    
    func addUserToPeopleInside(idPlace: String, idCurrentUser: String) async {
        do {
            try await service.addUserToPeopleInside(idPlace: idPlace, idCurrentUser: idCurrentUser)
        } catch {
            print(error)
        }
    }
    
    func removeUserToPeopleInside(idPlace: String, idCurrentUser: String) async {
        do {
            try await service.removeUserToPeopleInside(idPlace: idPlace, idCurrentUser: idCurrentUser)
        } catch {
            print(error)
        }
    }
}
