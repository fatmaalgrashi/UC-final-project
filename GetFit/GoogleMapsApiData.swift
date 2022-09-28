//
//  GoogleMapsApiData.swift
//  GetFit
//
//  Created by Nathan Lam on 11/21/20.
//

import SwiftUI
import Foundation
import MapKit

var gymFoundList = [Gym]()

let myApiKey = "AIzaSyCfCRGv93kDH_2-A4zhjJXbC0e7Oc3y6GE"

fileprivate var previousRadius = 0.0

/*
 ==================================
 MARK: - Obtain Gym Data from API
 ==================================
 */
public func obtainGymDataFromApi(radiusMiles: Int, currentLatitude: Double, currentLongitude: Double) {
    
    gymFoundList.removeAll()
    // Avoid executing this function if already done for the same radius
    // convert radius to meters
    let radius = 1609.34*Double(radiusMiles)
    if radius == previousRadius {
        return
    } else {
        previousRadius = radius
    }
    
    
    let apiUrl = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(currentLatitude),\(currentLongitude)&radius=\(radius)&type=gym&key=\(myApiKey)"
    
    /*
     searchQuery may include unrecognizable foreign characters inputted by the user that can prevent the creation of a URL struct from the given apiUrl string. Therefore, we must test it as an Optional
     */
    var apiQueryUrlStruct: URL?
    
    if let urlStruct = URL(string: apiUrl) {
        apiQueryUrlStruct = urlStruct
    } else {
        // gymFoundList will have the initial values set as above
        return
    }
    
    /*
     ***************************
     * HTTP GET Request Set Up *
     ***************************
     */
    let headers = [
        "accept": "application/json",
        "cache-control": "no-cache",
        "connection": "keep-alive",
        "host": "maps.googleapis.com"
    ]
    
    let request = NSMutableURLRequest(url: apiQueryUrlStruct!,
                        cachePolicy: .useProtocolCachePolicy,
                        timeoutInterval: 10.0)
    
    request.httpMethod = "GET"
    request.allHTTPHeaderFields = headers
    
    /*
     ***************************************
     Setting Up a URL Session to Fetch the JSON File from the API
     in an Asynchronous Manner and Processing the Received JSON File
     ***************************************
     */
    
    /*
     Create a semaphore to control getting and processing API data.
     signal() -> Int    Signals (increments) a semaphore.
     wait()     Waits for, or decrements, a semaphore
     */
    let semaphore = DispatchSemaphore(value: 0)
    
    URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
        /*
         URLSession is established and the JSON file from the API is set to be fetched in an asynchronous manner. After the file is fetched, data, response, error are returned as the input parameter values of this Completion Handler Closure.
         */
        
        // Process input parameter 'error'
        guard error == nil else {
            semaphore.signal()
            return
        }
        
        /*
         Any 'return' used within the completionHandler Closure exits the Closure; not the public function it is in.
         */
        
        // Process input parameter 'response'. HTTP response status codes from 200 to 299 indicate success.
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            semaphore.signal()
            return
        }
        
        // Process input parameter 'data'. Unwrap Optional 'data' if it has a value.
        guard let jsonDataFromApi = data else {
            semaphore.signal()
            return
        }
        
        //-----------------------------
        // JSON data is obtained from the API. Process it.
        //-----------------------------
        do {
            /*
             Foundation framework's JSONSerialization class is used to convert JSON data into Swift data types such as Dictionary, Array, String, Number, or Bool.
             */
            let jsonResponse = try JSONSerialization.jsonObject(with: jsonDataFromApi, options: JSONSerialization.ReadingOptions.mutableContainers)
            
            /*
             JSON object with Attribute-Value pairs corresponds to Swift Dictionary type with Key-Value pairs. Therefore, we use a Dictionary to represent a JSON object where Dictionary Key type is String and Value type is Any (instance of any type)
             */
            var jsonDataDictionary = Dictionary<String, Any>()
            
            if let jsonObject = jsonResponse as? [String: Any] {
                jsonDataDictionary = jsonObject
            } else {
                semaphore.signal()
                return
            }
            
            // Obtain Gym JSON array
            var gymJsonArray = [Any]()
            if let jArray = jsonDataDictionary["results"] as? [Any] {
                gymJsonArray = jArray
            } else {
                semaphore.signal()
                return
            }
            
            // Obtain Gym JSON Objects
            for i in 0...gymJsonArray.count-1 {
                
                var gymJsonObject = [String: Any]()
                if let jObject = gymJsonArray[i] as? [String: Any] {
                    gymJsonObject = jObject
                } else {
                    semaphore.signal()
                    return
                }
                
                var name = "", photo = "", open = true, rating = 0.0, vicinity = "", distance = 0.0, latitude = 0.0, longitude = 0.0
                
                if let gymGeo = gymJsonObject["geometry"] as? [String: Any] {
                    if let gymLoc = gymGeo["location"] as? [String: Any] {
                        if let gymLat = gymLoc["lat"] as? Double {
                            latitude = gymLat
                        }
                        if let gymLong = gymLoc["lng"] as? Double {
                            longitude = gymLong
                        }
                        let point1 = CLLocation(latitude: latitude, longitude: longitude)
                        let point2 = CLLocation(latitude: currentLatitude, longitude: currentLongitude)
                        distance = point2.distance(from: point1)
                        // convert distance to miles
                        distance = 0.000621371*distance
                    }
                }
                
                if let gymName = gymJsonObject["name"] as? String {
                    name = gymName
                }
                
                if let openingHours = gymJsonObject["opening_hours"] as? [String: Any] {
                    if let openNow = openingHours["open_now"] as? Bool {
                        open = openNow
                    }
                }
                
                var photoArray = [Any]()
                if let pArray = gymJsonObject["photos"] as? [Any] {
                    photoArray = pArray
                }
                
                if !photoArray.isEmpty {
                var photoJsonObject = [String: Any]()
                if let pObject = photoArray[0] as? [String: Any] {
                    photoJsonObject = pObject
                }
                
                if let gymPhoto = photoJsonObject["photo_reference"] as? String {
                    let photo_reference = gymPhoto
                    photo = "https://maps.googleapis.com/map/apis/place/photo?maxwidth=500&photoreference=\(photo_reference)&key=\(myApiKey)"
                }
                }
                
                if let gymRating = gymJsonObject["rating"] as? Double {
                    rating = gymRating
                }
                
                if let gymVicinity = gymJsonObject["vicinity"] as? String {
                    vicinity = gymVicinity
                }
                
                let gym = Gym(id: UUID(), name: name, photo: photo, open: open, rating: rating, vicinity: vicinity, distance: distance, latitude: latitude, longitude: longitude)
                
                
                gymFoundList.append(gym)
                
            }
        } catch {
            semaphore.signal()
            return
        }
        semaphore.signal()
    }).resume()
    
    /*
     The URLSession task above is set up. It begins in a suspended state. The resume() method starts processing the task in an execution thread.
     
     The semaphore.wait blocks the execution thread and starts waiting.
     Upon completion of the task, the Completion Handler code is executed.
     The waiting ends when .signal() fires
     */
    
    _ = semaphore.wait(timeout: .now())
}
