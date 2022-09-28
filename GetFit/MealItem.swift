//
//  MealItem.swift
//  GetFit
//
//  Created by Justin Maloney on 12/09/20.
//  Copyright © 2020 Justin Maloney. All rights reserved.
//
 
import SwiftUI
 
struct MealItem: View {
   
    // ❎ Input parameter: CoreData Meal Entity instance reference
    let meal: Meal
   
    // ❎ CoreData FetchRequest returning all ParkVisit entities in the database
    @FetchRequest(fetchRequest: Meal.allMealsFetchRequest()) var allMeals: FetchedResults<Meal>
   
    // ❎ Refresh this view upon notification that the managedObjectContext completed a save.
    // Upon refresh, @FetchRequest is re-executed fetching all Meal entities with all the changes.
    @EnvironmentObject var userData: UserData
   
    var body: some View {
        HStack {
            // This function is given in PhotoImageFromBinaryData.swift
            if(meal.hasPhotoUrl == 0) {
                photoImageFromBinaryData(binaryData: meal.photo!, defaultFilename: "ImageUnavailable")
                .resizable()
                .aspectRatio(contentMode: .fit)
                    .frame(width: 100.0, height: 75.0)
            }
            else {
                getImageFromUrl(url: meal.photoUrl!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(minWidth: 100, maxWidth: 100, alignment: .center)
            }
           
            VStack(alignment: .leading) {
                /*
                 ?? is called nil coalescing operator.
                 IF visit.fullName is not nil THEN
                 unwrap it and return its value
                 ELSE return ""
                 */
                Text(meal.category ?? "")
                MealTime(stringDate: meal.timeOfMeal ?? "")
                Text("\(meal.calories!) calories")
            }
                // Set font and size for the whole VStack content
                .font(.system(size: 14))
        }
    }
}
 
 
