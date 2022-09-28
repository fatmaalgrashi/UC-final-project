//
//  AddParkVisit.swift
//  GetFit
//
//  Created by Justin Maloney on 12/09/20.
//  Copyright © 2020 Justin Maloney. All rights reserved.
//

import Foundation
import SwiftUI
import CoreData
import CoreLocation

struct AddProgress: View {
    
    /*
     Display this view as a Modal View and enable it to dismiss itself
     to go back to the previous view in the navigation hierarchy.
     */
    @Environment(\.presentationMode) var presentationMode
    
    // ❎ CoreData managedObjectContext reference
    @Environment(\.managedObjectContext) var managedObjectContext
    
    // ParkVisit Entity
    @State private var dateVisited = Date()
    @State private var fullName = ""
    @State private var mealConents = ""
    @State private var currentWeight = 0.0
    
    // National Park Visit Photo
    @State private var showImagePicker = false
    @State private var photoImageData: Data? = nil
    @State private var photoTakeOrPickIndex = 0     // Default: Take using camera
    
    // Alerts
    @State private var showProgressAddedAlert = false
    @State private var showInputDataMissingAlert = false
    @State private var dateOfProgress = Date()
    
    let photoTakeOrPickChoices = ["Camera", "Photo Library"]
    
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
            Section(header: Text("Current Weight")) {
                TextField("Enter Current Weight in lbs.", value: $currentWeight, formatter: self.numberFormatter)
                    .keyboardType(.numbersAndPunctuation)
            }
            Section(header: Text("Time and Date of Progress Update").padding(.top, 10)) {
                DatePicker(
                    selection: $dateOfProgress,
                    in: dateClosedRange,
                    displayedComponents: [.hourAndMinute, .date]  // Sets DatePicker to pick a date and time
                ){
                    Text("")
                }
            }
            Section(header: Text("Add Progres Photo")) {
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
            Section(header: Text("Progress Photo")) {
                progressPhotoImage
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100.0, height: 100.0)
            }
            .alert(isPresented: $showProgressAddedAlert, content: { self.progressAddedAlert })
        }   // End of Form
        .font(.system(size: 14))
        .disableAutocorrection(true)
        .autocapitalization(.words)
        .navigationBarTitle(Text("Add New Progress"))
        .alert(isPresented: $showInputDataMissingAlert, content: { self.inputDataMissingAlert })
        // Use single column navigation view for iPhone and iPad
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarItems(trailing:
                                Button(action: {
                                    if self.inputDataValidated() {
                                        self.saveNewMeal()
                                        self.showProgressAddedAlert = true
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
     MARK: - National Park Visit Photo
     ---------------------------------
     */
    var progressPhotoImage: Image {
        
        if let imageData = self.photoImageData {
            let photo = photoImageFromBinaryData(binaryData: imageData, defaultFilename: "ImageUnavailable")
            return photo
        } else {
            return Image("DefaultProgressPhoto")
        }
    }
    
    /*
     ------------------------------
     MARK: - Park Visit Saved Alert
     ------------------------------
     */
    var progressAddedAlert: Alert {
        Alert(title: Text("New Progress Saved to Progress Tracker!"),
              message: Text("Your new progress is successfully saved in the database!"),
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
              message: Text("Required Data: current weight."),
              dismissButton: .default(Text("OK")) )
    }
    
    /*
     -----------------------------
     MARK: - Input Data Validation
     -----------------------------
     */
    func inputDataValidated() -> Bool {
        
        if self.currentWeight <= 0.0 || self.currentWeight > 600 {
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
        let dateOfProgressString = dateFormatter.string(from: self.dateVisited)
        
        // Take the first 16 characters of stringDate
        let firstPart = dateOfProgressString.prefix(16)
       
        // Convert firstPart substring to String
        let cleanedStringDate = String(firstPart)
       
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
        /*
         ==========================================================
         Create an instance of the ParkVisit Entity and dress it up
         ==========================================================
         */
        // ❎ Create an instance of the ParkVisit Entity in CoreData managedObjectContext
        let aProgress = Progress(context: self.managedObjectContext)
        
        aProgress.weight = currentWeight as NSNumber
        aProgress.date = dateWithNewFormat
        
        
        /*
         ======================================================
         Create an instance of the Photo Entity and dress it up
         ======================================================
         */
        
        if let imageData = self.photoImageData {
            aProgress.photo = imageData
        } else {
            // Obtain default park visit photo image from Assets.xcassets as UIImage
            let photoUIImage = UIImage(named: "DefaultProgressPhoto")
            
            // Convert photoUIImage to data of type Data (Binary Data) in JPEG format with 100% quality
            let photoData = photoUIImage?.jpegData(compressionQuality: 1.0)
            
            // Assign photoData to Core Data entity attribute of type Data (Binary Data)
            
            aProgress.photo = photoData!
        }
        aProgress.photoUrl = ""
        aProgress.hasPhotoUrl = false as NSNumber
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

struct AddProgress_Previews: PreviewProvider {
    static var previews: some View {
        AddProgress()
    }
}
