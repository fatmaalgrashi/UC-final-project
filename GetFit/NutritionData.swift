//
//  NationalParksData.swift
//  NationalParks
//
//  Created by Osman Balci on 8/4/20.
//  Copyright © 2020 Osman Balci. All rights reserved.
//
 
import SwiftUI
import CoreData
 
// Array of NationalParkVisit structs for use only in this file
fileprivate var listOfMeals = [MealData]()
fileprivate var listOfProgress = [ProgressData]()
fileprivate var workoutStructList = [WorkoutStruct]()
 
/*
 **************************************
 MARK: - Create National Parks Database
 **************************************
 */
public func createMealDatabase() {
 
    listOfMeals = decodeJsonFileIntoArrayOfStructs(fullFilename: "MealData.json", fileLocation: "Main Bundle")
    listOfProgress = decodeJsonFileIntoArrayOfStructs(fullFilename: "ProgressData.json", fileLocation: "Main Bundle")
    workoutStructList = loadFromMainBundle("workoutData.json")
   
    populateDatabase()
}
 
/*
*********************************************
MARK: - Populate Database If Not Already Done
*********************************************
*/
func populateDatabase() {
   
    // ❎ Get object reference of CoreData managedObjectContext from the persistent container
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
   
    //----------------------------
    // ❎ Define the Fetch Request
    //----------------------------
    let fetchRequestMeal = NSFetchRequest<Meal>(entityName: "Meal")
    fetchRequestMeal.sortDescriptors = [NSSortDescriptor(key: "timeOfMeal", ascending: true)]
    let fetchRequestProgress = NSFetchRequest<Progress>(entityName: "Progress")
    fetchRequestProgress.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
//    let fetchRequest = NSFetchRequest<Workout>(entityName: "Workout")
//    fetchRequest.sortDescriptors = [
//        // Primary sort key: artistName
//        NSSortDescriptor(key: "name", ascending: true)
//    ]
   
    var listOfAllMealEntitiesInDatabase = [Meal]()
    var listOfAllProgressEntitiesInDatabase = [Progress]()
//    var listOfAllWorkoutEntitiesInDatabase = [Workout]()
   
    do {
        //-----------------------------
        // ❎ Execute the Fetch Request
        //-----------------------------
        listOfAllMealEntitiesInDatabase = try managedObjectContext.fetch(fetchRequestMeal)
        listOfAllProgressEntitiesInDatabase = try managedObjectContext.fetch(fetchRequestProgress)
//        listOfAllWorkoutEntitiesInDatabase = try managedObjectContext.fetch(fetchRequest)
    } catch {
        print("Populate Database Failed!")
        return
    }
   
    if listOfAllMealEntitiesInDatabase.count > 0 || listOfAllProgressEntitiesInDatabase.count > 0{
        // Database has already been populated
        print("Database has already been populated!")
        return
    }
   
    print("Database will be populated!")
 
    for meal in listOfMeals {
       
        /*
         ==========================================================
         Create an instance of the ParkVisit Entity and dress it up
         ==========================================================
         */
       
        // ❎ Create an instance of the ParkVisit Entity in CoreData managedObjectContext
        let mealEntity = Meal(context: managedObjectContext)
        // ❎ Create an instance of the ParkVisit Entity in CoreData managedObjectContext
        let nutrientsEntity = Nutrients(context: managedObjectContext)
       
        // ❎ Dress it up by specifying its attributes
        mealEntity.timeOfMeal = meal.timeOfMeal
        mealEntity.category = meal.category
        mealEntity.mealContents = meal.mealContents
        mealEntity.calories = meal.calories as NSNumber
        nutrientsEntity.protein = meal.protein as NSNumber
        nutrientsEntity.carbs = meal.protein as NSNumber
        nutrientsEntity.fats = meal.protein as NSNumber
       
        /*
         ======================================================
         Create an instance of the Photo Entity and dress it up
         ======================================================
         */
      
        // Obtain the park visit photo image from Assets.xcassets as UIImage
        let photoUIImage = UIImage(named: meal.photoFileName)
       
        // Convert photoUIImage to data of type Data (Binary Data) in JPEG format with 100% quality
        let photoData = photoUIImage?.jpegData(compressionQuality: 1.0)
       
        // Assign photoData to Core Data entity attribute of type Data (Binary Data)
        mealEntity.photo = photoData!
        mealEntity.photoUrl = meal.photoUrl
        mealEntity.hasPhotoUrl = meal.hasPhotoUrl as NSNumber
       
        /*
         ==============================
         Establish Entity Relationships
         ==============================
         */
       
        // ❎ Establish Relationship between entities ParkVisit and Photo
        mealEntity.nutrients = nutrientsEntity
        nutrientsEntity.meal = mealEntity
       
        /*
         ==================================
         Save Changes to Core Data Database
         ==================================
         */
       
        // ❎ CoreData Save operation
        do {
            try managedObjectContext.save()
        } catch {
            return
        }
       
    }   // End of for loop
    
    for progress in listOfProgress {
       
        /*
         ==========================================================
         Create an instance of the ParkVisit Entity and dress it up
         ==========================================================
         */
       
        // ❎ Create an instance of the ParkVisit Entity in CoreData managedObjectContext
        let progressEntity = Progress(context: managedObjectContext)
       
        // ❎ Dress it up by specifying its attributes
        progressEntity.date = progress.date
        progressEntity.weight = progress.weight as NSNumber

       
        /*
         ======================================================
         Create an instance of the Photo Entity and dress it up
         ======================================================
         */
      
        // Obtain the park visit photo image from Assets.xcassets as UIImage
        let photoUIImage = UIImage(named: progress.photoFileName)
       
        // Convert photoUIImage to data of type Data (Binary Data) in JPEG format with 100% quality
        let photoData = photoUIImage?.jpegData(compressionQuality: 1.0)
       
        // Assign photoData to Core Data entity attribute of type Data (Binary Data)
        progressEntity.photo = photoData!
        progressEntity.photoUrl = progress.photoUrl
        progressEntity.hasPhotoUrl = progress.hasPhotoUrl as NSNumber
        
        /*
         ==================================
         Save Changes to Core Data Database
         ==================================
         */
       
        // ❎ CoreData Save operation
        do {
            try managedObjectContext.save()
        } catch {
            return
        }
       
    }   // End of for loop
    
    for workoutData in workoutStructList {
        /*
         =====================================================
         Create an instance of the Workout Entity and dress it up
         =====================================================
        */
       
        // ❎ Create an instance of the Workout entity in CoreData managedObjectContext
        let workoutEntity = Workout(context: managedObjectContext)
       
        // ❎ Dress it up by specifying its attributes
        workoutEntity.name = workoutData.name
        workoutEntity.duration = NSNumber(value: workoutData.duration)
        workoutEntity.calories = NSNumber(value: workoutData.calories)
        workoutEntity.timesDone = NSNumber(value: 0)
        workoutEntity.category = workoutData.category
        workoutEntity.notes = workoutData.notes
        
        // ❎ Define the fetch request for exercise entities
        for exerciseData in workoutData.exercises {
           
            // Create an instance of the Exercise Entity in managedObjectContext
            let anExercise = Exercise(context: managedObjectContext)
           
            // Dress it up by specifying its attributes
            anExercise.id = UUID()
            anExercise.name = exerciseData.name
            anExercise.category = exerciseData.category
            anExercise.muscles = exerciseData.muscles
            anExercise.equipment = exerciseData.equipment
            anExercise.desc = exerciseData.description
           
            // Establish Relationship between Workout and Exercise
            anExercise.workouts = workoutEntity
            workoutEntity.exercises!.adding(anExercise)
        }
        /*
         ==================================
         Save Changes to Core Data Database
         ==================================
        */
       
        // ❎ CoreData Save operation
        do {
            try managedObjectContext.save()
        } catch {
            return
        }
       
    }   // End of for loop
 
}
 
/*
**************************************************************
MARK: - Load Data File from Main Bundle (Project Folder)
**************************************************************
*/
func loadFromMainBundle<T: Decodable>(_ filename: String, as type: T.Type = T.self) -> T {
    let data: Data
   
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Unable to find \(filename) in main bundle.")
    }
   
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Unable to load \(filename) from main bundle:\n\(error)")
    }
   
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Unable to parse \(filename) as \(T.self):\n\(error)")
    }
}
 
