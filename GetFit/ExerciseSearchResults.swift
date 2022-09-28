//
//  ExerciseSearchResults.swift
//  GetFit
//
//  Created by Dominic Gennello on 11/29/20.
//

import SwiftUI

struct ExerciseSearchResults: View {
    
    @Binding var exercisesToAdd: [ExerciseStruct]
    
    var body: some View {
        List {
            ForEach(exercisesFromApi, id: \.self) { anExercise in
                NavigationLink(destination: ExerciseStructDetails(exercisesToAdd: $exercisesToAdd, exercise: anExercise)) {
                    Text(anExercise.name)
                        .font(.system(size: 16))
                }
            }
        }
        .navigationBarTitle(Text("Exercise Search Results"))
    }
}
