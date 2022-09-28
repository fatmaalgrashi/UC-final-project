//
//  NoNutritionData.swift
//  GetFit
//
//  Created by Justin Maloney on 12/09/20.
//  Copyright © 2020 Justin Maloney. All rights reserved.
//
import SwiftUI
 
struct NoNutritionData: View {
   
    // Input Parameter passed by value
    let upc: String
   
    var body: some View {
        VStack {
            Image(systemName: "exclamationmark.triangle")
                .imageScale(.large)
                .font(Font.title.weight(.medium))
                .foregroundColor(.red)
                .padding()
            Text("No Nutrition Data Returned!\n\nThe Nutritionix API did not return data for the item with UPC \(upc)!")
                .fixedSize(horizontal: false, vertical: true)   // Allow lines to wrap around
                .multilineTextAlignment(.center)
                .padding()
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            .background(Color(red: 1.0, green: 1.0, blue: 240/255))     // Ivory color
    }
}
 
struct NoNutritionData_Previews: PreviewProvider {
    static var previews: some View {
        NoNutritionData(upc: "")
    }
}
 
