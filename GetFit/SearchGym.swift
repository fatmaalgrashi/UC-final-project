//
//  SearchGym.swift
//  GetFit
//
//  Created by Nathan Lam on 11/21/20.
//

import SwiftUI

struct SearchGym: View {
    
    let radii = [2, 5, 10, 15, 20, 30]
    
    @State private var selectedRadiusIndex = 1
    @State private var searchCompleted = false
    
    var body: some View {
        NavigationView {
            
            Form {
                if !searchCompleted {
                    Section(header: Text("Select Radius")) {
                        Picker("", selection: $selectedRadiusIndex) {
                            ForEach(0 ..< radii.count, id: \.self) {
                                Text("\(self.radii[$0])")
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(minWidth: 300, maxWidth: 500, alignment: .leading)
                    }
                    
                    Section(header: Text("Search Gyms")) {
                        HStack {
                            Button(action: {
                                self.searchApi()
                                self.searchCompleted = true
                            }) {
                                Text("Search Gyms")
                            }
                            .frame(width: 240, height: 36, alignment: .center)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .strokeBorder(Color.black, lineWidth: 1)
                            )
                        } // End of HStack
                    }
                }
                if searchCompleted {
                    Section(header: Text("Show Gyms Found")) {
                        
                        NavigationLink(destination: GymResults()) {
                            HStack {
                                Image(systemName: "list.bullet")
                                    .foregroundColor(.blue)
                                    .imageScale(.medium)
                                    .font(Font.title.weight(.regular))
                                Text("Show Gyms Found")
                                    .font(.system(size: 16))
                            }
                        }
                        
                    }
                    Section(header: Text("Clear Search")) {
                        Button(action: {
                            self.searchCompleted = false
                        }) {
                            Image(systemName: "clear")
                                .imageScale(.large)
                        }
                    }
                    
                }
            } // end of Form
            .navigationBarTitle(Text("Find Gyms"))
            
        } // end of NavigationView
    } // end of body
    
    /*
     MARK: - Search API
     */
    func searchApi() {
        let currentLoc = currentLocation()
        let currentLatitude = currentLoc.latitude
        let currentLongitude = currentLoc.longitude
        
        obtainGymDataFromApi(radiusMiles: radii[selectedRadiusIndex], currentLatitude: currentLatitude, currentLongitude: currentLongitude)
    }
    
    /*
     MARK: - Show search results
     */
    var showSearchResults: some View {
        
        // Global variable cocktailFoundList is given in CocktailApiData.swift
        if gymFoundList.isEmpty {
            return AnyView(notFoundMessage)
        }
        
        return AnyView(GymResults())
    }
    
    /*
     MARK: - No gym found message
     */
    var notFoundMessage: some View {
        VStack {
            Image(systemName: "exclamationmark.triangle")
                .imageScale(.large)
                .font(Font.title.weight(.medium))
                .foregroundColor(.red)
                .padding()
            Text("No gyms were found nearby! \n\nThe chosen radius did not return any gyms from the API! Please try a larger radius if possible.")
                .fixedSize(horizontal: false, vertical: true) // Allow lines to wrap around
                .multilineTextAlignment(.center)
                .padding()
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(Color(red: 1.0, green: 1.0, blue: 240/255)) // Ivory color
    }
}

struct SearchGym_Previews: PreviewProvider {
    static var previews: some View {
        SearchGym()
    }
}
