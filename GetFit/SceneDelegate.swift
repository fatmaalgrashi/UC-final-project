//
//  SceneDelegate.swift
//  NationalParks
//
//  Created by Osman Balci on 2/29/20.
//  Copyright © 2020 Osman Balci. All rights reserved.
//
 
import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
 
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        // Use a UIHostingController as window root view controller
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
           
            // ❎ Get object reference of CoreData managedObjectContext from the persistent container
            let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

            window.rootViewController = UIHostingController(rootView: ContentView( )
                // ❎ Pass the object reference to ContentView through the environment variable
                .environment(\.managedObjectContext, managedObjectContext)
                /*
                *****************************************************************************
                Inject instances of UserData() and AudioPlayer() classes into the environment
                and make them available to every View subscribing to them by declaring
                   @EnvironmentObject var userData: UserData
                   @EnvironmentObject var audioPlayer: AudioPlayer
                *****************************************************************************
                */
                .environmentObject(UserData())
            )
 
            self.window = window
            window.makeKeyAndVisible()
        }
    }
 
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
 
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
 
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
 
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
 
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
 
        // ❎ Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
 
}
 
 
