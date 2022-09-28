//
//  PhotoImageFromBinaryData.swift
//  GetFit
//
//  Created by Justin Maloney on 12/09/20.
//  Copyright © 2020 Justin Maloney. All rights reserved.
//
 
import Foundation
import SwiftUI
 
/*
**********************************
MARK: - Get Image from Binary Data
**********************************
*/
public func photoImageFromBinaryData(binaryData: Data?, defaultFilename: String) -> Image {
 
   // Create a UIImage object from binaryData
   let uiImage = UIImage(data: binaryData!)
 
   // Unwrap uiImage to see if it has a value
   if let imageObtained = uiImage {
     
       // Image is successfully obtained
       return Image(uiImage: imageObtained)
     
   } else {
       /*
        Image file with name 'defaultFilename' is returned if the image cannot be obtained
        from the binaryData given. Image file 'defaultFilename' must be given in Assets.xcassets
        */
       return Image(defaultFilename)
   }
}
 
 
