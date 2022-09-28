//
//  GymResults.swift
//  GetFit
//
//  Created by Nathan Lam on 11/21/20.
//

import SwiftUI
import MapKit

struct GymResults: View {
    var body: some View {
        List {
            ForEach(gymFoundList) { aGym in
                NavigationLink(destination: gymLocationOnMap(gym: aGym)) {
                    GymItem(gym: aGym)
                }
            }
        } // end of List
        .navigationBarTitle(Text("Nearby Gyms"))
    } // end of body
    
    func gymLocationOnMap(gym: Gym) -> AnyView {
        var open = ""
        if (gym.open) {
            open = "Open"
        } else {
            open = "Closed"
        }
        return AnyView(MapView(mapType: MKMapType.satellite, latitude: gym.latitude, longitude: gym.longitude, delta: 1000.0, deltaUnit: "meters", annotationTitle: gym.name, annotationSubtitle: open))
    }
}

struct GymResults_Previews: PreviewProvider {
    static var previews: some View {
        GymResults()
    }
}
