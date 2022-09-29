//
//  AppointmentDetails.swift
//  GetFit
//
//  Created by Fatima Garashi on 29/09/2022.
//

import SwiftUI

struct AppointmentItem: Identifiable{
    let id = UUID()
    @Binding var  date: Date
    @Binding var  description : String

}
struct AppointmentDetails: View {
    let id = UUID()

    @Binding var date : Date
    @State var isChecked = true
    @Binding var description : String
    @State var newItem : String = ""
    @State var items : [String] = []
//    @Binding var appointments : [String]
    @Binding var appointments : [String]

    var body: some View {
        NavigationView{
            VStack{
                Form{
//                    NavigationLink(destination: Appointment( date: date)){
//                        Section(header: Text("appointment details")){
                           
                    DatePicker("select a date", selection: $date, displayedComponents: .date)
                    TextField("add a description", text: $description)
                            
//                        }
                        .toolbar{
                            ToolbarItemGroup(placement: .navigationBarTrailing){
                             
                                NavigationLink (destination: Appointment(index: 0, date: $date, appointments: self.$appointments, description: $description)){
                                    Button(action: {
                                        appointments.append("\(date)")
//                                        UpcomingView(appointments.append("\(AppointmentDetails(date: date))"))

                                        print("\(date)")
                                    }){
                                        Text("save")
                                    }
                                        }
                                    
                                    
                                    
                                            }
                            }
                        

                    
                   
//                    Button("Add") {
////                        let item = ExpenseItem(validDate: self.dateFormatter.string(from: self.date))
////                        self.expenses.items.append(item)
//                    }
                    Section(header: Text("to do list")){
                        VStack{
                            List(items, id: \.self) { item in
                                HStack{
            //                        Image(item)
            //                            .resizable()
            //                            .aspectRatio(contentMode: .fit)
            //                            .frame(width: 70, height: 70 )
                                    Text(item)
                                     Spacer()
                                    Image(systemName: isChecked ? "checkmark.square" : "checkmark.square.fill")
                                        .resizable()
                                                                .aspectRatio(contentMode: .fit)
                                                                .frame(width: 20, height: 20 )
                                }.onTapGesture {
                                    isChecked.toggle()
                                }
            //                    .onTapGesture {
            //                        selectedItem = items.firstIndex(where: { $0.hasPrefix(item) }) ?? 0
            //                    }
                                }
                            .padding()
//
            //                    Button(action:{
            //                        items.remove(at: selectedItem)
            //
            //                        //let itemIndex = items.firstIndex(where: {$0 == id(id:\.self)})
            //
            //                    }){
            //                        Image(systemName: "minus.square.fill")
            //                            .font(.system(size: 50))
            //                            .foregroundColor(.red)
            //                    }
                                
                            
            //                    Button(action:{
            //                        items.append(items.randomElement() ?? "")
            //
            //                    }){
            //                        Image(systemName: "questionmark.app.fill")
            //                            .font(.system(size: 50))
            //                            .foregroundColor(.blue)
            //                    }

                          
                                
                            }
                            .padding()
                            
                        }
                    }
            }
            .toolbar {
                       ToolbarItem(placement: .bottomBar) {
                           HStack{
                               
                               TextField("add a task", text: $newItem)
                                   .padding()
                                   .frame(width: 280, height: 50)
                                   .background(Color.gray.opacity(0.3))
                                   .cornerRadius(10)
                                   .padding()
                               Button(action:{
                                   items.append(newItem)

                               }){
                                   Image(systemName: "plus.app.fill")
                                       .font(.system(size: 40))
                                       .foregroundColor(.green)
                               }
                           }.padding()
                           
                       }
            }
        }
        }
        
    }


//struct AppointmentDetails_Previews: PreviewProvider {
//    static var previews: some View {
//        AppointmentDetails()
//    }
//}

