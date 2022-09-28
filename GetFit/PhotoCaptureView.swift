//
//  PhotoCaptureView.swift
//  GetFit
//
//  Created by Justin Maloney on 12/09/20.
//  Copyright © 2020 Justin Maloney. All rights reserved.
//
 
import SwiftUI
 
struct PhotoCaptureView: View {
      
    /*
    🔴 showImagePicker and photoImageData are passed as input parameters.
    @Binding creates a two-way connection between the caller and called in such a way that the
    called can change the caller's passed parameter value, i.e., wrapping an input parameter with
    @Binding implies that the input parameter's address is passed so that its value can be changed.
    */
  
    @Binding var showImagePicker: Bool
    @Binding var photoImageData: Data?
  
    let cameraOrLibrary: String
  
    var body: some View {
      
        ImagePicker(imagePickerShown: $showImagePicker,
                    photoImageData: $photoImageData,
                    cameraOrLibrary: cameraOrLibrary)
    }
}
 
 
