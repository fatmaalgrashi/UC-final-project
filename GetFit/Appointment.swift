//
//  Appointment.swift
//  GetFit
//
//  Created by Fatima Garashi on 28/09/2022.
//

import SwiftUI
import EventKitUI

struct Appointment: View {

    @State var index = 0
    @Binding var date : Date
    @Binding var appointments : [String]
    @Binding var description : String


    var body: some View {
        
        NavigationView{
           
            VStack{
//                .toolbar{
//                    ToolbarItem(placement: .navigationBarTrailing){
                        HStack{
                            Button(action:{
                                withAnimation(.spring(response: 0.8, dampingFraction: 0.5, blendDuration: 0.5)){
                                    self.index = 0

                                }
                            }){
                                Text("upcoming")
                                    .foregroundColor(self.index == 0 ? .white : .gray)
                                    .fontWeight(.bold)
                                    .padding(.vertical, 10)
                                    .frame(width: (UIScreen.main.bounds.width - 50) / 2)
                            }
                            .background(self.index == 0 ? Color.gray : Color.clear)
                            .clipShape(Capsule())
                            
                            
                            
                            Button(action:{
                                withAnimation(.spring(response: 0.8, dampingFraction: 0.5, blendDuration: 0.5)){
                                    self.index = 1
                                }
                            }){
                                Text("previous")
                                    .foregroundColor(self.index == 1 ? .white : .gray)
                                    .fontWeight(.bold)
                                    .padding(.vertical, 10)
                                    .frame(width: (UIScreen.main.bounds.width - 50) / 2)
                            }
                            .background(self.index == 1 ? Color.gray : Color.clear)
                            .clipShape(Capsule())
                            
                        }
                        .frame(height: 40)
                        .background(Color.black.opacity(0.1))
                            .clipShape(Capsule())
                            .padding()



                        
                        if self.index == 0{
                            UpcomingView( appointments: self.$appointments, date: $date, description: $description)
                        }else{
                            PreviousView(date: date)
                        }
                NavigationLink(destination: AppointmentDetails(date : $date, description: $description, appointments : self.$appointments)){
                    Text("add an appointment")}.padding()
//                    }
//                }
                
                    
            }
            
            
        }
    }
}

struct UpcomingView : View{
    let id = UUID()

    @Binding var appointments : [String]
    @Binding var date : Date
    @Binding var description : String

    var body : some View{
        
      
            VStack{
               
                List(appointments, id:\.self){ appointment in
                    NavigationLink(destination:AppointmentDetails(date: $date, description: $description, appointments: self.$appointments)){
                        VStack{
                            Text(appointment)
                        }
                    }
                  
                    
                }

                
                   
//                NavigationLink(destination: AppointmentDetails(date : date)){
//                    Text("add an appointment")}.padding()
                
//                List{
//                    ForEach(appointments){ appointment in
//                        NavigationLink(destination: AppointmentDetails(date: $date, appointments: self.$appointments)){
//                            HStack{
//                                Text(appointment)
//                            }
//                        }
//                    }
//                }
//                }
//                List(appointments, id: \.self) { appointment in
//                    HStack{
//                        Text(appointment)
////
//                    }
//                    .onTapGesture {
//                        selectedItem = items.firstIndex(where: { $0.hasPrefix(item) }) ?? 0
//                    }
                    }
//                        Button(action:{
//
////                            appointments.append("\(AppointmentDetails(date: date))")
//                        }){
//                            Text("add an appointment")
//                        }
//                    TextField("new item", text: $newItem)
//                        .padding()
                
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

        }


struct PreviousView : View{
    @State var date = Date()

    var body : some View{
        
        VStack{
            List{

                Text("no previous appointments")
//
                }
        }
    }
}
//struct Appointment_Previews: PreviewProvider {
//
//    static var previews: some View {
//        Appointment( )
//    }
//}

