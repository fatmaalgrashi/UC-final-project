//
//  wgerData.swift
//  GetFit
//
//  Created by Dominic Gennello on 11/23/20.
//

import SwiftUI
import Foundation

var exercisesFromApi = [ExerciseStruct]()
 
/*
*********************************************
MARK: - Obtain Exercise Search By Category
*********************************************
*/
public func getExercisesFromAPI(id: Int, optionNum: Int) {
    var option = ""
    if (optionNum == 0) {
        option = "category"
    }
    else if (optionNum == 1) {
        option = "muscles"
    }
    else if (optionNum == 2) {
        option = "equipment"
    }
    // Initialize the array as an empty list
    exercisesFromApi = [ExerciseStruct]()
    let searchApiUrl = "https://wger.de/api/v2/exercise/?\(option)=\(id)&language=2&limit=500"
    
    // The function is given in ApiData.swift
    let jsonDataFromApi = getJsonDataFromApi(apiUrl: searchApiUrl)
 
    //------------------------------------------------
    // JSON data is obtained from the API. Process it.
    //------------------------------------------------
    
    do {
        /*
        Foundation framework’s JSONSerialization class is used to convert JSON data
        into Swift data types such as Dictionary, Array, String, Number, or Bool.
        */
        let jsonResponse = try JSONSerialization.jsonObject(with: jsonDataFromApi!,
                         options: JSONSerialization.ReadingOptions.mutableContainers)
        /*
        JSON object with Attribute-Value pairs corresponds to Swift Dictionary type with
        Key-Value pairs. Therefore, we use a Dictionary to represent a JSON object
        where Dictionary Key type is String and Value type is Any (instance of any type)
        */
        var jsonDataDictionary = Dictionary<String, Any>()
         
        if let jsonObject = jsonResponse as? [String: Any] {
           jsonDataDictionary = jsonObject
        } else {
           return
        }
        
        if let jsonArray = jsonDataDictionary["results"] as? [Any] {
            for aJsonObject in jsonArray {
                let jsonExerciseObject = aJsonObject as! [String: Any]
                var currExercise = ExerciseStruct(id: UUID(), name: "", category: "", muscles: "", equipment: "", description: "")
                if !(jsonExerciseObject["name"] is NSNull) {
                    if let name = jsonExerciseObject["name"] as! String? {
                        currExercise.name = name
                    }
                }
                if !(jsonExerciseObject["category"] is NSNull) {
                    if let categoryIndex = jsonExerciseObject["category"] as! Int? {
                        if (categoryIds.contains(categoryIndex)) {
                            let catIndex = categoryIds.firstIndex(of: categoryIndex)
                            currExercise.category = categories[catIndex ?? 0]
                        }
                    }
                }
                if let musclesArray = jsonExerciseObject["muscles"] as? [Int] {
                    for aMuscle in musclesArray {
                        if (muscleIds.contains(aMuscle)) {
                            let muscleIndex = categoryIds.firstIndex(of: aMuscle)
                            currExercise.muscles += "\(muscles[muscleIndex ?? 0]), "
                        }
                    }
                    if (currExercise.muscles.count != 0) {
                        currExercise.muscles.removeLast(2)
                    }
                }
                if let equipmentArray = jsonExerciseObject["equipment"] as? [Int] {
                    for anEquipment in equipmentArray {
                        if (equipmentIds.contains(anEquipment)) {
                            let equipmentIndex = equipmentIds.firstIndex(of: anEquipment)
                            currExercise.equipment += "\(equipment[equipmentIndex ?? 0]), "
                        }
                    }
                    if (currExercise.equipment.count != 0) {
                        currExercise.equipment.removeLast(2)
                    }
                }
                if !(jsonExerciseObject["description"] is NSNull) {
                    if var description = jsonExerciseObject["description"] as! String? {
                        description = description.replacingOccurrences(of: "<p>", with: "")
                        currExercise.description = description.replacingOccurrences(of: "</p>", with: " ")
                    }
                }
                exercisesFromApi.append(currExercise)
            }
        } else {
           return
        }
    } catch {
        print("Unable to retreive search results.")
    }
}
