//
//  Workout.swift
//  GetFit
//
//  Created by Dominic Gennello on 11/23/20.
//

import Foundation
import CoreData

public class Workout: NSManagedObject, Identifiable {
 
    @NSManaged public var name: String?
    @NSManaged public var category: String?
    @NSManaged public var notes: String?
    @NSManaged public var duration: NSNumber?
    @NSManaged public var calories: NSNumber?
    @NSManaged public var timesDone: NSNumber?
    @NSManaged public var exercises: NSSet?
}
extension Workout {
    /*
     ❎ CoreData @FetchRequest in WorkoutList.swift invokes this Workout class method
        to fetch all of the Workout entities from the database.
        The 'static' keyword designates the func as a class method invoked by using the
        class name as Workout.allWorkoutsFetchRequest() in any .swift file in your project.
     */
    static func allWorkoutsFetchRequest() -> NSFetchRequest<Workout> {
       
        let request: NSFetchRequest<Workout> = Workout.fetchRequest() as! NSFetchRequest<Workout>
        /*
         List the workouts in alphabetical order with respect to name;
         */
        request.sortDescriptors = [
            // Primary sort key: name
            NSSortDescriptor(key: "name", ascending: true),
        ]
       
        return request
    }
}
