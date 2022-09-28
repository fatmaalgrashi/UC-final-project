//
//  AddMeal.swift
//  GetFit
//
//  Created by Justin Maloney on 12/09/20.
//  Copyright © 2020 Justin Maloney. All rights reserved.
//

import Foundation
import SwiftUI
import CoreData
import CoreLocation

struct AddMeal: View {
    
    /*
     Display this view as a Modal View and enable it to dismiss itself
     to go back to the previous view in the navigation hierarchy.
     */
    @Environment(\.presentationMode) var presentationMode
    
    // ❎ CoreData managedObjectContext reference
    @Environment(\.managedObjectContext) var managedObjectContext
    
    // Meal Entity
    @State private var dateVisited = Date()
    @State private var fullName = ""
    @State private var categoryIndex = 1  // Default: "Very Good"
    @State private var mealConents = ""
    @State private var calorieTotal = 0.0
    @State private var proteinTotal = 0.0
    @State private var fatTotal = 0.0
    @State private var carbTotal = 0.0
    
    // Meal Photo
    @State private var showImagePicker = false
    @State private var photoImageData: Data? = nil
    @State private var photoTakeOrPickIndex = 0     // Default: Take using camera
    
    // Alerts
    @State private var showMealAddedAlert = false
    @State private var showInputDataMissingAlert = false
    @State private var timeOfMeal = Date()
    
    let photoTakeOrPickChoices = ["Camera", "Photo Library"]
    let mealCategory = ["Breakfast", "Lunch", "Dinner", "Snack"]
    
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
    
    var body: some View {
        Form {
            Section(header: Text("Category")) {
                Picker("", selection: $categoryIndex) {
                    ForEach(0 ..< mealCategory.count, id: \.self) {
                        Text(self.mealCategory[$0])
                    }
                }
                .pickerStyle(WheelPickerStyle())
            }
            Section(header: Text("Meal Contents"), footer:
                        Button(action: {
                            self.dismissKeyboard()
                        }) {
                            Image(systemName: "keyboard")
                                .font(Font.title.weight(.light))
                                .foregroundColor(.blue)
                        }
            ) {
                TextEditor(text: $mealConents)
                    .frame(height: 100)
                    .font(.custom("Helvetica", size: 14))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
            }
            Section(header: Text("Select Time and Date of Meal").padding(.top, 10)) {
                DatePicker(
                    selection: $timeOfMeal,
                    in: dateClosedRange,
                    displayedComponents: [.hourAndMinute, .date]  // Sets DatePicker to pick a date and time
                ){
                    Text("")
                }
            }
            Section(header: Text("Add Meal Photo")) {
                VStack {
                    Picker("Take or Pick Photo", selection: $photoTakeOrPickIndex) {
                        ForEach(0 ..< photoTakeOrPickChoices.count, id: \.self) {
                            Text(self.photoTakeOrPickChoices[$0])
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                    .padding()
                    
                    Button(action: {
                        self.showImagePicker = true
                    }) {
                        Text("Get Photo")
                            .padding()
                    }
                }   // End of VStack
            }
            Section(header: Text("Meal Photo")) {
                mealPhotoImage
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100.0, height: 100.0)
            }
            Section(header: Text("Calorie Total")) {
                TextField("Enter Calorie Total", value: $calorieTotal, formatter: self.numberFormatter)
                    .keyboardType(.numbersAndPunctuation)
            }
            Section(header: Text("Protein Total in grams")) {
                TextField("Enter Protein Total in grams", value: $proteinTotal, formatter: self.numberFormatter)
                    .keyboardType(.numbersAndPunctuation)
            }
            Section(header: Text("Fat Total in grams")) {
                TextField("Enter Fat Total in grams", value: $fatTotal, formatter: self.numberFormatter)
                    .keyboardType(.numbersAndPunctuation)
            }
            Section(header: Text("Carbohydrates Total in grams")) {
                TextField("Enter Carb Total in grams", value: $carbTotal, formatter: self.numberFormatter)
                    .keyboardType(.numbersAndPunctuation)
            }
            .alert(isPresented: $showMealAddedAlert, content: { self.mealAddedAlert })
        }   // End of Form
        .font(.system(size: 14))
        .disableAutocorrection(true)
        .autocapitalization(.words)
        .navigationBarTitle(Text("Add New Meal"))
        .alert(isPresented: $showInputDataMissingAlert, content: { self.inputDataMissingAlert })
        // Use single column navigation view for iPhone and iPad
        
        .navigationBarItems(trailing:
                                Button(action: {
                                    if self.inputDataValidated() {
                                        self.saveNewMeal()
                                        self.showMealAddedAlert = true
                                    } else {
                                        self.showInputDataMissingAlert = true
                                    }
                                }) {
                                    Text("Save")
                                })
        .sheet(isPresented: self.$showImagePicker) {
            PhotoCaptureView(showImagePicker: self.$showImagePicker,
                             photoImageData: self.$photoImageData,
                             cameraOrLibrary: self.photoTakeOrPickChoices[self.photoTakeOrPickIndex])
        }
        
    }   // End of body
    
    let numberFormatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.generatesDecimalNumbers = true
            formatter.minimum = 0.0
            formatter.maximum = 99999.999
            return formatter
        }()
    
    func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    /*
     ---------------------------------
     MARK: - Meal Photo
     ---------------------------------
     */
    var mealPhotoImage: Image {
        
        if let imageData = self.photoImageData {
            let photo = photoImageFromBinaryData(binaryData: imageData, defaultFilename: "ImageUnavailable")
            return photo
        } else {
            return Image("Dinner")
        }
    }
    
    /*
     ------------------------------
     MARK: - Meal Saved Alert
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
        
        if self.mealConents.isEmpty {
            return false
        }
        
        return true
    }
    
    /*
     ************************************
     MARK: - Save New Meal
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
         Create an instance of the Meal Entity and dress it up
         ==========================================================
         */
        // ❎ Create an instance of the Meal Entity in CoreData managedObjectContext
        let aMeal = Meal(context: self.managedObjectContext)
        let aNutrient = Nutrients(context: self.managedObjectContext)
        
        aNutrient.carbs = carbTotal as NSNumber
        aNutrient.protein =  proteinTotal as NSNumber
        aNutrient.fats =  fatTotal as NSNumber
        
        // ❎ Dress it up by specifying its attributes
        aMeal.timeOfMeal = timeOfMealString
        aMeal.calories =  calorieTotal as NSNumber
        aMeal.category = mealCategory[categoryIndex]
        aMeal.mealContents = mealConents
        aMeal.nutrients = aNutrient
        
        /*
         ======================================================
         Create an instance of the Photo Entity and dress it up
         ======================================================
         */
        
        if let imageData = self.photoImageData {
            aMeal.photo = imageData
        } else {
            // Obtain default park visit photo image from Assets.xcassets as UIImage
            let photoUIImage = UIImage(named: mealCategory[categoryIndex])
            
            // Convert photoUIImage to data of type Data (Binary Data) in JPEG format with 100% quality
            let photoData = photoUIImage?.jpegData(compressionQuality: 1.0)
            
            // Assign photoData to Core Data entity attribute of type Data (Binary Data)
            
            aMeal.photo = photoData!
        }
        aMeal.photoUrl = ""
        aMeal.hasPhotoUrl = false as NSNumber
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

struct AddMeal_Previews: PreviewProvider {
    static var previews: some View {
        AddMeal()
    }
}
