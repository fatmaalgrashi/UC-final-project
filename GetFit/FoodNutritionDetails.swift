//
//  FoodNutritionDetails.swift
//  GetFit
//
//  Created by Justin Maloney on 12/09/20.
//  Copyright © 2020 Justin Maloney. All rights reserved.
//
 
import SwiftUI
 
struct FoodNutritionDetails: View {
   
    // Input Parameter passed by reference
    @Binding var barcode: String
//    @Binding var carbRatio: String
    @State var carbRatio : String

    /*
     Display this view as a Modal View and enable it to dismiss itself
     to go back to the previous view in the navigation hierarchy.
     */
    @Environment(\.presentationMode) var presentationMode
    
    // ❎ CoreData managedObjectContext reference
    @Environment(\.managedObjectContext) var managedObjectContext
    
    // Alerts
    @State private var showMealAddedAlert = false
    @State private var showInputDataMissingAlert = false
    @State private var categoryIndex = 1
    @State private var mealServings = 1.0
    @State private var timeOfMeal = Date()
    @State private var dateVisited = Date()
    @State var unitAlert = false
    var dateAndTimeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .full     // e.g., Monday, June 29, 2020
        formatter.timeStyle = .short    // e.g., 5:19 PM
        return formatter
    }
    
    var dateClosedRange: ClosedRange<Date> {
        // Set minimum date to 20 years earlier than the current year
        let minDate = Calendar.current.date(byAdding: .year, value: -20, to: Date())!
        
        // Set maximum date to 10 years later than the current year
        let maxDate = Calendar.current.date(byAdding: .year, value: 10, to: Date())!
        return minDate...maxDate
    }
    
    let mealCategory = ["Breakfast", "Lunch", "Dinner", "Snack"]
   
    var body: some View {
        /*
         foodItem global variable was obtained in NutritionixApiData.swift
         A Form cannot have more than 10 Sections. Group the Sections if more than 10.
         */
        Form {
            Group {
//                Section(header: Text("Category")) {
//                    Picker("", selection: $categoryIndex) {
//                        ForEach(0 ..< mealCategory.count, id: \.self) {
//                            Text(self.mealCategory[$0])
//                        }
//                    }
//                    .pickerStyle(WheelPickerStyle())
//                }
//                Section(header: Text("Select Time and Date of Meal").padding(.top, 10)) {
//                    DatePicker(
//                        selection: $timeOfMeal,
//                        in: dateClosedRange,
//                        displayedComponents: [.hourAndMinute, .date]  // Sets DatePicker to pick a date and time
//                    ){
//                        Text("")
//                    }
//                }
                Section(header: Text("Enter Number of Servings consumed")) {
                    TextField("Enter Number of Servings", value: $mealServings, formatter: numberFormatter)
                        .keyboardType(.numbersAndPunctuation)
                }
                .alert(isPresented: $showMealAddedAlert, content: { self.mealAddedAlert })
                Section(header: Text("Brand Name")) {
                    Text(foodItem.brandName)
                }
                Section(header: Text("Food Name")) {
                    Text(foodItem.foodName)
                }
                Section(header: Text("Food Item Photo")) {
                    getImageFromUrl(url: foodItem.imageUrl)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(minWidth: 300, maxWidth: 500, alignment: .center)
                }
                Section(header: Text("Food Ingredients")) {
                    Text(foodItem.ingredients)
                }
                Section(header: Text("Serving Size")) {
                    Text("\(foodItem.servingQuantity) \(foodItem.servingUnit) (\(foodItem.servingWeight))")
                }
                Section(header: Text("Serving Size Calories")) {
                    Text(foodItem.calories)
                }
            }
            Group {
                Section(header: Text("Serving Size Dietary Fiber")) {
                    Text(foodItem.dietaryFiber)
                }
                Section(header: Text("Serving Size Protein")) {
                    Text(foodItem.protein)
                }
                Section(header: Text("Serving Size Saturated Fat")) {
                    Text(foodItem.saturatedFat)
                }
                Section(header: Text("Serving Size Sodium")) {
                    Text(foodItem.sodium)
                }
                Section(header: Text("Serving Size Sugars")) {
                    Text(foodItem.sugars)
                }
                Section(header: Text("Serving Size Total Carbohydrate")) {
                    Text(foodItem.totalCarbohydrate)
                }
                Section(header: Text("Serving Size Total Fat")) {
                    Text(foodItem.totalFat)
                }
            }
            Group {
                Section(header: Text("End of Nutrition Details")) {
                    Button(action: {
                        /*
                         Upon making ScanFoodBarcode's @State variable 'barcode' empty,
                         it invalidates its appearance and recomputes its body view
                         resulting in the display of the barcode scanning camera view
                         to enable another scan.
                         */
                        self.barcode = ""
                    }) {
                        HStack {
                            Image(systemName: "arrow.left.square.fill")
                                .imageScale(.large)
                                .font(Font.title.weight(.regular))
                            Text("Go Back")
                                .font(.headline)
                        }
                    }
                }
            }
            
        }   // End of Form
        .navigationBarTitle(Text("Add Meal via Barcode"))
        .font(.system(size: 14))
        .disableAutocorrection(true)
        .autocapitalization(.words)
        .navigationBarTitle(Text("Add New Meal"), displayMode: .inline)
        .alert(isPresented: $showInputDataMissingAlert, content: { self.inputDataMissingAlert })
        // Use single column navigation view for iPhone and iPad
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarItems(trailing:
                                Button(action: {
                                    if self.inputDataValidated() {
                                        
                                        unitAlert = true
                                         print("\(carbRatio)")
//                                        self.saveNewMeal()
//                                        self.showMealAddedAlert = true
                                    } else {
                                        self.showInputDataMissingAlert = true
                                    }
                                }) {
                                    Text("Save")
                                }) .alert(isPresented: $unitAlert, content: {
//                                    Alert(title: Text("you need\(calculateUnit(totalCarbohydrate:Double(foodItem.totalCarbohydrate) ?? 1.0, mealServings: Double(mealServings) , carbRatio:Double(self.carbRatio) ?? 1.0))")
//                                    Alert(title: Text("you need\(calculateUnit(totalCarbohydrate: Double(foodItem.totalCarbohydrate) ?? 0, mealServings:Double(mealServings) ?? 0, carbRatio: Double( $carbRatio.wrappedValue) ?? 0))"))
                                    Alert(title: Text("you need\(carbRatio)"))
                                 
                                    
                                })
    }
    
    let numberFormatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.generatesDecimalNumbers = true
            formatter.minimum = 0.0
            formatter.maximum = 99999.999
            return formatter
        }()
    
    /*
     ------------------------------
     MARK: - Park Visit Saved Alert
     ------------------------------
     */
    var mealAddedAlert: Alert {
        Alert(title: Text("New Meal Saved to Meal Tracker!"),
              message: Text("Your new meal is successfully saved in the database!"),
              dismissButton: .default(Text("OK")) {
                
                // Dismiss this Modal View and go back to the previous view in the navigation hierarchy
                self.presentationMode.wrappedValue.dismiss()
              })
    }
    
    /*
     --------------------------------
     MARK: - Input Data Missing Alert
     --------------------------------
     */
    var inputDataMissingAlert: Alert {
        Alert(title: Text("Missing Input Data!"),
              message: Text("Required Data: meal contents, calorie total, protein total, carb total, and fat."),
              dismissButton: .default(Text("OK")) )
    }
    
    /*
     -----------------------------
     MARK: - Input Data Validation
     -----------------------------
     */
    func inputDataValidated() -> Bool {
        
        if self.mealServings <= 0.0 {
            return false
        }
        
        return true
    }
    
    /*
     ************************************
     MARK: - Save New National Park Visit
     ************************************
     */
    func saveNewMeal() {
        
        // Instantiate a DateFormatter object
        let dateFormatter = DateFormatter()
        
        // Set the date format to yyyy-MM-dd
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        
        // Obtain DatePicker's selected date, format it as yyyy-MM-dd, and convert it to String
        let timeOfMealString = dateFormatter.string(from: self.dateVisited)
        
        /*
         ==========================================================
         Create an instance of the ParkVisit Entity and dress it up
         ==========================================================
         */
        // ❎ Create an instance of the ParkVisit Entity in CoreData managedObjectContext
        let aMeal = Meal(context: self.managedObjectContext)
        let aNutrient = Nutrients(context: self.managedObjectContext)
        
        let servings = Double(mealServings)
        
        aNutrient.carbs = (servings * Double(foodItem.totalCarbohydrate.dropLast(6))!) as NSNumber
        aNutrient.protein =  (servings * Double(foodItem.protein.dropLast(6))!) as NSNumber
        aNutrient.fats =  (servings * Double(foodItem.totalFat.dropLast(6))!) as NSNumber
        
        // ❎ Dress it up by specifying its attributes
        aMeal.timeOfMeal = timeOfMealString
        aMeal.calories =  (servings * Double(foodItem.calories)!) as NSNumber
        aMeal.category = mealCategory[categoryIndex]
        aMeal.mealContents = "\(foodItem.foodName):\n\(foodItem.ingredients)"
        aMeal.nutrients = aNutrient
        
        /*
         ======================================================
         Create an instance of the Photo Entity and dress it up
         ======================================================
         */
        
        if foodItem.imageUrl != "" {
            aMeal.photoUrl = foodItem.imageUrl
            
            aMeal.hasPhotoUrl = true as NSNumber
        }
        else {
            // Obtain default park visit photo image from Assets.xcassets as UIImage
            let photoUIImage = UIImage(named: "DefaultMealPhoto")
                
            // Convert photoUIImage to data of type Data (Binary Data) in JPEG format with 100% quality
            let photoData = photoUIImage?.jpegData(compressionQuality: 1.0)
                
            // Assign photoData to Core Data entity attribute of type Data (Binary Data)
                
            aMeal.photo = photoData!
            
            aMeal.hasPhotoUrl = false as NSNumber
        }
        
        
        aMeal.hasPhotoUrl = true as NSNumber
        /*
         ==================================
         Save Changes to Core Data Database
         ==================================
         */
        
        // ❎ CoreData Save operation
        do {
            try self.managedObjectContext.save()
        } catch {
            return
        }
        
    }   // End of function
}
 
struct FoodNutritionDetails_Previews: PreviewProvider {
    @State static var carbRatio: String = ""

    static var previews: some View {
        FoodNutritionDetails(barcode: .constant(""), carbRatio: carbRatio)
    }
}
func calculateUnit(totalCarbohydrate : Double, mealServings: Double, carbRatio : Double) -> Double{
    return totalCarbohydrate * mealServings * carbRatio
//    / carbRatio
}
