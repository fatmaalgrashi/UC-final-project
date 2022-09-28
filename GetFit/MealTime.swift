//
//  MealTime.swift
//  GetFit
//
//  Created by Justin Maloney on 12/09/20.
//  Copyright © 2020 Justin Maloney. All rights reserved.
//
 
import SwiftUI
 
struct MealTime: View {
    // Input Parameter in format of "2020-01-18T12:26:..."
    var stringDate: String
   
    var body: some View {
        /*
         stringDate comes from the API in different formats after minutes:
             2020-01-20T15:58:17Z
             2020-01-19T15:00:11+00:00
             2020-01-15T18:53:26.2988181Z
         We only need first 16 characters of stringDate, i.e., 2020-01-20T15:58
         */
       
        // Take the first 16 characters of stringDate
        let firstPart = stringDate.prefix(16)
       
        // Convert firstPart substring to String
        let cleanedStringDate = String(firstPart)
        
        // Create an instance of DateFormatter
        let dateFormatter = DateFormatter()
       
        // Set date format and locale
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        dateFormatter.locale = Locale(identifier: "en_US")
        
        // Convert date String to Date struct
        let dateStruct = dateFormatter.date(from: cleanedStringDate)
        
        // Create a new instance of DateFormatter
        let newDateFormatter = DateFormatter()
        
        newDateFormatter.locale = Locale(identifier: "en_US")
        newDateFormatter.dateStyle = .medium    // Jan 18, 2020
        newDateFormatter.timeStyle = .medium    // at 12:26 PM
        
        // Obtain newly formatted Date String as "Jan 18, 2020 at 12:26 PM"
        let dateWithNewFormat = newDateFormatter.string(from: dateStruct!)
   
        return Text(dateWithNewFormat)
    }
}
 
struct MealTime_Previews: PreviewProvider {
    static var previews: some View {
        MealTime(stringDate: "2020-01-20T15:58:17Z")
    }
}
 
