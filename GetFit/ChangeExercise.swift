//
//  ChangeExercise.swift
//  GetFit
//
//  Created by Dominic Gennello on 11/30/20.
//

import SwiftUI

struct ChangeExercise: View {
    
    let exercise: Exercise
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @EnvironmentObject var userData: UserData
    
    @State private var name = ""
    @State private var changeName = false
    @State private var muscles = ""
    @State private var changeMuscles = false
    @State private var categoryIndex = 0
    @State private var changeCategory = false
    @State private var description = ""
    @State private var changeDescription = false
    @State private var equipment = ""
    @State private var changeEquipment = false
    @State private var showChangesAlert = false
    
    var body: some View {
        Form {
            Section(header: Text("Exercise Name")) {
                exerciseNameSubview
            }
            Section(header: Text("Category")) {
                exerciseCategorySubview
            }
            Section(header: Text("Muscles")) {
                exerciseMusclesSubview
            }
            Section(header: Text("Equipment")) {
                exerciseEquipmentSubview
            }
            Section(header: Text("Description")) {
                exerciseDescSubview
            }
        }
        .font(.system(size: 16))
        .alert(isPresented: $showChangesAlert, content: { self.changesAlert })
        .navigationBarTitle(Text("Change Exercise"))
        .navigationBarItems(trailing:
            Button(action: {
                if self.changesMade() {
                    self.saveChanges()
                }
                self.showChangesAlert = true
            }) {
                Text("Save")
        })
    }//end of body
    var exerciseNameSubview: some View {
        return AnyView(
            VStack {
                HStack {
                    Text(exercise.name ?? "")
                    Button(action: {
                        self.changeName.toggle()
                    }) {
                        Image(systemName: "pencil.circle")
                            .imageScale(.large)
                            .foregroundColor(.blue)
                    }
                }
                if self.changeName {
                    TextField("Change exercise name", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
            }
        )
    }
    var exerciseCategorySubview: some View {
        return AnyView(
            VStack {
                HStack {
                    Text(exercise.category ?? "")
                    Button(action: {
                        self.changeCategory.toggle()
                    }) {
                        Image(systemName: "pencil.circle")
                            .imageScale(.large)
                            .foregroundColor(.blue)
                    }
                }
                if self.changeCategory {
                    Picker("", selection: $categoryIndex) {
                        ForEach(0 ..< categories.count, id: \.self) {
                            Text(categories[$0])
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(minWidth: 300, maxWidth: 500, alignment: .leading)
                }
            }
        )
    }
    var exerciseMusclesSubview: some View {
        return AnyView(
            VStack {
                HStack {
                    Text(exercise.muscles ?? "")
                    Button(action: {
                        self.changeMuscles.toggle()
                    }) {
                        Image(systemName: "pencil.circle")
                            .imageScale(.large)
                            .foregroundColor(.blue)
                    }
                }
                if self.changeMuscles {
                    TextField("Change muscles", text: $muscles)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
            }
        )
    }
    var exerciseEquipmentSubview: some View {
        return AnyView(
            VStack {
                HStack {
                    Text(exercise.equipment ?? "")
                    Button(action: {
                        self.changeEquipment.toggle()
                    }) {
                        Image(systemName: "pencil.circle")
                            .imageScale(.large)
                            .foregroundColor(.blue)
                    }
                }
                if self.changeEquipment {
                    TextField("Change equipment", text: $equipment)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
            }
        )
    }
    var exerciseDescSubview: some View {
        return AnyView(
            VStack {
                HStack {
                    Text(exercise.desc ?? "")
                    Button(action: {
                        self.changeDescription.toggle()
                    }) {
                        Image(systemName: "pencil.circle")
                            .imageScale(.large)
                            .foregroundColor(.blue)
                    }
                }
                if self.changeDescription {
                    TextEditor(text: $description)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .disableAutocorrection(true)
                        .frame(minHeight: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
                        .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                }
            }
        )
    }
    var changesAlert: Alert {
        
        if changesMade() {
            return Alert(title: Text("Changes Saved!"),
                         message: Text("Your changes have been successfully saved to the database."),
                         dismissButton: .default(Text("OK")) {
                            self.presentationMode.wrappedValue.dismiss()
                })
        }
       
        return Alert(title: Text("No Changes Saved!"),
                     message: Text("You did not make any changes!"),
                     dismissButton: .default(Text("OK")) {
                        self.presentationMode.wrappedValue.dismiss()
            })
    }
    func changesMade() -> Bool {
       
        if self.changeName || self.changeCategory || self.changeMuscles || self.changeEquipment || self.changeDescription {
            return true
        }
        return false
    }
    func saveChanges() {
        if self.changeName == true && name != "" {
            exercise.name = self.name
        }
        if self.changeCategory == true {
            exercise.category = categories[self.categoryIndex]
        }
        if self.changeMuscles == true {
            exercise.muscles = self.muscles
        }
        if self.changeEquipment == true {
            exercise.equipment = self.equipment
        }
        if self.changeDescription == true {
            exercise.desc = self.description
        }
       
        /*
         ==================================
         Save Changes to Core Data Database
         ==================================
         */
       
        // ❎ CoreData Save operation
        do {
            try self.managedObjectContext.save()
        } catch {
            return
        }
       
    }
}
