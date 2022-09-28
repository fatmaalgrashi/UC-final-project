//
//  ExerciseDetails.swift
//  GetFit
//
//  Created by Dominic Gennello on 11/30/20.
//

import SwiftUI

struct ExerciseDetails: View {
    
    let exercise: Exercise
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var userData: UserData
    
    var body: some View {
        Form {
            Section(header: Text("Name")) {
                Text(exercise.name ?? "N/A")
            }
            Section(header: Text("Category")) {
                Text(exercise.category ?? "N/A")
            }
            Section(header: Text("Description")) {
                Text(exercise.desc ?? "")
            }
            Section(header: Text("Muscles")) {
                Text((exercise.muscles ?? "") == "" ? "None Specified" : exercise.muscles ?? "")
            }
            Section(header: Text("Equipment")) {
                Text((exercise.equipment ?? "") == "" ? "None Specified" : exercise.equipment ?? "")
            }
            Section(header: Text("Edit Exercise")) {
                NavigationLink(destination: ChangeExercise(exercise: exercise)) {
                    HStack {
                        Image(systemName: "pencil.circle")
                            .imageScale(.medium)
                            .font(Font.title.weight(.regular))
                            .foregroundColor(.blue)
                        Text("Edit Exercise")
                    }
                }
            }
        }
        .font(.system(size: 16))
        .navigationBarTitle(Text("Exercise Details"))
    }
}
