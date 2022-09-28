//
//  WorkoutItem.swift
//  GetFit
//
//  Created by Dominic Gennello on 11/23/20.
//

import SwiftUI

struct WorkoutItem: View {
    let workout: Workout
    var body: some View {
        HStack {
            Image(workout.category ?? "ImageUnavailable")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50)
            VStack(alignment: .leading) {
                Text(workout.name ?? "")
                Text(workout.category ?? "")
                Text("\(workout.duration as! Int) mins")
            }//end of VStack
        }//end of HStack
        .font(.system(size: 14))

    }
}
