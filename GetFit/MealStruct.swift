//
//  NationalParkStruct.swift
//  GetFit
//
//  Created by Justin Maloney on 12/09/20.
//  Copyright © 2020 Justin Maloney. All rights reserved.
//
 
import Foundation
 
// Used only for API search results
struct MealData: Codable {
 
    var category: String
    var calories: Double
    var mealContents: String
    var timeOfMeal: String
    var protein: Double
    var carbs: Double
    var fats: Double
    var photoFileName: String
    var photoUrl: String
    var hasPhotoUrl: Int
}
 
 
