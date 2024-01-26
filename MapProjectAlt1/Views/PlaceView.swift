//
//  PlaceView.swift
//  MapProjectAlt1
//
//  Created by paulin maxence on 25/01/2024.
//

import SwiftUI

struct PlaceView: View {
    
    var placeSelected: Place
    
    @AppStorage("idCurrentUser") var idCurrentUser: String = ""
    @AppStorage("isTapped") var isTapped: Bool = false
    @AppStorage("idPlaceTapped") var idPlaceTapped: String = ""
    
    @StateObject var placeViewModel = PlaceViewModel(service: PlaceService())
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        List {
            VStack (alignment: .leading){
                Text("Nom de l'endroit")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                Text("\(placeSelected.name)").font(.title)
            }
            VStack (alignment: .leading){
                Text("Type ")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                Text("\(placeSelected.type ?? "N/A")").font(.title)
            }
            VStack (alignment: .leading){
                Text("Description ")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                Text("\(placeSelected.description ?? "N/A")").font(.title)
            }
            VStack (alignment: .leading){
                Text("Horaires d'ouverture ")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                Text("\(placeSelected.opening ?? "N/A") - \(placeSelected.closing ?? "N/A")").font(.title)
            }
            
            
            
//            Text("idCurrentUser : \(idCurrentUser == "" ? "N/A" : idCurrentUser)")
//            Text("place id: \(placeSelected._id), place id Tapped: \(idPlaceTapped)")
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        Task {
                            if (isTapped && placeSelected._id != idPlaceTapped) {
                                await placeViewModel.removeUserToPeopleInside(idPlace: idPlaceTapped, idCurrentUser: idCurrentUser)
                                await placeViewModel.addUserToPeopleInside(idPlace: placeSelected._id, idCurrentUser: idCurrentUser)
                                
                                idPlaceTapped = placeSelected._id
                            } else if (isTapped && placeSelected._id == idPlaceTapped) {
                                await placeViewModel.removeUserToPeopleInside(idPlace: placeSelected._id, idCurrentUser: idCurrentUser)
                                idPlaceTapped = ""
                                isTapped.toggle()
                            } else if (!isTapped) {
                                await placeViewModel.addUserToPeopleInside(idPlace: placeSelected._id, idCurrentUser: idCurrentUser)
                                idPlaceTapped = placeSelected._id
                                isTapped.toggle()
                            }
                            presentationMode.wrappedValue.dismiss()
                        }
                    }, label: {
                        Text(isTapped && idPlaceTapped == placeSelected._id ? "Je suis parti" : "Je suis ici")
                    })
                    .padding()
                    .buttonStyle(.bordered)
                    .controlSize(.large)
                    .tint(isTapped && idPlaceTapped == placeSelected._id ? .red : .blue)
                    Spacer()
                }
                
            }
            
            
            ForEach(placeSelected.peopleInside ?? [], id: \.self) { user in
                HStack {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width:40, height: 40)
                        .foregroundColor(.gray)
                        .background(Circle()
                            .fill(Color.white))
                    VStack {
                        Text(user.firstName).bold()
                        Text(user.lastName)
                    }
                }
                
            }
     
            
            
        }
    }
}

struct PlaceView_Previews: PreviewProvider {
    static var previews: some View {
        PlaceView(placeSelected: Place(_id: "1", name: "ABII Nord Franche Comté", latitude: 1, longitude: 1, type: "Bureau des étudiants", opening: "08:00", closing: "17:00"))
    }
}
