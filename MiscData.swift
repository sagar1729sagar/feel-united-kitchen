//
//  MiscData.swift
//  UNITED KITCHEN
//
//  Created by VIDYA SAGAR on 26/04/17.
//  Copyright © 2017 SSappS. All rights reserved.
//

import Foundation
import CoreData

class MiscData {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func addIndex(index : Int) {
        
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName : "Misc")
        request.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(request)
            if results.count == 0 {
                let newEntry = NSEntityDescription.insertNewObject(forEntityName: "Misc", into: context)
                newEntry.setValue(String(index), forKey: "index")
                newEntry.setValue(Date(), forKey: "selectedDate")
                
                    do {
                        try context.save()
                    } catch {
                           
                    }
            } else {
                if let result = results[0] as? NSManagedObject {
                    result.setValue(String(index), forKey: "index")
                    
                    do {
                        try context.save()
                    } catch {
                        
                    }
                }
            }
        }catch{
        }
        
        
    }
    
    
    func getIndex() -> Int {
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName : "Misc")
        request.returnsObjectsAsFaults = false
        do {
         let results = try context.fetch(request)
            if results.count > 0 {
                if let result = results[0] as? NSManagedObject {
                    if let index = result.value(forKey: "index") as? String {
                    
                        return Int(index)!
                    }
                }
            }
        }catch {}
         return 0
    }

    func addDate(date : Date) {
        
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName : "Misc")
        request.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(request)
            if results.count == 0 {
                let newEntry = NSEntityDescription.insertNewObject(forEntityName: "Misc", into: context)
                newEntry.setValue("0", forKey: "index")
                newEntry.setValue(date, forKey: "selectedDate")
                
                do {
                    try context.save()
                } catch {
                    
                }
            } else {
                if let result = results[0] as? NSManagedObject {
                    result.setValue(date, forKey: "selectedDate")
                    
                    do {
                        try context.save()
                    } catch {
                        
                    }
                }
            }
        }catch{
        }
    }
    
    func getSelectedDate() -> Date {
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName : "Misc")
        request.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(request)
            if results.count > 0 {
                if let result = results[0] as? NSManagedObject {
                    if let index = result.value(forKey: "selectedDate") as? Date {
                       
                        return index
                    }
                }
            }
        }catch {}
        return Date()
    }
    
    func addRefreshDate(date : Date ) {
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName : "Misc")
        request.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(request)
            if results.count == 0 {
                let newEntry = NSEntityDescription.insertNewObject(forEntityName: "Misc", into: context)
                newEntry.setValue("0", forKey: "index")
                newEntry.setValue(date, forKey: "selectedDate")
                newEntry.setValue(date, forKey: "menuRefreshDate")
                
                do {
                    try context.save()
                } catch {
                    
                }
            } else {
                if let result = results[0] as? NSManagedObject {
                    result.setValue(date, forKey: "menuRefreshDate")
                    
                    do {
                        try context.save()
                    } catch {
                        
                    }
                }
            }
        }catch{
        }
    }
    
    func getRefreshDate() -> Date {
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName : "Misc")
        request.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(request)
            if results.count > 0 {
                if let result = results[0] as? NSManagedObject {
                    if let index = result.value(forKey: "menuRefreshDate") as? Date {
                        
                        return index
                    }
                }
            }
        }catch {}
        return Date()
    }
    
}
