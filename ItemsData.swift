//
//  ItemsData.swift
//  UNITED KITCHEN
//
//  Created by VIDYA SAGAR on 24/04/17.
//  Copyright © 2017 SSappS. All rights reserved.
//

import Foundation
import CoreData

class MenuItemsData{

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func addItem( item : Item) -> Bool {
        
        let context = appDelegate.persistentContainer.viewContext
        let newItem = NSEntityDescription.insertNewObject(forEntityName: "MenuItems", into: context)
        
        newItem.setValue(item.itemId, forKey:"itemId")
        newItem.setValue(item.itemName, forKey:"itemName")
        newItem.setValue(item.itemUrl, forKey:"itemUrl")
        newItem.setValue(item.priceToday, forKey:"priceToday")
        newItem.setValue(item.priceTomorrow, forKey:"priceTomorrow")
        newItem.setValue(item.priceLater, forKey:"priceLater")
        newItem.setValue(item.availableMonday, forKey:"availableMonday")
        newItem.setValue(item.availableTuesday, forKey:"availableTuesday")
        newItem.setValue(item.availableWednesday, forKey:"availableWednesday")
        newItem.setValue(item.availableThrusday, forKey:"availableThrusday")
        newItem.setValue(item.availableFriday, forKey:"availableFriday")
        newItem.setValue(item.availableSaturday, forKey:"availableSaturday")
        newItem.setValue(item.availableSunday, forKey:"availableSunday")
        newItem.setValue(item.itemCategeory, forKey:"itemCategeory")
        newItem.setValue(item.foodType, forKey:"foodType")
        newItem.setValue(item.itemDescription, forKey:"itemDescription")
        newItem.setValue(item.displayOrder, forKey:"displayOrder")
        newItem.setValue(item.objectId, forKey:"objectId")
        newItem.setValue(item.created, forKey:"created")
        newItem.setValue(item.updated, forKey:"updated")
        
        do {
            try context.save()
        } catch {
            return false
        }
        
    return true
    }
    
    func getMenu() -> ([Item],Int,Bool) {
        var items = [Item]()
        var count = 0
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName : "MenuItems")
        request.returnsObjectsAsFaults = false
        
        do {
           let results = try context.fetch(request)
            count = results.count
         
            if count > 0 {
                for result in results {
                    let item = Item()
                    if let fetchedItem = result as? NSManagedObject {
                        if let itemId = fetchedItem.value(forKey: "itemId") as? String {
                            item.itemId = itemId
                        } else {
                            return ([],0,false)
                        }
                        if let itemName = fetchedItem.value(forKey: "itemName") as? String {
                            item.itemName = itemName
                        } else {
                            return ([],0,false)
                        }
                        if let itemUrl = fetchedItem.value(forKey: "itemUrl") as? String {
                            item.itemUrl = itemUrl
                        } else {
                            return ([],0,false)
                        }
                        if let priceToday = fetchedItem.value(forKey: "priceToday") as? String {
                            item.priceToday = priceToday
                        } else {
                            return ([],0,false)
                        }
                        if let priceTomorrow = fetchedItem.value(forKey: "priceTomorrow") as? String {
                            item.priceTomorrow = priceTomorrow
                        } else {
                            return ([],0,false)
                        }
                        if let priceLater = fetchedItem.value(forKey: "priceLater") as? String {
                            item.priceLater = priceLater
                        } else {
                            return ([],0,false)
                        }
                        if let availableMonday = fetchedItem.value(forKey: "availableMonday") as? String {
                            item.availableMonday = availableMonday
                        } else {
                            return ([],0,false)
                        }
                        if let availableTuesday = fetchedItem.value(forKey: "availableTuesday") as? String {
                            item.availableTuesday = availableTuesday
                        } else {
                            return ([],0,false)
                        }
                        if let availableWednesday = fetchedItem.value(forKey: "availableWednesday") as? String {
                            item.availableWednesday = availableWednesday
                        } else {
                            return ([],0,false)
                        }
                        if let availableThrusday = fetchedItem.value(forKey: "availableThrusday") as? String {
                            item.availableThrusday = availableThrusday
                        } else {
                            return ([],0,false)
                        }
                        if let availableFriday = fetchedItem.value(forKey: "availableFriday") as? String {
                            item.availableFriday = availableFriday
                        } else {
                            return ([],0,false)
                        }
                        if let availableSaturday = fetchedItem.value(forKey: "availableSaturday") as? String {
                            item.availableSaturday = availableSaturday
                        } else {
                            return ([],0,false)
                        }
                        if let availableSunday = fetchedItem.value(forKey: "availableSunday") as? String {
                            item.availableSunday = availableSunday
                        } else {
                            return ([],0,false)
                        }
                        if let itemCategeory = fetchedItem.value(forKey: "itemCategeory") as? String {
                            item.itemCategeory = itemCategeory
                        } else {
                            return ([],0,false)
                        }
                        if let foodType = fetchedItem.value(forKey: "foodType") as? String {
                            item.foodType = foodType
                        } else {
                            return ([],0,false)
                        }
                        if let itemDescription = fetchedItem.value(forKey: "itemDescription") as? String {
                            item.itemDescription = itemDescription
                        } else {
                            return ([],0,false)
                        }
                        if let displayORder = fetchedItem.value(forKey: "displayOrder") as? String {
                            item.displayOrder = displayORder
                        } else  { return ([],0,false) }
                        if let objectId = fetchedItem.value(forKey: "ObjectId") as? String {
                            item.objectId = objectId
                        }
                        if let created = fetchedItem.value(forKey: "created") as? Date {
                            item.created = created
                        }
                        if let updated = fetchedItem.value(forKey: "updated") as? Date {
                            item.created = updated
                        }
                        items.append(item)
                    } else {
                        return ([],0,false)
                    }
                }
            }
        } catch  {
            return ([],0,false)
        }
        
