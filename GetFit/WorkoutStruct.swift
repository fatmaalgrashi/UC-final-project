//
//  WorkoutStruct.swift
//  GetFit
//
//  Created by Dominic Gennello on 11/23/20.
//

import Foundation
 
struct WorkoutStruct: Hashable, Codable {
   
    var name: String
    var duration: Int
    var category: String
    var notes: String
    var calories: Int
    var exercises: [ExerciseStruct]
}

/*
 {
     "name": "Push Workout",
     "duration": 30,
     "category": "Chest",
     "notes": "Hold the down pushup postion for 2 seconds",
     "calories": 100,
     "exercises": [
         {"id": "EABD9B9A-4E13-4CD7-93AA-017DCD918D41", "name": "pushups", "category": "Chest", "muscles": "Pectoralis Major, Triceps Brachii, Serratus Anterior", "equipment": "None (Bodyweight)", "description": "Hold down plank position for better results"}
     ]
 }
 */
