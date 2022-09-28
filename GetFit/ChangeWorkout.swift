//
//  ChangeWorkout.swift
//  GetFit
//
//  Created by Dominic Gennello on 11/30/20.
//

import SwiftUI
import CoreData

struct ChangeWorkout: View {
    
    let workout: Workout
   
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var userData: UserData
    
    @State private var name = ""
    @State private var changeName = false
    @State private var duration = ""
    @State private var changeDuration = false
    @State private var calories = ""
    @State private var changeCalories = false
    @State private var categoryIndex = 0
    @State private var changeCategory = false
    @State private var notes = ""
    @State private var changeNotes = false
    @State private var allExercises = [Exercise]()
    @State private var showChangesAlert = false
    @State private var exercisesToAdd = [ExerciseStruct]()
    
    var body: some View {
        Form {
            Section(header: Text("Workout Name")) {
                workoutNameSubview
            }
            Section(header: Text("Category")) {
                workoutCategorySubview
            }
            Section(header: Text("Duration")) {
                workoutDurationSubview
            }
            Section(header: Text("Calories")) {
                workoutCaloriesSubview
            }
            Section(header: Text("Notes")) {
                workoutNotesSubview
            }
            Section(header: Text("Exercises")) {
                workoutExercisesSubview
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
        }
        .font(.system(size: 16))
        .alert(isPresented: $showChangesAlert, content: { self.changesAlert })
        .onAppear() {
            if (exercisesToAdd.count > 0) {
                addExercisesToWorkout()
            }
            allExercises = workout.exercises!.allObjects as! [Exercise]
        }
        .navigationBarTitle(Text("Change Workout"))
        .navigationBarItems(trailing:
            Button(action: {
                if self.changesMade() {
                    self.saveChanges()
                }
                self.showChangesAlert = true
            }) {
                Text("Save")
        })
        
    }
    var workoutNameSubview: some View {
        return AnyView(
            VStack {
                HStack {
                    Text(workout.name ?? "")
                    Button(action: {
                        self.changeName.toggle()
                    }) {
                        Image(systemName: "pencil.circle")
                            .imageScale(.large)
                            .foregroundColor(.blue)
                    }
                }
                if self.changeName {
                    TextField("Change workout name", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
            }
        )
    }
    var workoutDurationSubview: some View {
        return AnyView(
            VStack {
                HStack {
                    Text("\(workout.duration as! Int)")
                    Button(action: {
                        self.changeDuration.toggle()
                    }) {
                        Image(systemName: "pencil.circle")
                            .imageScale(.large)
                            .foregroundColor(.blue)
                    }
                }
                if self.changeDuration {
                    TextField("Change workout duration", text: $duration)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                }
            }
        )
    }
    var workoutCaloriesSubview: some View {
        return AnyView(
            VStack {
                HStack {
                    Text("\(workout.calories as! Int)")
                    Button(action: {
                        self.changeCalories.toggle()
                    }) {
                        Image(systemName: "pencil.circle")
                            .imageScale(.large)
                            .foregroundColor(.blue)
                    }
                }
                if self.changeCalories {
                    TextField("Change calories burnt", text: $calories)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                }
            }
        )
    }
    var workoutCategorySubview: some View {
        return AnyView(
            VStack {
                HStack {
                    Text(workout.category ?? "")
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
    var workoutNotesSubview: some View {
        return AnyView(
            VStack {
                HStack {
                    Text(workout.notes ?? "")
                    Button(action: {
                        self.changeNotes.toggle()
                    }) {
                        Image(systemName: "pencil.circle")
                            .imageScale(.large)
                            .foregroundColor(.blue)
                    }
                }
                if self.changeNotes {
                    TextEditor(text: $notes)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .disableAutocorrection(true)
                        .frame(minHeight: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
                        .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                }
            }
        )
    }
    var workoutExercisesSubview: some View {
        
        return AnyView(
            List {
                ForEach(allExercises, id: \.self) { anExercise in
                    NavigationLink(destination: ExerciseDetails(exercise: anExercise)) {
                        Text(anExercise.name ?? "")
                    }
                }
                .onDelete(perform: delete)
            }
        )
    }
    func delete(at offsets: IndexSet) {
       
        let exerciseToDelete = allExercises[offsets.first!]
       
        // ❎ CoreData Delete operation
        self.managedObjectContext.delete(exerciseToDelete)
       
        // ❎ CoreData Save operation
        do {
            try self.managedObjectContext.save()
            allExercises = workout.exercises!.allObjects as! [Exercise]
        } catch {
            print("Unable to delete selected exercise!")
        }
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
       
        if self.changeName || self.changeDuration || self.changeCalories || self.changeCategory || self.changeNotes || self.exercisesToAdd.count > 0{
            return true
        }
        return false
    }
    func saveChanges() {
        if self.changeName == true && name != "" {
            workout.name = self.name
        }
        if self.changeCategory == true {
            workout.category = categories[self.categoryIndex]
        }
        if self.changeDuration == true {
            workout.duration = NSNumber(value: Int(self.duration) ?? 0)
        }
        if self.changeCalories == true {
            workout.calories = NSNumber(value: Int(self.calories) ?? 0)
        }
        if self.changeNotes == true {
            workout.notes = self.notes
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
    func addExercisesToWorkout() {
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
                print("Publisher entity fetch failed!")
            }
           
            // Establish Relationship between Workout and Exercise
            anExercise.workouts = workout
            workout.exercises!.adding(anExercise)
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
       
    }
}
