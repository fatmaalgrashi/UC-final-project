//
//  ParkVisit.swift
//  GetFit
//
//  Created by Justin Maloney on 12/09/20.
//  Copyright © 2020 Justin Maloney. All rights reserved.
//
 
import Foundation
import CoreData
 
/*
 🔴 Set Current Product Module:
    In xcdatamodeld editor, select Trip, show Data Model Inspector, and
    select Current Product Module from Module menu.
 🔴 Turn off Auto Code Generation:
    In xcdatamodeld editor, select Trip, show Data Model Inspector, and
    select Manual/None from Codegen menu.
*/
 
// ❎ CoreData Trip entity public class
public class Progress: NSManagedObject, Identifiable {
 
    @NSManaged public var date: String?
    @NSManaged public var weight: NSNumber?
    @NSManaged public var photo: Data?
    @NSManaged public var photoUrl: String?
    @NSManaged public var hasPhotoUrl: NSNumber?

}
 
extension Progress {
    /*
     ❎ CoreData FetchRequest in other views calls this function
        to get all of the ParkVisit entities in the database
     */
    static func allProgressFetchRequest() -> NSFetchRequest<Progress> {
       
        let request: NSFetchRequest<Progress> = Progress.fetchRequest() as! NSFetchRequest<Progress>
       
        // We list the park visits in alphabetical order with respect to national park full name
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
       
        return request
    }
}
 
