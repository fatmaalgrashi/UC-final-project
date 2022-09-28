//
//  FlashlightButton.swift
//  GetFit
//
//  Created by Justin Maloney on 12/09/20.
//  Copyright © 2020 Justin Maloney. All rights reserved.
//
 
import SwiftUI
import AVFoundation
 
struct FlashlightButton: View {
 
    // Input Parameter passed by reference
    @Binding var lightOn: Bool
   
    var body: some View {
        Button(action: {
            withAnimation(.spring()) {
                self.toggleLight()
            }
        }) {
            Image(systemName: (lightOn ? "bolt.fill" : "bolt"))
                .imageScale(.medium)
                .font(Font.title.weight(.regular))
                .foregroundColor(self.lightOn ? .yellow: .blue)
                .scaleEffect(self.lightOn ? 1.2 : 1.0)
                .rotationEffect(.degrees(self.lightOn ? 360: 0))
        }
    }
   
    func toggleLight() {
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        self.lightOn.toggle()
       
        if device.hasTorch {
            do {
                try device.lockForConfiguration()
                device.torchMode = (self.lightOn) ? .on : .off
                device.unlockForConfiguration()
            } catch {
                print("Unable to Activate Flashlight!")
            }
        } else {
            print("Flashlight is Unavailable!")
        }
    }
}
 
 
