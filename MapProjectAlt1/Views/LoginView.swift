//
//  LoginView.swift
//  MapProjectAlt1
//
//  Created by paulin maxence on 08/01/2024.
//

import SwiftUI

struct LabeledTextField: View {
    var title: String
    var placeholder: String
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.headline)
                .foregroundColor(.gray)
            
            TextField(placeholder, text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(EdgeInsets(top: 3, leading: 15, bottom: 3, trailing: 15))
                .disableAutocorrection(true)
        }
    }
}

struct LoginView: View {
    
    @State var nom: String = ""
    @State var prenom: String = ""
    @State var biography: String = ""
    @State var email: String = ""
    @State var phone: String = ""
    @State var avatar: String = ""

    @StateObject var userViewModel = UserViewModel(service: UserService())
    @State private var isActive = false
    
    @AppStorage("idCurrentUser") var idCurrentUser: String = ""
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack {
                switch userViewModel.state {
                case .loading:
                    ProgressView()
                default:
                    Spacer()
                    
                    Text(idCurrentUser != "" ? "Éditer votre profil" : "Créer votre profil")
                        .font(.largeTitle)
                        .bold()
                    
                    VStack(alignment: .leading, spacing: 20) {
                        LabeledTextField(title: "Nom", placeholder: "Entrez un nom", text: $nom)
                        LabeledTextField(title: "Prénom", placeholder: "Entrez un prénom", text: $prenom)
                        LabeledTextField(title: "Biographie", placeholder: "Entrez une biographie", text: $biography)
                        LabeledTextField(title: "Email", placeholder: "Entrez une email", text: $email)
                        LabeledTextField(title: "Numéro de téléphone", placeholder: "Entrez un numéro de téléphone", text: $phone)
                        LabeledTextField(title: "Avatar", placeholder: "Avatar ?", text: $avatar)
                    }
                    .padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                    .padding()
                    
                    Spacer()
                    
                    Button(action: {
                        Task {
                            let user = await userViewModel.addUser(_id: idCurrentUser, firstName: prenom, lastName: nom, biography: biography, phoneNumber: phone, email: email, avatar: avatar)
                            if (type(of: user) != Int.self) {
                                if (idCurrentUser == "") {
                                    idCurrentUser = (user as! User)._id ?? ""
                                    isActive = true
                                } else {
                                    presentationMode.wrappedValue.dismiss()
                                }
                                
                            }
                        }
                    }, label: {
                        Text(idCurrentUser != "" ? "Mettre à jour" : "Se connecter")
                    })
                    
                    NavigationLink("", destination: ContentView(alreadyCreate: true), isActive: $isActive).hidden()
                }
            }.task {
                if (idCurrentUser != "") {
                    let currentUser = await userViewModel.getUser(_id: idCurrentUser)
                    if (type(of: currentUser) != Int.self) {
                        prenom = (currentUser as! User).firstName
                        nom = (currentUser as! User).lastName
                        biography = (currentUser as! User).biography ?? ""
                        phone = (currentUser as! User).phoneNumber ?? ""
                        email = (currentUser as! User).email ?? ""
                        avatar = (currentUser as! User).avatar ?? ""
                    }
                    
                }
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
