//
//  WorkoutList.swift
//  GetFit
//
//  Created by Dominic Gennello on 11/23/20.
//

import SwiftUI

let categories = ["Abs", "Arms", "Back", "Calves", "Chest", "Legs", "Shoulders"]
let categoryIds = [10, 8, 12, 14, 11, 9, 13]
let muscles = ["Anterior Deltoid", "Biceps Brachii", "Biceps Femoris", "Brachialis", "Gastrocnemius", "Gluteus Maximus", "Latissimus Dorsi", "Obliquus Externus Abdominis", "Pectoralis Major", "Quadriceps Femoris", "Rectus Abdominis", "Serratus Anterior", "Soleus", "Trapezius", "Triceps Brachii"]
let muscleIds = [2, 1, 11, 13, 7, 8, 12, 14, 4, 10, 6, 3, 15, 9, 5]
let equipment = ["Barbell", "Bench", "Dumbbell", "Gym Mat", "Incline Bench", "Kettlebell", "None (Bodyweight)", "Pull-Up Bar", "Swiss Ball", "SZ-Bar"]
let equipmentIds = [1, 8, 3, 4, 9, 10, 7, 6, 5, 2]

struct WorkoutList: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(fetchRequest: Workout.allWorkoutsFetchRequest()) var allWorkouts: FetchedResults<Workout>
    @EnvironmentObject var userData: UserData
    var body: some View {
        NavigationView {
            List {
                ForEach(self.allWorkouts) { aWorkout in
                    NavigationLink(destination: WorkoutDetails(workout: aWorkout)) {
                        WorkoutItem(workout: aWorkout)
                    }
                }
                .onDelete(perform: delete)
               
            }   // End of List
                .navigationBarTitle(Text("My Workouts"))
               
                // Place the Edit button on left and Add (+) button on right of the navigation bar
                .navigationBarItems(leading: EditButton(), trailing:
                    NavigationLink(destination: AddWorkout()) {
                        Image(systemName: "plus")
                })
           
        }   // End of NavigationView
            // Use single column navigation view for iPhone and iPad
            .navigationViewStyle(StackNavigationViewStyle())
       
    }   // End of body
    func delete(at offsets: IndexSet) {
       
        let workoutToDelete = self.allWorkouts[offsets.first!]
       
        // ❎ CoreData Delete operation
        self.managedObjectContext.delete(workoutToDelete)
       
        // ❎ CoreData Save operation
        do {
            try self.managedObjectContext.save()
        } catch {
            print("Unable to delete selected workout!")
        }
    }
}

struct WorkoutList_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutList()
    }
}
