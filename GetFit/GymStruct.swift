//
//  GymStruct.swift
//  GetFit
//
//  Created by Nathan Lam on 11/21/20.
//

import SwiftUI

struct Gym: Codable, Hashable, Identifiable {
    
    var id: UUID
    var name: String
    var photo: String
    var open: Bool
    var rating: Double
    var vicinity: String
    var distance: Double
    var latitude: Double
    var longitude: Double
    
}

