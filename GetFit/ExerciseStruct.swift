//
//  ExerciseStruct.swift
//  GetFit
//
//  Created by Dominic Gennello on 11/28/20.
//

import Foundation
 
struct ExerciseStruct: Hashable, Codable, Identifiable {
   
    var id: UUID
    var name: String
    var category: String
    var muscles: String
    var equipment: String
    var description: String
}

/*
 {"id": "EABD9B9A-4E13-4CD7-93AA-017DCD918D41", "name": "pushups", "category": "Chest", "muscles": "Pectoralis Major, Triceps Brachii, Anterior Deltoid", "equipment": "None (Bodyweight)", "description": "Hold down plank position for better results"},
 */
