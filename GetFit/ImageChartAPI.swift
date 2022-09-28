//
//  WeatherData.swift
//  GetFit
//
//  Created by Justin Maloney on 12/09/20.
//  Copyright © 2020 Justin Maloney. All rights reserved.
//

import Foundation
import SwiftUI

fileprivate var previousData = ""
var foundGraphUrl = ""



/*
 ******************************
 MARK: - Get JSON Data from API
 ******************************
 */
public func getJsonDataFromApi(apiUrl: String) -> Data? {
    
    var apiQueryUrlStruct: URL?
    
    if let urlStruct = URL(string: apiUrl) {
        apiQueryUrlStruct = urlStruct
    } else {
        return nil
    }
    
    let jsonData: Data?
    do {
        /*
         Try getting the JSON data from the URL and map it into virtual memory, if possible and safe.
         Option mappedIfSafe indicates that the file should be mapped into virtual memory, if possible and safe.
         */
        jsonData = try Data(contentsOf: apiQueryUrlStruct!, options: Data.ReadingOptions.mappedIfSafe)
        return jsonData
        
    } catch {
        return nil
    }
}

