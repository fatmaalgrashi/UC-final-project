//
//  NutritionixApiData.swift
//  GetFit
//
//  Created by Justin Maloney on 12/09/20.
//  Copyright © 2020 Justin Maloney. All rights reserved.
//
 
import Foundation
 
/*
 Nutrition data are obtained from Nutritionix API, https://www.nutritionix.com/business/api
 Version 2 API Documentation: https://developer.nutritionix.com/docs/v2
 To use this API, sign up at above URL and get your own appID and appKey.
 */
fileprivate let appID  = "bd4855b5"
fileprivate let appKey = "23456fbe7b2e823d0a0d9d9fb7285446"
 
// Declare foodItem as a global mutable variable accessible in all Swift files
var foodItem = FoodStruct(brandName: "", foodName: "", imageUrl: "", ingredients: "", calories: "", dietaryFiber: "", protein: "", saturatedFat: "", sodium: "", sugars: "", totalCarbohydrate: "", totalFat: "", servingQuantity: "", servingUnit: "", servingWeight: "")
 
fileprivate var previousUPC = ""
 
/*
 =================================================================
 Get Nutrition Data from the API for the Food Item with UPC.
 Universal Product Code (UPC) is a barcode symbology consisting of
 12 numeric digits that are uniquely assigned to a trade item.
 =================================================================
 */
