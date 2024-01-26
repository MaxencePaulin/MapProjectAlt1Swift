//
//  ContentView.swift
//  MapProjectAlt1
//
//  Created by paulin maxence on 11/12/2023.
//

import SwiftUI
import MapKit


struct ContentView: View {
    @State private var userTrackingMode: MapUserTrackingMode = .follow
    @State var selectedPlace: Place?
    @State var isActiveEditUser: Bool = false
    @AppStorage("idCurrentUser") var idCurrentUser: String = ""
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 47.6427,
            longitude: 6.8396
        ),
        span: MKCoordinateSpan(
            latitudeDelta: 0.005,
            longitudeDelta: 0.005)
    )
    @State private var alreadyOpen = false;
    @StateObject var placeViewModel = PlaceViewModel(service: PlaceService())
    var alreadyCreate = false;
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    if (alreadyCreate == true) {

                        switch placeViewModel.state {
                        case .success(let places):
                                Map(coordinateRegion: $region,
                                    interactionModes: MapInteractionModes.all,
                                    showsUserLocation: true,
                                    userTrackingMode: $userTrackingMode,
                                    annotationItems: places
                                ) { place in
                                    MapAnnotation(
                                        coordinate: .init(latitude: place.latitude, longitude: place.longitude),
                                        anchorPoint: CGPoint(x: 0.5, y:0.5)
                                    ) {
                                        Button (action: {
                                            self.selectedPlace = place
                                            self.alreadyOpen = true
                                        }) {
                                            HStack{
                                                ZStack{
                                                    Circle()
                                                        .fill(Color.orange)
                                                        .frame(width: 20, height: 15)
                                                    
                                                    Image(systemName: "mappin")
                                                        .resizable()
                                                        .frame(width: 6, height: 6)
                                                        .foregroundColor(.white)
                                                }
                                                Text(place.name)
                                                    .font(.system(size: 12))
                                                    .foregroundColor(.orange)
                                                    .bold()
                                            }
                                        }
                                    }
                                }.navigationBarBackButtonHidden(true)
                                    .sheet(item: $selectedPlace, content: { place in
                                        PlaceView(placeSelected: place).onDisappear() {
                                            Task {
                                                await placeViewModel.getPlaces()
                                            }
                                            print("test")
                                        }
                                    })
                                    .ignoresSafeArea()
                        case .loading:
                            ProgressView()
                            
                        default:
                            ProgressView()
                        }
                    } else {
                        LoginView().task {
                            idCurrentUser = ""
                        }
                    }
                }
                .task {
                    await placeViewModel.getPlaces()
                }
                    VStack {
                        HStack {
                            Spacer()
                            if(alreadyCreate == true) {
                                Button(action: {
                                    isActiveEditUser.toggle()
                                    
                                }) {
                                    Image(systemName: "person.crop.circle.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width:40, height: 40)
                                        .foregroundColor(.gray)
                                        .background(Circle()
                                            .fill(Color.white))
                                }
                                .padding()
                            }
                        }
                        Spacer()
                    }
                
                NavigationLink("", destination: LoginView(), isActive: $isActiveEditUser).hidden()
                
            }.navigationBarBackButtonHidden(true)
        }.navigationBarBackButtonHidden(true)
        
        
    }
}

// 

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
