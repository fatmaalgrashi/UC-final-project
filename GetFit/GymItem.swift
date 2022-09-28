//
//  GymItem.swift
//  GetFit
//
//  Created by Nathan Lam on 11/21/20.
//

import SwiftUI

struct GymItem: View {

    // Input Parameter
    let gym: Gym
    
    var body: some View {
        HStack {
            // public function getImageFromUrl is given in UtilityFunctions.swift
            /*
            getImageFromUrl(url: "\(gym.photo)", defaultFilename: "ImageUnavailable")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80.0)
 */
            HStack {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                    .imageScale(.large)
                Text(String(format: "%.1f", gym.rating))
                    .font(.system(size: 24))
                    .bold()
            }
            Divider()
            VStack(alignment: .leading) {
                Text(String(format: "\(gym.name), %.1f mi", gym.distance))
                            
                Text(gym.vicinity)
                if (gym.open) {
                    Text("Open")
                        .foregroundColor(.green)
                        .bold()
                } else {
                    Text("Closed")
                        .foregroundColor(.red)
                        .bold()
                }
            } // end of VStack
            .font(.system(size: 14))
        } // end of HStack
    }
}

struct GymItem_Previews: PreviewProvider {
    static var previews: some View {
        GymItem(gym: gymFoundList[0])
    }
}