        return (items,count,true)
    }
    
    func editITem( name : String , replaceWith : Item) -> Bool {
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName : "MenuItems")
        request.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(request)
            if results.count > 0 {
                for result in results {
                    if let fetchedItem = result as? NSManagedObject {
                        if let fetchedName = fetchedItem.value(forKey: "itemName") as? String {
                            if fetchedName == name {
                                fetchedItem.setValue(replaceWith.itemId, forKey:"itemId")
                                fetchedItem.setValue(replaceWith.itemName, forKey:"itemName")
                                fetchedItem.setValue(replaceWith.itemUrl, forKey:"itemUrl")
                                fetchedItem.setValue(replaceWith.priceToday, forKey:"priceToday")
                                fetchedItem.setValue(replaceWith.priceTomorrow, forKey:"priceTomorrow")
                                fetchedItem.setValue(replaceWith.priceLater, forKey:"priceLater")
                                fetchedItem.setValue(replaceWith.availableMonday, forKey:"availableMonday")
                                fetchedItem.setValue(replaceWith.availableTuesday, forKey:"availableTuesday")
                                fetchedItem.setValue(replaceWith.availableWednesday, forKey:"availableWednesday")
                                fetchedItem.setValue(replaceWith.availableThrusday, forKey:"availableThrusday")
                                fetchedItem.setValue(replaceWith.availableFriday, forKey:"availableFriday")
                                fetchedItem.setValue(replaceWith.availableSaturday, forKey:"availableSaturday")
                                fetchedItem.setValue(replaceWith.availableSunday, forKey:"availableSunday")
                                fetchedItem.setValue(replaceWith.itemCategeory, forKey:"itemCategeory")
                                fetchedItem.setValue(replaceWith.foodType, forKey:"foodType")
                                fetchedItem.setValue(replaceWith.itemDescription, forKey:"itemDescription")
                                fetchedItem.setValue(replaceWith.displayOrder, forKey:"displayOrder")
                                fetchedItem.setValue(replaceWith.objectId, forKey:"objectId")
                                fetchedItem.setValue(replaceWith.created, forKey:"created")
                                fetchedItem.setValue(replaceWith.updated, forKey:"updated")
                                do {
                                try context.save()
                                } catch {
                                return false
                                }
                            }
                        } else {return false}
                    } else {
                        return false
                    }
                }
            } else {
                return false
            }
        } catch {
            return false
        }
        return true
    }
    
    func deleteItem ( name : String) -> Bool {
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName : "MenuItems")
        request.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(request)
            if results.count > 0 {
                for result in results {
                    if let fetchedItem = result as? NSManagedObject{
                        if let fetchedName = fetchedItem.value(forKey: "itemName") as? String {
                            if fetchedName == name {
                                context.delete(fetchedItem)
                                do {
                                    try context.save()
                                }catch{return false}
                            }
                        }else{return false}
                    }else{return false}
                }
            }
        }catch {return false}
        return true
    }
    
    func check(forItem : String) -> Bool {
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName : "MenuItems")
        request.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(request)
            if results.count > 0 {
                for result in results {
                    if let fetchedItem = result as? NSManagedObject{
                        if let fetchedName = fetchedItem.value(forKey: "itemName") as? String {
                            if fetchedName == forItem {
                                // true is returned in the end
                            }
                        }else{return false}
                    }else{return false}
                }
            }else{return false}
        }catch {return false}
        return true
    }
    
    func deleteMenu() -> Bool {
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName : "MenuItems")
        request.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(request)
            if results.count > 0 {
                for result in results {
                    if let fetchedItem = result as? NSManagedObject{
                        context.delete(fetchedItem)
                        do {try context.save()}
                        catch{return false}
                    }else{return false}
                }
            }
        }catch {return false}
        return true
    }
    
}
