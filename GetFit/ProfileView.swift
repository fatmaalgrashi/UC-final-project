//
//  ProfileView.swift
//  GetFit
//
//  Created by Fatima Garashi on 26/09/2022.
//

import SwiftUI

struct ProfileView: View {
    @State var firsName = ""
    @State var surName = ""
    @State var email = ""
    @State var birthday = Date()
    @State var weightKg = ""
    @State var insulinSensitivity = ""
    @State var carbRatio = ""
    @State var barcode = ""
//    @Binding var barcode : String



    var body: some View {
        NavigationView{
//            NavigationLink (destination: FoodNutritionDetails(barcode: Binding<String>, carbRatio: $carbRatio)){
//                EmptyView()
//            }
            Form{
                Section(header: Text("personal information")){
                    TextField("First Name", text: $firsName)
                    TextField("Surname", text: $surName)
                    TextField("email", text: $email)
                    DatePicker("Birthday", selection: $birthday, displayedComponents: .date)

                }
                Section(header: Text("personal health")){
                    TextField("carb ratio", text: $carbRatio)
                    
                    TextField("insulin sensitivity factor", text: $insulinSensitivity)
                    TextField("weight in kg", text: $weightKg)
                }
            }
            .navigationTitle(Text("Profile"))
            .toolbar{
                ToolbarItemGroup(placement: .navigationBarTrailing){
//                    NavigationLink (destination: FoodNutritionDetails( barcode: $barcode, carbRatio: $carbRatio)){
                        
                        
                    NavigationLink (destination: FoodNutritionDetails( barcode: $barcode, carbRatio: carbRatio)){
                                Button("save"){
                                    print($carbRatio)
                                }
                            }
                        
                        
                        
//                                }
                }
            }

        }
    }
//struct saveUser(){
//        
//    }
}


struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView( )
    }
}