public func getNutritionDataFromApi(upc: String) {
   
    // Avoid executing this function if already done for the same UPC
    if upc == previousUPC {
        return
    } else {
        previousUPC = upc
    }
   
    /*
     Create an empty instance of FoodStruct defined in FoodStruct.swift
     Assign its unique id to the global variable foodItem
     */
    foodItem = FoodStruct(brandName: "", foodName: "", imageUrl: "", ingredients: "", calories: "", dietaryFiber: "", protein: "", saturatedFat: "", sodium: "", sugars: "", totalCarbohydrate: "", totalFat: "", servingQuantity: "", servingUnit: "", servingWeight: "")
   
    /*
     *************************
     *   API Documentation   *
     *************************
    
     The API returns the following JSON file for a given food item UPC:
    
     {                      // Beginning of Top-Level JSON Object
         "foods" = [        // Beginning of JSON Array
             {              // Beginning of JSON Object
                 "alt_measures" = "<null>";
                 ✅"brand_name" = "Nature Valley";
                 ✅"food_name" = "Trail Mix Granola Bar, Fruit & Nut";
                 "full_nutrients" = ( … );
                 lat = "<null>";
                 lng = "<null>";
                 metadata = {};
                 "ndb_no" = "<null>";
                 ✅"nf_calories" = 140;
                 "nf_cholesterol" = 0;
                 ✅"nf_dietary_fiber" = 2;
                 ✅"nf_ingredient_statement" = "Whole Grain Oats, High Maltose Corn Syrup, ...";
                 "nf_p" = "<null>";
                 "nf_potassium" = "<null>";
                 ✅"nf_protein" = 3;
                 ✅"nf_saturated_fat" = "0.5";
                 ✅"nf_sodium" = 65;
                 ✅"nf_sugars" = 7;
                 ✅"nf_total_carbohydrate" = 25;
                 ✅"nf_total_fat" = 4;
                 "nix_brand_id" = 51db37cb176fe9790a8998a7;
                 "nix_brand_name" = "Nature Valley";
                 "nix_item_id" = 51c3624e97c3e69de4b02fbb;
                 "nix_item_name" = "Trail Mix Granola Bar, Fruit & Nut";
                 note = "<null>";
                 ✅photo = {
                     highres = "<null>";
                     "is_user_uploaded" = 0;
                     ✅thumb = "https://d1r9wva3zcpswd.cloudfront.net/5c8b546e4e2286f47884266f.jpeg";
                 };
                 ✅"serving_qty" = 1;
                 ✅"serving_unit" = bar;
                 ✅"serving_weight_grams" = 35;
                 source = 8;
                 tags = "<null>";
                 "updated_at" = "2019-03-15T07:29:51+00:00";
             }              // End of JSON Object
         ]                  // End of JSON Array
     }                      // End of Top-Level JSON Object
    
     */
 
    /*
    *********************************************
    *   Obtaining API Search Query URL Struct   *
    *********************************************
    */
   
    var apiQueryUrlStruct: URL?
   
     if let urlStruct = URL(string: "https://trackapi.nutritionix.com/v2/search/item?upc=\(upc)") {
         apiQueryUrlStruct = urlStruct
     } else {
         // foodItem will have the initial values set as above
         return
     }
   
    /*
    *******************************
    *   HTTP GET Request Set Up   *
    *******************************
    */
 
    let headers = [
        "x-app-id": appID,
        "x-app-key": appKey,
        "accept": "application/json",
        "cache-control": "no-cache",
        "host": "trackapi.nutritionix.com"
    ]
   
    let request = NSMutableURLRequest(url: apiQueryUrlStruct!,
                                      cachePolicy: .useProtocolCachePolicy,
                                      timeoutInterval: 10.0)
   
    request.httpMethod = "GET"
    request.allHTTPHeaderFields = headers
   
    /*
    *********************************************************************
    *  Setting Up a URL Session to Fetch the JSON File from the API     *
    *  in an Asynchronous Manner and Processing the Received JSON File  *
    *********************************************************************
    */
   
    /*
     Create a semaphore to control getting and processing API data.
     signal() -> Int    Signals (increments) a semaphore.
     wait()             Waits for, or decrements, a semaphore.
     */
    let semaphore = DispatchSemaphore(value: 0)
   
    URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
        /*
        URLSession is established and the JSON file from the API is set to be fetched
        in an asynchronous manner. After the file is fetched, data, response, error
        are returned as the input parameter values of this Completion Handler Closure.
        */
       
        // Process input parameter 'error'
        guard error == nil else {
            semaphore.signal()
            return
        }
       
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
 
        //------------------------------------------------
        // JSON data is obtained from the API. Process it.
        //------------------------------------------------
        do {
            /*
            Foundation framework’s JSONSerialization class is used to convert JSON data
            into Swift data types such as Dictionary, Array, String, Number, or Bool.
            */
            let jsonResponse = try JSONSerialization.jsonObject(with: jsonDataFromApi,
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
                semaphore.signal()
                return
            }
           
            //------------------------
            // Obtain Foods JSON Array
            //------------------------
           
            var foodsJsonArray = [Any]()
            if let jArray = jsonDataDictionary["foods"] as? [Any] {
                foodsJsonArray = jArray
            } else {
                semaphore.signal()
                return
            }
               
            //-------------------------
            // Obtain Foods JSON Object
            //-------------------------
           
            var foodsJsonObject = [String: Any]()
            if let jObject = foodsJsonArray[0] as? [String: Any] {
                foodsJsonObject = jObject
            } else {
                semaphore.signal()
                return
            }
           
            //----------------
            // Initializations
            //----------------
 
            var brand_name = "", food_name = "", photo_url = "", ingredient_statement = ""
            var caloriesAmount = "", dietary_fiber = "", proteinAmount = "", saturated_fat = ""
            var sodiumAmount = "", sugarAmount = "", total_carbohydrate = "", total_fat = ""
            var serving_quantity = "", serving_unit = "", serving_weight = ""
 
            //------------------
            // Obtain Brand Name
            //------------------
 
            if let nameOfBrand = foodsJsonObject["brand_name"] as? String {
                brand_name = nameOfBrand
            }
           
            //-----------------
            // Obtain Food Name
            //-----------------
           
            if let nameOfFood = foodsJsonObject["food_name"] as? String {
                food_name = nameOfFood
            } else {
                semaphore.signal()
                // Skip the food item if it does not have a name
                return
            }
           
            //---------------------------------
            // Obtain Food Item Photo Image URL
            //---------------------------------
           
            /*
             photo = {
                 highres = "<null>";
                 "is_user_uploaded" = 0;
                 thumb = "https://d1r9wva3zcpswd.cloudfront.net/5c8b546e4e2286f47884266f.jpeg";
             };
             */
            if let photoJsonObject = foodsJsonObject["photo"] as? [String: Any] {
                if let thumbUrl = photoJsonObject["thumb"] as? String {
                    photo_url = thumbUrl
                }
            }
               
            //-------------------
            // Obtain Ingredients
            //-------------------
            
            if let nf_ingredient_statement = foodsJsonObject["nf_ingredient_statement"] as? String {
                ingredient_statement = nf_ingredient_statement
            }
           
            //----------------
            // Obtain Calories
            //----------------
            
            if let nf_calories = foodsJsonObject["nf_calories"] as? Double {
                caloriesAmount = String(nf_calories)
            }
           
            //---------------------
            // Obtain Dietary Fiber
            //---------------------
            
            if let nf_dietary_fiber = foodsJsonObject["nf_dietary_fiber"] as? Double {
                dietary_fiber = "\(nf_dietary_fiber) grams"
            }
           
            //----------------------
            // Obtain Protein Amount
            //----------------------
            
            if let nf_protein = foodsJsonObject["nf_protein"] as? Double {
                proteinAmount = "\(nf_protein) grams"
            }
           
            //---------------------
            // Obtain Saturated Fat
            //---------------------
            
            if let nf_saturated_fat = foodsJsonObject["nf_saturated_fat"] as? Double {
                saturated_fat = "\(nf_saturated_fat) grams"
            }
               
            //---------------------
            // Obtain Sodium Amount
            //---------------------
            
            if let nf_sodium = foodsJsonObject["nf_sodium"] as? Double {
                sodiumAmount = "\(nf_sodium) milligrams"
            }
           
            //--------------------
            // Obtain Sugar Amount
            //--------------------
            
            if let nf_sugars = foodsJsonObject["nf_sugars"] as? Double {
                sugarAmount = "\(nf_sugars) grams"
            }
           
            //--------------------------
            // Obtain Total Carbohydrate
            //--------------------------
            
            if let nf_total_carbohydrate = foodsJsonObject["nf_total_carbohydrate"] as? Double {
                total_carbohydrate = "\(nf_total_carbohydrate)"
            }
           
            //------------------------
            // Obtain Total Fat Amount
            //------------------------
            
            if let nf_total_fat = foodsJsonObject["nf_total_fat"] as? Double {
                total_fat = "\(nf_total_fat) grams"
            }
           
            //------------------------
            // Obtain Serving Quantity
            //------------------------
            
            if let serving_qty = foodsJsonObject["serving_qty"] as? Int {
                serving_quantity = String(serving_qty)
            }
               
            //--------------------
            // Obtain Serving Unit
            //--------------------
            
            if let unitOfServing = foodsJsonObject["serving_unit"] as? String {
                serving_unit = unitOfServing
            }
           
            //----------------------
            // Obtain Serving Weight
            //----------------------
            
            if let serving_weight_grams = foodsJsonObject["serving_weight_grams"] as? Double {
                serving_weight = "\(serving_weight_grams) grams"
            }
               
            /*
             It is good practice to print out the values obtained from the
             JSON file during the app development to validate their accuracy.
             */
//                    print("brand_name = \(brand_name)")
//                    print("food_name = \(food_name)")
//                    print("photo_url = \(photo_url)")
//                    print("ingredient_statement = \(ingredient_statement)")
//                    print("caloriesAmount = \(caloriesAmount)")
//                    print("dietary_fiber = \(dietary_fiber)")
//                    print("proteinAmount = \(proteinAmount)")
//                    print("saturated_fat = \(saturated_fat)")
//                    print("sodiumAmount = \(sodiumAmount)")
//                    print("sugarAmount = \(sugarAmount)")
//                    print("total_carbohydrate = \(total_carbohydrate)")
//                    print("total_fat = \(total_fat)")
//                    print("serving_quantity = \(serving_quantity)")
//                    print("serving_unit = \(serving_unit)")
//                    print("serving_weight = \(serving_weight)")
               
            /*
             Create an instance of FoodStruct, dress it up with the values obtained from the API,
             and set its id to the global variable foodItem
             */
            foodItem = FoodStruct(brandName: brand_name, foodName: food_name, imageUrl: photo_url, ingredients: ingredient_statement, calories: caloriesAmount, dietaryFiber: dietary_fiber, protein: proteinAmount, saturatedFat: saturated_fat, sodium: sodiumAmount, sugars: sugarAmount, totalCarbohydrate: total_carbohydrate, totalFat: total_fat, servingQuantity: serving_quantity, servingUnit: serving_unit, servingWeight: serving_weight)
               
        } catch {
            semaphore.signal()
            return
        }
       
        semaphore.signal()
    }).resume()
   
    /*
     The URLSession task above is set up. It begins in a suspended state.
     The resume() method starts processing the task in an execution thread.
    
     The semaphore.wait blocks the execution thread and starts waiting.
     Upon completion of the task, the Completion Handler code is executed.
     The waiting ends when .signal() fires or timeout period of 10 seconds expires.
    */
 
    _ = semaphore.wait(timeout: .now() + 10)
       
}
 
 
