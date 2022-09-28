//
//  AddWorkout.swift
//  GetFit
//
//  Created by Dominic Gennello on 11/23/20.
//

import SwiftUI
import CoreData

struct AddWorkout: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @State private var workoutName = ""
    @State private var duration = ""
    @State private var calories = ""
    @State private var categoryIndex = 0
    @State private var exercises = ""
    @State private var notes = "Enter notes here"
    @State private var showAddExercise = false;
    @State private var exercisesToAdd = [ExerciseStruct]()
    @State private var showWorkoutAddedAlert = false
    @State private var showInputDataMissingAlert = false
    
    var body: some View {
        Form {
            Section(header: Text("Workout Name")) {
                TextField("Enter workout name", text: $workoutName)
            }
            Section(header: Text("Choose Category")) {
                Picker("", selection: $categoryIndex) {
                    ForEach(0 ..< categories.count, id: \.self) {
                        Text(categories[$0])
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(minWidth: 300, maxWidth: 500, alignment: .leading)
            }
            Section(header: Text("Expected Duration in Mins")) {
                TextField("Enter duration in minutes", text: $duration)
                    .keyboardType(.numberPad)
            }
            Section(header: Text("Expected Calories Burnt")) {
                TextField("Enter calories", text: $calories)
                    .keyboardType(.numberPad)
            }
            if (exercisesToAdd.count > 0) {
                Section(header: Text("Exercises")) {
                    List {
                        ForEach(exercisesToAdd) { anExercise in
                            NavigationLink(destination: ExerciseStructDetails(exercisesToAdd: $exercisesToAdd, exercise: anExercise)) {
                                Text(anExercise.name)
                            }
                        }
                    }
                }
            }
            Section(header: Text("Add Exercises")) {
                NavigationLink(destination: AddExercise(exercisesToAdd: $exercisesToAdd)) {
                    HStack {
                        Image(systemName: "plus.circle")
                            .imageScale(.large)
                            .foregroundColor(.blue)
                        Text("Add Exercise")
                    }//end of hstack
                }
            }
            Section(header: Text("Add Notes")) {
                TextEditor(text: $notes)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disableAutocorrection(true)
                    .frame(minHeight: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
                    .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
            }
            .alert(isPresented: $showWorkoutAddedAlert, content: { self.workoutAddedAlert })
        } //end of form
        .font(.system(size: 16))
        .alert(isPresented: $showInputDataMissingAlert, content: { self.inputDataMissingAlert })
        .navigationBarTitle(Text("Add Workout"))
        .navigationBarItems(trailing:
            Button(action: {
                if self.inputDataValidated() {
                    self.saveNewWorkout()
                    self.showWorkoutAddedAlert = true
                } else {
                    self.showInputDataMissingAlert = true
                }
            }) {
                Text("Save")
        })
    } //end of body
    var inputDataMissingAlert: Alert {
        Alert(title: Text("Missing Input Data!"),
              message: Text("Required Data: name, duration, and at least one exercise"),
              dismissButton: .default(Text("OK")) )
    }
    func inputDataValidated() -> Bool {
       
        if self.workoutName.isEmpty || self.duration == "" || self.exercisesToAdd.count == 0 {
            return false
        }
       
        return true
    }
    var workoutAddedAlert: Alert {
        Alert(title: Text("Workout Added!"),
              message: Text("New workout is added to your workout list."),
              dismissButton: .default(Text("OK")) {
               
                // Dismiss this Modal View and go back to the previous view in the navigation hierarchy
                self.presentationMode.wrappedValue.dismiss()
            })
    }
    func saveNewWorkout() {
        // Create an instance of the Workout entity in managedObjectContext
        let aWorkout = Workout(context: self.managedObjectContext)
       
        //  Dress it up by specifying its attributes
        aWorkout.name = workoutName
        aWorkout.duration = NSNumber(value: Int(duration) ?? 0)
        aWorkout.timesDone = NSNumber(value: 0)
        aWorkout.category = categories[categoryIndex]
        aWorkout.notes = notes
        aWorkout.calories = NSNumber(value: Int(calories) ?? 0)
       
        /*
         ===========================
         MARK: - ❎ Exercise Entity
         ===========================
         */
        // ❎ Define the fetch request
        let fetchRequest = NSFetchRequest<Exercise>(entityName: "Exercise")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        for anExerciseStruct in exercisesToAdd {
            fetchRequest.predicate = NSPredicate(format: "name ==[c] %@", anExerciseStruct.name)
           
            var results = [Exercise]()
            var anExercise = Exercise()
           
            do {
                // ❎ Execute the fetch request
                results = try managedObjectContext.fetch(fetchRequest)
               
                if results.isEmpty {
                    // Create an instance of the Exercise Entity in managedObjectContext
                    anExercise = Exercise(context: self.managedObjectContext)
                    
                    // Dress it up by specifying its attributes
                    anExercise.id = anExerciseStruct.id
                    anExercise.name = anExerciseStruct.name
                    anExercise.category = anExerciseStruct.category
                    anExercise.muscles = anExerciseStruct.muscles
                    anExercise.equipment = anExerciseStruct.equipment
                    anExercise.desc = anExerciseStruct.description
                } else {
                    anExercise = results[0]
                }
            } catch {
                print("Exercise entity fetch failed!")
            }
           
            // Establish Relationship between Workout and Exercise
            anExercise.workouts = aWorkout
            aWorkout.exercises!.adding(anExercise)
        }
        
       
        /*
         =============================================
         MARK: - ❎ Save Changes to Core Data Database
         =============================================
         */
       
        do {
            try self.managedObjectContext.save()
        } catch {
            return
        }
       
    }   // End of func
   
}

struct AddWorkout_Previews: PreviewProvider {
    static var previews: some View {
        AddWorkout()
    }
}
