//
//  CartData.swift
//  UNITED KITCHEN
//
//  Created by VIDYA SAGAR on 27/04/17.
//  Copyright © 2017 SSappS. All rights reserved.
//

import Foundation
import CoreData

class CartData {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func addItem(item : Cart) -> Bool {
        let context = appDelegate.persistentContainer.viewContext
        let newItem = NSEntityDescription.insertNewObject(forEntityName: "Cart", into: context)
        
        newItem.setValue(item.addedDate, forKey:"addedDate")
        newItem.setValue(item.deliveryTime, forKey:"deliveryTime")
        newItem.setValue(item.itemName, forKey:"itemName")
        newItem.setValue(item.itemQuantity, forKey:"itemQuantity")
        
        do {
            try context.save()
        } catch {
            return false
        }
        
        return true
    }
    
    
    func getItems() -> ([Cart],Int,Bool) {
    
        var cartItems = [Cart]()
        var count = 0
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName : "Cart")
        request.returnsObjectsAsFaults = false
        
        do {
         let results = try context.fetch(request)
        count = results.capacity
            if count > 0  {
                for result in results {
                    let cartItem = Cart()
                    if let item = result as? NSManagedObject {
                        if let name = item.value(forKey: "itemName") as? String {
                            cartItem.itemName = name
                        } else {return ([],0,false)}
                        if let date = item.value(forKey: "addedDate") as? Date {
                            cartItem.addedDate = date
                        } else {return ([],0,false)}
                        if let quantity = item.value(forKey: "itemQuantity") as? String {
                            cartItem.itemQuantity = quantity
                        } else {return ([],0,false)}
                        if let time = item.value(forKey: "deliveryTime") as? String {
                            cartItem.deliveryTime = time
                        } else {return ([],0,false)}
                        
                        cartItems.append(cartItem)
                    }
                }
            }else {return ([],0,true)}
        } catch { return ([],0,false) }
        return (cartItems,count,true)
    }
    
    
    func incrementQuantityfor(itemName : String , date : Date , time : String) -> Bool {
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName : "Cart")
        request.returnsObjectsAsFaults = false
        do {
        let results = try context.fetch(request)
            if results.count > 0 {
                for result in results {
                    if let item = result as? NSManagedObject {
                        if let name = item.value(forKey: "itemName") as? String {
                            if let addedDate = item.value(forKey: "addedDate") as? Date {
                                if let deliveryTime = item.value(forKey: "deliveryTime") as? String {
                            if name == itemName {
                                if DateHandler().dateToString(date: addedDate) == DateHandler().dateToString(date: date) {
                                    if deliveryTime == time {
                                if let quantity = item.value(forKey: "itemQuantity") as? String {
                                    item.setValue( String(Int(quantity)! + 1) , forKey: "itemQuantity")
                                    do {
                                    try context.save()
                                    }catch{return false}
                                }else {return false}
                            
                            }
                            }
                            }
                        } else {return false}
                        } else {return false}
                        }else {return false}
                    } else {return false}
                }
            } else {return false}
        }catch {return false}
        return true
    }
    
    
    func decrementQuantityfor(itemName : String , date : Date , time : String) -> Bool {
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName : "Cart")
        request.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(request)
            if results.count > 0 {
                for result in results {
                    if let item = result as? NSManagedObject {
                        if let name = item.value(forKey: "itemName") as? String {
                            if let addedDate = item.value(forKey: "addedDate") as? Date {
                                if let deliveryTime = item.value(forKey: "deliveryTime") as? String {
                            if name == itemName {
                                if DateHandler().dateToString(date: addedDate) == DateHandler().dateToString(date: date) {
                                    if deliveryTime == time {
                                if let quantity = item.value(forKey: "itemQuantity") as? String {
                                    if quantity != "1" {
                                     item.setValue( String(Int(quantity)! - 1),
                                                  forKey: "itemQuantity")
                                    do {
                                        try context.save()
                                    }catch{return false}
                                    }
                                    }else {return false}
                                
                            }
                                    }
                                    }
                        } else {return false}
                        } else {return false}
                        } else {return false}
                    } else {return false}
                }
            } else {return false}
        }catch {return false}
        return true
    }
    
    
    func deleteItem(ofName : String , date :Date , time : String) -> Bool {
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName : "Cart")
        request.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(request)
            if results.count > 0 {
                for result in results {
                    if let item = result as? NSManagedObject{
                        if let name = item.value(forKey: "itemName") as? String {
                            if let addedDate = item.value(forKey: "addedDate") as? Date {
                                if let deliveryTime = item.value(forKey: "deliveryTime") as? String {
                            if name == ofName && DateHandler().dateToString(date: addedDate) == DateHandler().dateToString(date: date) && deliveryTime == time {
                                context.delete(item)
                                do {
                                    try context.save()
                                }catch{return false}
                            }
                        }else {return false}
                        } else {return false}
                        }else{return false}
                    }else{return false}
                }
            }else{return false }
        }catch{return false}
    return true
    }
    
    func deleteItems(ofName : String) -> Bool {
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName : "Cart")
        request.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(request)
            if results.count > 0 {
                for result in results {
                    if let item = result as? NSManagedObject{
                        if let name = item.value(forKey: "itemName") as? String {
 //                           if let addedDate = item.value(forKey: "addedDate") as? Date {
 //                               if let deliveryTime = item.value(forKey: "deliveryTime") as? String {
                                    if name == ofName {
                                        context.delete(item)
                                        do {
                                            try context.save()
                                        }catch{return false}
                                    }
  //                               }else {return false}
 //                           } else {return false}
                        }else{return false}
                    }else{return false}
                }
            }else{return false }
        }catch{return false}
        return true
    }
    
    
    
    
    func deleteCart() -> Bool {
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName : "Cart")
        request.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(request)
            if results.count > 0 {
                for result in results {
                    if let item = result as? NSManagedObject {
                        context.delete(item)
                        do {
                        try context.save()
                        }catch{ return false}
                    } else {return false}
                }
            }
        }catch{return false}
        return true
    }
    
    func updateDates(date : Date) -> Bool {
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName : "Cart")
        request.returnsObjectsAsFaults = false
        do {
        let results = try context.fetch(request)
            if results.count > 0 {
                for result in results {
                    if let item = result as? NSManagedObject {
                        item.setValue(date, forKey: "addedDate")
                        do{
                            try context.save()
                        }catch{return false}
                    }else{return false}
                }
            }else {return false}
        }catch{return false}
        return true
    }
    
    
    func deleteOrdersWithDatesandTimes(date : String , time : String) -> Bool {
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName : "Cart")
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(request)
            if results.count > 0 {
                for result in results {
                    if let data = result as? NSManagedObject {
                        if let addedDate = data.value(forKey: "addedDate") as? Date {
                            if let delTime = data.value(forKey: "deliveryTime") as? String {
                                if DateHandler().dateToString(date: addedDate) == date {
                                    if delTime == time {
                                        context.delete(data)
                                        do {
                                            try context.save()
                                        }catch {return false}
                                    }
                                }
                            } else {return false}
                        } else {return false}
                    } else {return false}
                }
            }
        } catch {
            return false
        }
        
        return true
    }
    
    
    

    
 }
