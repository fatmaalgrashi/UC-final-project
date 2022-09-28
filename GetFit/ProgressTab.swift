//
//  Countries.swift
//  GetFit
//
//  Created by Justin Maloney on 12/09/20.
//  Copyright © 2020 Justin Maloney. All rights reserved.
//

import SwiftUI
import WebKit

struct ProgressTab : View {
    
    // ❎ CoreData managedObjectContext reference
    @Environment(\.managedObjectContext) var managedObjectContext
    
    // ❎ CoreData FetchRequest returning all ParkVisit entities in the database
    @FetchRequest(fetchRequest: Progress.allProgressFetchRequest()) var allProgress: FetchedResults<Progress>
    
    // Fit as many photos per row as possible with minimum image width of 100 points each.
    // spacing defines spacing between columns
    let columns = [ GridItem(.adaptive(minimum: 100), spacing: 5) ]
    
    @State private var showProgressInfoAlert = false
    @State private var selectedPhoto = Progress()
    
    var body: some View {
        NavigationView {
            ZStack {
                // Color the background to light gray
                Color.gray.opacity(0.1).edgesIgnoringSafeArea(.all)
                VStack {
                    getImageFromUrl(url: "https://image-charts.com/chart?chtt=Weight+Loss+Progress&cht=lc&chg=20,50,1,1,333333&chd=a:\(getProgressDataString())&chm=o,ff0000,0,-1,8.0&chs=350x150&chxt=y&chma=0,5,0,0")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    
                    Divider()
                    ScrollView {
                        // spacing defines spacing between rows
                        LazyVGrid(columns: columns, spacing: 3) {
                            // 🔴 Specifying id: \.self is critically important to prevent photos being listed as out of order
                            ForEach(allProgress) { progress in
                                // Public function getImageFromUrl is given in UtilityFunctions.swift
                                if(progress.hasPhotoUrl == 0) {
                                    photoImageFromBinaryData(binaryData: progress.photo!, defaultFilename: "ImageUnavailable")
                                        .resizable()
                                        .scaledToFit()
                                        .onTapGesture {
                                            selectedPhoto = progress
                                            self.showProgressInfoAlert = true
                                        }
                                }
                                else {
                                    getImageFromUrl(url: progress.photoUrl!)
                                        .resizable()
                                        .scaledToFit()
                                        .onTapGesture {
                                            selectedPhoto = progress
                                            self.showProgressInfoAlert = true
                                        }
                                }
                            }
                        }   // End of LazyVGrid
                        .padding()
                        
                    }   // End of ScrollView
                    .alert(isPresented: $showProgressInfoAlert, content: { self.progressInfoAlert })
                    .navigationBarTitle(Text("Progress"))
                }   // End of VStack
               
            }   // End of ZStack
            
            // Place the Edit button on left and Add (+) button on right of the navigation bar
            .navigationBarItems(trailing:
                                    NavigationLink(destination: AddProgress()) {
                                        Image(systemName: "plus")
                                    })
            
        }
        .customNavigationViewStyle()
        
        
    }
    
    var progressInfoAlert: Alert {
        Alert(title: Text(selectedPhoto.date!),
                  message: Text("Weight: \(selectedPhoto.weight!) lbs."),
                  dismissButton: .default(Text("OK")) )
        }
    
    func getProgressDataString() -> String {
        //create an array to store the weight values in the data base
        var dataStringArray = [Double]()
        
        //append the fetched weight values to the array for processing
        for aProgress in allProgress {
            dataStringArray.append(Double(truncating: aProgress.weight!))
        }
        
        //create the string to build the data paramter on
        var dataParam = ""
        
        //condition to catch an empty data base
        if(dataStringArray.count == 0){
            return dataParam
        }
        //condition to catch when their are less than 30 values in the database
        if(dataStringArray.count <= 30){
            var count = 0
            //loop through each value to append to the string separating each value by commas excluding the last value
            for _ in dataStringArray {
                
                if(count < dataStringArray.count - 1){
                    dataParam = dataParam + "\(dataStringArray[count]),"
                }
                else {
                    dataParam = dataParam + "\(dataStringArray[count])"
                    break
                }
                count += 1
            }
        }
        //condition for when their are more than 30 values
        else {
            var count = dataStringArray.count - 30
            //loop through each value to append to the string separating each value by commas excluding the last value
            for _ in dataStringArray {
                
                if(count < dataStringArray.count - 1){
                    dataParam = dataParam + "\(dataStringArray[count]),"
                }
                else {
                    dataParam = dataParam + "\(dataStringArray[count])"
                    break
                }
                count += 1
            }
        }
        //return the data parameter to be put in the request url
        return dataParam
    }
    
    
}

struct ProgressTab_Previews: PreviewProvider {
    static var previews: some View {
        ProgressTab()
    }
}

