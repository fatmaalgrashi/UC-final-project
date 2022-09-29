//
//  ScanFoodBarcode.swift
//  GetFit
//
//  Created by Justin Maloney on 12/09/20.
//  Copyright © 2020 Justin Maloney. All rights reserved.
//
 
import SwiftUI
import AVFoundation
 
struct ScanFoodBarcode: View {
   
    // 'barcode' contains the UPC value of the barcode image
    @State var barcode: String = ""
    @Binding var carbRatio : String
    // 'lightOn' indicates if the flashlight is turned on or off
    @State var lightOn: Bool = false
   
    var body: some View {
        VStack {
            // Show barcode scanning camera view if no barcode image is present
            if barcode.isEmpty {
                /*
                 Display barcode scanning camera view on the background layer because
                 we will display the results on the foreground layer in the same view.
                 */
                ZStack {
                    /*
                     BarcodeScanner displays the barcode scanning camera view, obtains the barcode
                     value, and stores it into the @State variable 'barcode'. When the @State value
                     changes,the view invalidates its appearance and recomputes this body view.
                    
                     When this body view is recomputed, 'barcode' will not be empty and the
                     else part of the if statement will be executed, which displays barcode
                     processing results on the foreground layer in this same view.
                     */
                    BarcodeScanner(code: self.$barcode)
                   
                    // Display the flashlight button view
                    FlashlightButtonView(lightOn: self.$lightOn)
                   
                    /*
                     Display the scan focus region image to guide the user during scanning.
                     The image is constructed in ScanFocusRegion.swift upon app launch.
                     */
                    scanFocusRegionImage
                }
            } else {
                // Show barcode processing results
                foodItemNutritionDetails
            }
        }   // End of VStack
            .onDisappear() {
                self.lightOn = false
        }
    }
   
    var foodItemNutritionDetails: some View {
       
        // Public function getNutritionDataFromApi is given in NutritionixApiData.swift
        getNutritionDataFromApi(upc: self.barcode)
       
        if foodItem.foodName.isEmpty {
            return AnyView(NoNutritionData(upc: self.barcode))
        }
       
        return AnyView(FoodNutritionDetails(barcode: self.$barcode, carbRatio: carbRatio))
    }
 
}
 
//struct ScanFoodBarcode_Previews: PreviewProvider {
//    static var previews: some View {
//        ScanFoodBarcode()
//    }
//}
 
 
