//
//  SceneDelegate.swift
//  The Goddess of Taste
//
//  Created by XCodeClub on 2020-08-03.
//  Copyright © 2020 ssapps. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import UserNotifications
import Firebase
import DropDown
import Backendless

class SceneDelegate: UIResponder, UIWindowSceneDelegate, UNUserNotificationCenterDelegate {
    
    let APP_ID = "63FED898-919F-F19E-FFF0-5F965EE6C800"
    let SECRET_KEY = "8A032987-9442-4E61-A42A-1CF9006C8D12"
    
    var backendless = Backendless.shared

    var window: UIWindow?

 //   var window: UIWindow?


    @available(iOS 13.0, *)
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        print("Scene delegate will connect to ")
        
        backendless.initApp(applicationId: APP_ID, apiKey: SECRET_KEY)
        print("Backendless initialised");
        
        IQKeyboardManager.shared.enable = true
        
  //      DropDown.startListeningToKeyboard()
        
        // DorpDown
              DropDown.startListeningToKeyboard()
              
              // Initialzing firebase
              
              FirebaseApp.configure()
              
              var ref : DatabaseReference
              ref = Database.database().reference()
              
              //Notification registration
              
              let center = UNUserNotificationCenter.current()
              center.delegate = self
              center.requestAuthorization(options: [.alert,.badge,.sound]) { (granted, error) in
                  UIApplication.shared.registerForRemoteNotifications()
              }
        
        // Storyboard selection
              
              let profile = ProfileData().getProfile()
              if profile.1 {
                  if profile.0.accountType == "normal"{
                      self.window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
                  } else if profile.0.accountType == "admin" {
                      self.window?.rootViewController = UIStoryboard(name: "Admin", bundle: nil).instantiateInitialViewController()
                  } else if profile.0.accountType == "delivery" {
                      self.window?.rootViewController = UIStoryboard(name: "Delivery", bundle: nil).instantiateInitialViewController()
                  }
              } else {
                  self.window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
              }
        
        
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    @available(iOS 13.0, *)
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
        print("Scene disconnect")
    }

    @available(iOS 13.0, *)
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        print("SCENE ACTIVE")
    }

    @available(iOS 13.0, *)
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    @available(iOS 13.0, *)
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    @available(iOS 13.0, *)
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
    



}

