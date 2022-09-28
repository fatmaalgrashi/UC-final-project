//
//  AddExercise.swift
//  GetFit
//
//  Created by Dominic Gennello on 11/25/20.
//

import SwiftUI

struct AddExercise: View {
    
    @Binding var exercisesToAdd: [ExerciseStruct]
    
    let options = ["Category", "Muscle", "Equipment"]
    
    @State private var optionIndex = 0
    @State private var categoryIndex = 0
    @State private var muscleIndex = 0
    @State private var equipmentIndex = 0
    
    @State private var searchCompleted = false
    
    var body: some View {
        Form {
            Section(header: Text("Add Custom Exercise")) {
                NavigationLink(destination: AddCustomExercise(exercisesToAdd: $exercisesToAdd)) {
                    HStack {
                        Image(systemName: "note.text.badge.plus")
                            .imageScale(.large)
                            .foregroundColor(.blue)
                        Text("Create Custom Exercise")
                    }//end of hstack
                }
            }
            Section(header: Text("Search Options")) {
                Picker("", selection: $optionIndex) {
                    ForEach(0 ..< options.count, id: \.self) {
                        Text(self.options[$0])
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(minWidth: 300, maxWidth: 500, alignment: .leading)
            }
            Section(header: Text("Search By")) {
                if (optionIndex == 0) {
                     Picker("", selection: $categoryIndex) {
                        ForEach(0 ..< categories.count, id: \.self) {
                            Text(categories[$0])
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                     .frame(minWidth: 300, maxWidth: 500, alignment: .leading)
                }
                else if (optionIndex == 1) {
                     Picker("", selection: $muscleIndex) {
                        ForEach(0 ..< muscles.count, id: \.self) {
                            Text(muscles[$0])
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                     .frame(minWidth: 300, maxWidth: 500, alignment: .leading)
                }
                else {
                     Picker("", selection: $equipmentIndex) {
                        ForEach(0 ..< equipment.count, id: \.self) {
                            Text(equipment[$0])
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                     .frame(minWidth: 300, maxWidth: 500, alignment: .leading)
                }
            }
            Section(header: Text("Search API")) {
                HStack {
                    Button(action: {
                        var searchId = 0
                        if (optionIndex == 0) {
                            searchId = categoryIds[categoryIndex]
                        }
                        else if (optionIndex == 1) {
                            searchId = muscleIds[muscleIndex]
                        }
                        else if (optionIndex == 2) {
                            searchId = equipmentIds[equipmentIndex]
                        }
                        getExercisesFromAPI(id: searchId, optionNum: optionIndex)
                        self.searchCompleted = true
                    }) {
                        Text(self.searchCompleted ? "Search Completed" : "Search")
                    }
                        .frame(width: 240, height: 36, alignment: .center)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .strokeBorder(Color.black, lineWidth: 1)
                        )
                }   // End of HStack
            }
            if (searchCompleted) {
                Section(header: Text("Clear Results")) {
                    Button(action: {
                        self.searchCompleted = false
                    }) {
                        Text("Clear")
                    }
                    .frame(width: 240, height: 36, alignment: .center)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .strokeBorder(Color.black, lineWidth: 1))
                }
                Section(header: Text("Show Search Results")) {
                    NavigationLink(destination: ExerciseSearchResults(exercisesToAdd: $exercisesToAdd)) {
                        HStack {
                            Image(systemName: "list.bullet")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                                .foregroundColor(.blue)
                            Text("Show Search Results")
                        }
                    }
                    .frame(minWidth: 300, maxWidth: 500)
                }
            }
        } //end of form
        .font(.system(size: 16))
        .navigationBarTitle(Text("Add Exercise"))
    }//end of body
    
}
