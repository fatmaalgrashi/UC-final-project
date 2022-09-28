//
//  ParksVisited.swift
//  NationalParks
//
//  Created by Osman Balci on 5/31/20.
//  Copyright © 2020 Osman Balci. All rights reserved.
//

import SwiftUI
import CoreData

struct MealTracker: View {
    
    // ❎ CoreData managedObjectContext reference
    @Environment(\.managedObjectContext) var managedObjectContext
    
    // ❎ CoreData FetchRequest returning all Meal entities in the database
    @FetchRequest(fetchRequest: Meal.allMealsFetchRequest()) var allMeals: FetchedResults<Meal>
    
    // ❎ Refresh this view upon notification that the managedObjectContext completed a save.
    // Upon refresh, @FetchRequest is re-executed fetching all ParkVisit entities with all the changes.
    @EnvironmentObject var userData: UserData

    var body: some View {
        VStack{
            Form {
                Section(header: Text("Add Meal")) {
                    NavigationLink(destination: AddMeal()) {
                        HStack {
                            Image(systemName: "plus.circle")
                                .imageScale(.large)
                                .foregroundColor(.blue)
                            Text("Add Meal")
                        }//end of hstack
                    }
                }
                Section(header: Text("Meals")) {
                    List {
                        /*
                         Each NSManagedObject has internally assigned unique ObjectIdentifier
                         used by ForEach to display allMeals in a dynamic scrollable list.
                         */
                        ForEach(self.allMeals) { aMeal in
                            NavigationLink(destination: MealDetails(meal: aMeal)) {
                                MealItem(meal: aMeal)
                            }
                        }
                        .onDelete(perform: delete)
                        
                    }   // End of List
                }
                .navigationBarTitle(Text("Meal Tracker"))
            }
          
            
           
                               
        }
        // Place the Edit button on left and Add (+) button on right of the navigation bar
        
           
       
       
        
        
    }
    
    /*
     ----------------------------------
     MARK: - Delete Selected Meal
     ----------------------------------
     */
    func delete(at offsets: IndexSet) {
        /*
         'offsets.first' is an unsafe pointer to the index number of the array element
         to be deleted. It is nil if the array is empty. Process it as an optional.
         */
        if let index = offsets.first {
            
            let parkVisitEntityToDelete = self.allMeals[index]
            
            // ❎ CoreData Delete operation
            self.managedObjectContext.delete(parkVisitEntityToDelete)
            
            // ❎ CoreData Save operation
            do {
                try self.managedObjectContext.save()
            } catch {
                print("Unable to delete!")
            }
        }
    }
    
}

struct MealTracker_Previews: PreviewProvider {
    static var previews: some View {
        MealTracker()
    }
}

