//
//  ShareActivity.swift
//  GetFit
//
//  Created by Dominic Gennello on 12/8/20.
//

import Foundation
import UIKit
import SwiftUI
 
let activityViewController = ActivityViewControllerRepresentable()
 
class ActivityViewController: UIViewController {
 
    var pdfData: Data!
 
    @objc func sharePDF() {
        let activityViewController = UIActivityViewController(activityItems: [pdfData!], applicationActivities: nil)
        activityViewController.excludedActivityTypes =  [
            UIActivity.ActivityType.assignToContact,    // Exclude assigning the image to a contact.
        ]
        present(activityViewController, animated: true, completion: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
    }
}
 
struct ActivityViewControllerRepresentable: UIViewControllerRepresentable {
 
    let activityViewController = ActivityViewController()
 
    func makeUIViewController(context: Context) -> ActivityViewController {
        activityViewController
    }
    func updateUIViewController(_ uiViewController: ActivityViewController, context: Context) {
        // Unused
    }
    func sharePDF(pdfData: Data) {
        activityViewController.pdfData = pdfData
        activityViewController.sharePDF()
    }
}
