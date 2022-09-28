//
//  ExerciseDetails.swift
//  GetFit
//
//  Created by Dominic Gennello on 11/29/20.
//

import SwiftUI

struct ExerciseStructDetails: View {
    @Binding var exercisesToAdd: [ExerciseStruct]
    let exercise: ExerciseStruct
    var body: some View {
        Form {
            Section(header: Text("Name")) {
                Text(exercise.name)
            }
            Section(header: Text("Category")) {
                Text(exercise.category)
            }
            Section(header: Text("Description")) {
                Text(exercise.description)
            }
            Section(header: Text("Muscles")) {
                Text(exercise.muscles == "" ? "None Specified" : exercise.muscles)
            }
            Section(header: Text("Equipment")) {
                Text(exercise.equipment == "" ? "None Specified" : exercise.equipment)
            }
            Button(action: {
                if (!exercisesToAdd.contains(exercise)) {
                    exercisesToAdd.append(exercise)
                }
                else {
                    exercisesToAdd.remove(at: exercisesToAdd.firstIndex(of: exercise) ?? exercisesToAdd.count - 1)
                }
            }) {
                if (!exercisesToAdd.contains(exercise)) {
                    Text("Add Exercise to Workout")
                }
                else {
                    Text("Remove Exercise from Workout")
                    
                }
            }
            .frame(width: 240, height: 36, alignment: .center)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(Color.black, lineWidth: 1)
            )
        }
        .font(.system(size: 16))
        .navigationBarTitle(Text("Exercise Details"))
    }
}
