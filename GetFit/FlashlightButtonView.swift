//
//  FlashlightButtonView.swift
//  GetFit
//
//  Created by Justin Maloney on 12/09/20.
//  Copyright © 2020 Justin Maloney. All rights reserved.
//
 
import SwiftUI
 
struct FlashlightButtonView: View {
   
    // Input Parameter passed by reference
    @Binding var lightOn: Bool
   
    var body: some View {
        VStack {
            HStack {
                Spacer()    // Spaces to show the button on the right of the screen
                FlashlightButton(lightOn: $lightOn)
                    .padding()
            }
            Spacer()        // Spaces to show the button on the top of the screen
        }
        // Using Spacer(), the button is positioned on the top right corner of the screen
    }
}
 
struct FlashlightButtonView_Previews: PreviewProvider {
    static var previews: some View {
        FlashlightButtonView(lightOn: .constant(false))
    }
}
 
