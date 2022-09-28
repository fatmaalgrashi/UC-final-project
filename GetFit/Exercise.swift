//
//  Exercise.swift
//  GetFit
//
//  Created by Dominic Gennello on 11/30/20.
//

import Foundation
import CoreData

public class Exercise: NSManagedObject, Identifiable {
 
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var category: String?
    @NSManaged public var muscles: String?
    @NSManaged public var equipment: String?
    @NSManaged public var desc: String?
    @NSManaged public var workouts: Workout
}
extension Exercise {
    static func allExercisesFetchRequest() -> NSFetchRequest<Exercise> {
       
        let request: NSFetchRequest<Exercise> = Exercise.fetchRequest() as! NSFetchRequest<Exercise>
        /*
         List the exercises in alphabetical order with respect to name;
         */
        request.sortDescriptors = [
            // Primary sort key: name
            NSSortDescriptor(key: "name", ascending: true),
        ]
       
        return request
    }
    static func filteredExercisesFetchRequest(exerciseName: String) -> NSFetchRequest<Exercise> {
       
        let fetchRequest = NSFetchRequest<Exercise>(entityName: "Exercise")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
       
        fetchRequest.predicate = NSPredicate(format: "name ==[c] %@", exerciseName)
       
        return fetchRequest
    }
}
