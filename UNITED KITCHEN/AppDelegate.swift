//
//  AppDelegate.swift
//  UNITED KITCHEN
//
//  Created by VIDYA SAGAR on 06/04/17.
//  Copyright © 2017 SSappS. All rights reserved.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import UserNotifications
import Firebase
import DropDown


@available(iOS 10.0, *)
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate , UNUserNotificationCenterDelegate{
    
    
    

    
//    let APP_ID = "9D0D0B57-308E-B7E3-FFBE-DD24A0BDD400"
//    let SECRET_KEY = "AE1C3531-AB6E-63D3-FF65-2DFF74761C00"
    
    let APP_ID = "970E86A5-60F0-F1BB-FFFD-96025990B900"
    let SECRET_KEY = "6B446BB0-8FAA-48F2-8EFD-1AE259826EE4"
    
    var backendless = Backendless.sharedInstance()

    var window: UIWindow?


    private func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // Initialise backendless
        backendless?.initApp(APP_ID, apiKey: SECRET_KEY)
        // LaunchImage display time
        Thread.sleep(forTimeInterval: 1)
        
        //IQKeyboard enable
      //  (IQKeyboardManager.sharedManager() as AnyObject).enable = true
        IQKeyboardManager.shared.enable = true
       
        // DorpDown
        DropDown.startListeningToKeyboard()
        
        // Initialzing firebase
        
        FirebaseApp.configure()
        
        var ref : DatabaseReference
        ref = Database.database().reference()

        backendless?.messaging.registerForRemoteNotifications()
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.badge,.sound]) { (accepted, error) in
            if accepted {
            } else {
              
            }
            
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

        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
      

        backendless?.messaging.registerDeviceToken(deviceToken, response: { (response) in
            
            }, error: { (error) in
                
        })
        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
       
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        
        if let type = userInfo["type"] as? String {
            if type == "menuupdate"{
                NotificationCenter.default.post(name: Notification.Name("menuupdate"), object: nil, userInfo: userInfo)
            }
        }
        
        if let type = userInfo["type"] as? String {
            if type == "neworder" {
               
              
                NotificationCenter.default.post(name: Notification.Name("neworder"), object: nil, userInfo: userInfo)
            }
        }
        
        
        if let type = userInfo["type"] as? String {
            
            if type == "orderupdate" {
                
             
                NotificationCenter.default.post(name: Notification.Name("orderupdate"), object: nil, userInfo: userInfo)
                
            }
        }
        
        
        if let type = userInfo["type"] as? String {
           
            if type == "orderupdate" {
                
               
                NotificationCenter.default.post(name: Notification.Name("orderupdateadmin"), object: nil, userInfo: userInfo)
                
            }
        }
        
        
        

    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "UNITED_KITCHEN")
       // let container = NSPersistentContainer(name: "UNITED_KITCHEN_v2")
//        let description = NSPersistentStoreDescription()
//        description.shouldInferMappingModelAutomatically = true
//        description.shouldMigrateStoreAutomatically = true
//        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

