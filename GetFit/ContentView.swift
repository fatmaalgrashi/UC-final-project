//
//  ContentView.swift
//  NationalParks
//
//  Created by Osman Balci on 5/5/20.
//  Copyright © 2020 Osman Balci. All rights reserved.
//
 
import SwiftUI
 
struct ContentView: View {
    var body: some View {
        TabView {
            ProfileView()
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("Profile")
                }
//            WorkoutList()
//                .tabItem {
//                    Image(systemName: "figure.walk")
//                    Text("Workout")
//                }
            Nutrition()
                .tabItem {
                    Image(systemName: "heart")
                    Text("Nutrition")
                }
//            SearchGym()
//                .tabItem {
//                    Image(systemName: "magnifyingglass")
//                    Text("Gym Finder")
//                }
//            ProgressTab()
//                .tabItem {
//                    Image(systemName: "rectangle.stack.person.crop")
//                    Text("Progress")
//                }
//            Overview()
//                .tabItem {
//                    Image(systemName: "list.bullet.rectangle")
//                    Text("Overview")
//                }
        }   // End of TabView
            .font(.headline)
            .imageScale(.medium)
            .font(Font.title.weight(.regular))
    }
}
 
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
 
