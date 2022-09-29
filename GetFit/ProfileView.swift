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
    @Binding var insulinSensitivity : String
    @Binding var carbRatio: String
    @State var barcode = ""
    @State var missingInfo = ""

//    @Binding var barcode : String



    var body: some View {
        NavigationView{
            
            VStack{
                Form{
                    Section(header: Text("personal information")){
                        TextField("First Name", text: $firsName)
                        TextField("Surname", text: $surName)
                        TextField("email", text: $email)
                        DatePicker("Birthday", selection: $birthday, displayedComponents: .date)

                    }
                    Section(header: Text("health information")){
                        TextField("carb ratio", text: $carbRatio)
                        
                        TextField("insulin sensitivity factor", text: $insulinSensitivity)
                        TextField("weight in kg", text: $weightKg)
                    }
                }
                
                Text(missingInfo)
                    .foregroundColor(.red)
                Spacer()
            }

//            NavigationLink (destination: FoodNutritionDetails(barcode: Binding<String>, carbRatio: $carbRatio)){
//                EmptyView()
//            }
            .navigationTitle(Text("Profile"))
            .toolbar{
                ToolbarItemGroup(placement: .navigationBarTrailing){
//                    NavigationLink (destination: FoodNutritionDetails( barcode: $barcode, carbRatio: $carbRatio)){
                        
                        
                    NavigationLink (destination: FoodNutritionDetails( barcode: $barcode, carbRatio: carbRatio)){
                                Button("save"){
                                    print($carbRatio)
                                    if carbRatio=="" || weightKg == "" || insulinSensitivity == "" {
                                        missingInfo = "please enter your health information"
                                    }else{
                                        missingInfo = ""
                                    }
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


//struct ProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileView( )
//    }
//}
