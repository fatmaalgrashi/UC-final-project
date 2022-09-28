//
//  UserData.swift
//  GetFit
//
//  Created by Osman Balci on 2/26/20.
//  Copyright © 2020 Osman Balci. All rights reserved.
//
 
import SwiftUI
import Combine
import CoreLocation
 
final class UserData: ObservableObject {

    /*
     ===========================================
     MARK: - Publisher-Subscriber Design Pattern
     ===========================================
     */
  
    // ❎ Subscribe to notification that the managedObjectContext completed a save
    @Published var savedInDatabase =  NotificationCenter.default.publisher(for: .NSManagedObjectContextDidSave)
  
}
 
