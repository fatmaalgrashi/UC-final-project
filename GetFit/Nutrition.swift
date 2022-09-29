//
//  Nutrition.swift
//  GetFit
//
//  Created by Justin Maloney on 12/09/20.
//  Copyright © 2020 Justin Maloney. All rights reserved.
//

import SwiftUI

struct Nutrition: View {
    
    @State var foodUnits = ""
    @Binding var carbRatio: String
    @Binding var insulinSensitivity: String
    @State var image = Image(systemName: "plus.circle")
    @State var isTapped = false
    @State var currentBloodSugar = ""
    @State var topTarget = ""
    @State var correctionUnits = ""



    
    var body: some View {
        NavigationView {
            ZStack {
                Color.gray.opacity(0.1).edgesIgnoringSafeArea(.all)
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
//                        TextField("units per seving", text : $foodUnits)
                        // Show Meal tracker view
//                        NavigationLink(destination: MealTracker()) {
//                            HStack {
//                                Image(systemName: "list.bullet")
//                                    .imageScale(.medium)
//                                    .font(Font.title.weight(.regular))
//                                    .foregroundColor(.blue)
//                                    .frame(width: 60)
//                                Text("Meal Tracker")
//                                    .font(.headline)
//                            }
//                            .frame(minWidth: 300, maxWidth: 500, alignment: .leading)
//                        }
//                        .padding()
                        
//                        show food barcode scanner view
                        NavigationLink(destination: ScanFoodBarcode( carbRatio: $carbRatio)) {
                            HStack {
                                Image(systemName: "barcode.viewfinder")
                                    .imageScale(.medium)
                                    .font(Font.title.weight(.regular))
                                    .foregroundColor(.blue)
                                    .frame(width: 60)
                                Text("Find Food via Barcode")
                                    .font(.headline)
                            }
                            .frame(minWidth: 300, maxWidth: 500,  alignment: .leading)
                        }
                        .padding()
                        
                        //show manual upc entry view
                        NavigationLink(destination: EnterFoodBarcodeUPC()) {
                            HStack {
                                Image(systemName: "pencil.and.ellipsis.rectangle")
                                    .imageScale(.medium)
                                    .font(Font.title.weight(.regular))
                                    .foregroundColor(.blue)
                                    .frame(width: 60)
                                Text("Find Food by entering barcode")
                                    .font(.headline)
                            }
                            .frame(minWidth: 300, maxWidth: 500,  alignment: .leading)
                        }
                        .padding()
                        Spacer()
                        HStack{
                            
                            image
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
//                                .foregroundColor(.blue)
                                .frame(width: 60)
//                                .font(.system(size: 25))
                                .foregroundColor(isTapped ? .red : .green)
//                                .multilineTextAlignment(.leading)
                                .onTapGesture {
                                    withAnimation(.easeOut(duration: 0.5)){
                                        isTapped.toggle()
                                    }
                                
                                    
                                    image = isTapped ? Image(systemName: "minus.circle") : Image(systemName: "plus.circle")
                                }
                            
                            Text("Blood sugar correction")
                                .font(.system(size: 20))
                            
                           
                            
                        }.frame(minWidth: 300, maxWidth: 500,  alignment: .leading)
                        .padding()
                        TextField(isTapped ? "enter your current blood sugar" : "", text: $currentBloodSugar)
                            .padding()
                            .frame(width: 350, height: 50)
                            .background(isTapped ? Color.gray.opacity(0.3) : Color.clear)
                            .cornerRadius(10)

                            .padding()
                        TextField(isTapped ? "enter top targetted blood sugar level" : "", text: $topTarget)
                            .padding()
                            .frame(width: 350, height: 50)
                            .background(isTapped ? Color.gray.opacity(0.3) : Color.clear)
                            .cornerRadius(10)
                            .padding()
                        Button(action: {
                            correctionUnits = "you need \(CalculateCorrectionUnit(currentBloodSugar: currentBloodSugar, topTarget: topTarget, insulinSensitivity: insulinSensitivity)) units"
                            currentBloodSugar = ""
                            topTarget = ""
                            
                        }){
                                Text(isTapped ? "calculate" : "")
                                
                            }
                        .padding()
                        Text(isTapped ? correctionUnits : "")
                            .font(.system(size: 25))
                            .bold()
                            .foregroundColor(.red)
                            .padding()

//                        Text("Powered By")
//                            .font(.headline)
//                            .padding(.top, 30)
//                            .padding(.horizontal, 30)
                        
                        // Show Nutritionix API provider's website in default web browser
//                        Link(destination: URL(string: "https://www.nutritionix.com/business/api")!) {
//                            Image("Nutritionix")
//                                .renderingMode(.original)   // Keep the logo in its original form
//                                .resizable()
//                                .aspectRatio(contentMode: .fit)
//                                .frame(height: 37)
//                                .padding(.horizontal, 30)
//                        }
                    }   // End of VStack
                    .navigationBarTitle(Text("Nutrition"))
                    .padding(50)
                }   // End of ScrollView
            }   // End of ZStack
        }   // End of NavigationView
        .customNavigationViewStyle()
        
    }
}
func CalculateCorrectionUnit(currentBloodSugar: String, topTarget: String, insulinSensitivity: String) -> Double {
    let cbs = Double(currentBloodSugar) ?? 0
    let tt = Double(topTarget) ?? 0
    let i = Double(insulinSensitivity) ?? 0

    return (cbs - tt)/i
}
//struct Nutrition_Previews: PreviewProvider {
//    static var previews: some View {
//        Nutrition()
//    }
//}


