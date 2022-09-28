//
//  Photo.swift
//  GetFit
//
//  Created by Justin Maloney on 12/09/20.
//  Copyright © 2020 Justin Maloney. All rights reserved.
//
 
import Foundation
import CoreData
 
/*
 🔴 Set Current Product Module:
    In xcdatamodeld editor, select Photo, show Data Model Inspector, and
    select Current Product Module from Module menu.
 🔴 Turn off Auto Code Generation:
    In xcdatamodeld editor, select Photo, show Data Model Inspector, and
    select Manual/None from Codegen menu.
*/
 
// ❎ CoreData Photo entity public class
public class Nutrients: NSManagedObject, Identifiable {
 
    @NSManaged public var carbs: NSNumber?
    @NSManaged public var fats: NSNumber?
    @NSManaged public var protein: NSNumber?       // 🔴
    @NSManaged public var meal: Meal?
}
 
/*
🔴 Swift type Double cannot be used for @NSManaged Core Data attributes because the type
Double cannot be represented in Objective-C, which is internally used for Core Data.
Therefore, we must use the Objective-C type NSNumber instead for latitude and longitude.
*/
 
