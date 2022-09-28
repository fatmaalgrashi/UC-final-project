//
//  AddCustomExercise.swift
//  GetFit
//
//  Created by Dominic Gennello on 11/30/20.
//

import SwiftUI

struct AddCustomExercise: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var exercisesToAdd: [ExerciseStruct]
    
    @State private var name = ""
    @State private var muscles = ""
    @State private var equipment = ""
    @State private var description = ""
    @State private var categoryIndex = 0
    @State private var showExerciseAddedAlert = false
    @State private var showInputDataMissingAlert = false
    
    var body: some View {
        Form {
            Section(header: Text("Name")) {
                TextField("Enter exercise name", text: $name)
            }
            Section(header: Text("Category")) {
                Picker("", selection: $categoryIndex) {
                    ForEach(0 ..< categories.count, id: \.self) {
                        Text(categories[$0])
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(minWidth: 300, maxWidth: 500, alignment: .leading)
            }
            Section(header: Text("Muscles")) {
                TextField("Enter muscles used", text: $muscles)
            }
            Section(header: Text("Equipment")) {
                TextField("Enter equipment used", text: $equipment)
            }
            Section(header: Text("Description")) {
                TextEditor(text: $description)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disableAutocorrection(true)
                    .frame(minHeight: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
                    .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
            }
            .alert(isPresented: $showExerciseAddedAlert, content: { self.exerciseAddedAlert })
        }
        .font(.system(size: 16))
        .alert(isPresented: $showInputDataMissingAlert, content: { self.inputDataMissingAlert })
        .navigationBarTitle(Text("Add Custom Exercise"))
        .navigationBarItems(trailing:
            Button(action: {
                if self.inputDataValidated() {
                    self.addNewExercise()
                    self.showExerciseAddedAlert = true
                } else {
                    self.showInputDataMissingAlert = true
                }
            }) {
                Text("Add")
        })
    }//end of body
    
    var inputDataMissingAlert: Alert {
        Alert(title: Text("Missing Input Data!"),
              message: Text("Required Data: name"),
              dismissButton: .default(Text("OK")) )
    }
    func inputDataValidated() -> Bool {
       
        if self.name.isEmpty {
            return false
        }
       
        return true
    }
    var exerciseAddedAlert: Alert {
        Alert(title: Text("Exercise Added!"),
              message: Text("New exercise is added to your workout."),
              dismissButton: .default(Text("OK")) {
               
                // Dismiss this Modal View and go back to the previous view in the navigation hierarchy
                self.presentationMode.wrappedValue.dismiss()
            })
    }
    func addNewExercise() {
        let newExercise = ExerciseStruct(id: UUID(), name: name, category: categories[categoryIndex], muscles: muscles, equipment: equipment, description: description)
        exercisesToAdd.append(newExercise)
    }
}

