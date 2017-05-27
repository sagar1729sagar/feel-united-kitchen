//
//  ProfileData.swift
//  UNITED KITCHEN
//
//  Created by VIDYA SAGAR on 12/04/17.
//  Copyright © 2017 SSappS. All rights reserved.
//

import Foundation
import UIKit
import CoreData


class ProfileData {
    
     let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func addProfile(profile : Profile) -> Bool {
        
     let context = appDelegate.persistentContainer.viewContext
        
     let newProfile = NSEntityDescription.insertNewObject(forEntityName: "Profile", into: context)
        
        newProfile.setValue(profile.accountType, forKey: "accountType")
        newProfile.setValue(profile.address, forKey: "address")
        newProfile.setValue(profile.created, forKey: "created")
        newProfile.setValue(profile.emailAddress, forKey: "emailAddress")
        newProfile.setValue(profile.orderCount, forKey: "orderCount")
        newProfile.setValue(profile.personName, forKey: "personName")
        newProfile.setValue(profile.phoneNumber, forKey: "phoneNumber")
        newProfile.setValue(profile.updated, forKey: "updated")
        newProfile.setValue(profile.objectId, forKey: "objectId")

        do {
            try context.save()
        } catch {
            return false
        }
        
        return true
    }
    
    
    func getProfile() -> (Profile,Bool) {
    
        let profile = Profile()
        
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName : "Profile")
        request.returnsObjectsAsFaults = false
        
        do {
            
            let results = try context.fetch(request)
            if results.count > 0 {
                if let result = results[0] as? NSManagedObject {
                    if let address = result.value(forKey: "address") as? String {
                        profile.address = address
                    }
                    if let created = result.value(forKey: "created") as? NSDate {
                        profile.created = created
                    }
                    if let email = result.value(forKey: "emailAddress") as? String {
                        profile.emailAddress = email
                    }
                    if let name = result.value(forKey: "personName") as? String {
                        profile.personName = name
                    }
                    if let objectId = result.value(forKey: "objectId") as? String {
                        profile.objectId = objectId
                    }
                    if let phoneNumber = result.value(forKey: "phoneNumber") as? String {
                        profile.phoneNumber = phoneNumber
                    }
                    if let updated = result.value(forKey: "updated") as? NSDate {
                        profile.updated = updated
                    }
                    if let orderCount = result.value(forKey: "orderCount") as? String {
                        profile.orderCount = orderCount
                    }
                    
                    if let type = result.value(forKey: "accountType") as? String {
                        profile.accountType = type
                    }

                }
            }
            
        
        } catch {
            return (profile,false)
        }
    
    return (profile,true)
    }
    
    func profileCount() -> (Int,Bool) {
        
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName : "Profile")
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(request)
            return (results.count , true)
        } catch {
            return (0 , false)
        }
        
        return (0,true)
    }
    
    func removeProfiles() -> Bool {
        
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName : "Profile")
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(request)
            if results.count > 0 {
                for result in results {
                    context.delete(result as! NSManagedObject)
                    do {
                        try context.save()
                    } catch {
                        return false
                    }
                }
            }
        } catch {
            return false
        }
        
        
      return true
    }
    
    func incrementOrderCount() -> (Profile,Bool) {
        
        
        let (profile,success) = getProfile()
        
        if success {
           profile.orderCount = String(Int(profile.orderCount!)! + 1)
            if removeProfiles() {
                if addProfile(profile: profile){
                return (profile,true)
            }
            }
    }
        
        return (profile , false)
        
    }
    
    
    
    
}
