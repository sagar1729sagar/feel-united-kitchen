//
//  OrderData.swift
//  UNITED KITCHEN
//
//  Created by VIDYA SAGAR on 05/05/17.
//  Copyright © 2017 SSappS. All rights reserved.
//

import Foundation
import CoreData

class OrderData {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func addOrder(orderDetails : OrderDetails) -> Bool {
        
      // print(21)
    
        let context = appDelegate.persistentContainer.viewContext
        let newOrder = NSEntityDescription.insertNewObject(forEntityName: "OrderDetails", into: context)
        newOrder.setValue(orderDetails.orderId, forKey: "orderId")
        newOrder.setValue(orderDetails.deliveryDate, forKey: "deliveryDate")
        newOrder.setValue(orderDetails.deliveryTime, forKey: "deliveryTime")
        newOrder.setValue(orderDetails.status, forKey: "status")
        newOrder.setValue(orderDetails.isDelivered, forKey: "isDelivered")
        newOrder.setValue(orderDetails.locationTrackingChannel, forKey: "locationTrackingChannel")
        newOrder.setValue(orderDetails.phoneNumber, forKey: "phoneNumber")
        newOrder.setValue(orderDetails.customerName, forKey: "customerName")
        newOrder.setValue(orderDetails.email, forKey: "email")
        newOrder.setValue(orderDetails.deliveryAddress, forKey: "deliveryAddress")
        newOrder.setValue(orderDetails.addressType, forKey: "addressType")
        newOrder.setValue(orderDetails.latitude, forKey: "latitude")
        newOrder.setValue(orderDetails.longitude, forKey: "longitude")
        newOrder.setValue(orderDetails.isGifted , forKey: "isGifted")
        newOrder.setValue(orderDetails.giftedBy, forKey: "giftedBy")
        newOrder.setValue(orderDetails.objectId, forKey: "objectId")
        newOrder.setValue(orderDetails.area, forKey: "area")
        newOrder.setValue(orderDetails.slot, forKey: "slot")
      //  newOrder.setValue(orderDetails.created, forKey: "created")
       // newOrder.setValue(orderDetails.updated, forKey: "updated")
        
//        print(22)
        
//        print(orderDetails.items)
        
        for item in orderDetails.items! {
            let newItem = NSEntityDescription.insertNewObject(forEntityName: "OrderItems", into: context)
            newItem.setValue(item.name, forKey: "name")
            newItem.setValue(item.price, forKey: "price")
            newItem.setValue(item.quantity, forKey: "quantity")
            newItem.setValue(item.orderId, forKey: "orderId")
            newItem.setValue(item.objectId, forKey: "objectId")
        //    newItem.setValue(item.created, forKey: "created")
         //   newItem.setValue(item.updated, forKey: "updated")
            newOrder.setValue(NSSet(object : newItem), forKey: "items")
            
        }

        do {
            try context.save()
        } catch {return false}
        
        return true
    }
    
    
    func getOrders() -> [OrderDetails] {
        var orders = [OrderDetails]()
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "OrderDetails")
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(request)
            if results.count > 0 {
                for result in results {
                    if let data = result as? NSManagedObject {
                        let order = (OrderDetails)()
                        order.items = []
                       
                        if let date = data.value(forKey: "deliveryDate") as? Date {
                            order.deliveryDate = date
                        } else {return []}
                        if let time = data.value(forKey: "deliveryTime") as? String {
                            order.deliveryTime = time
                        } else {return []}
                        if let status = data.value(forKey: "status") as? String {
                            order.status = status
                        } else {return []}
                        if let isDelivered = data.value(forKey: "isDelivered") as? String {
                            order.isDelivered = isDelivered
                        } else {return []}
                        if let channel = data.value(forKey: "locationTrackingChannel") as? String {
                            order.locationTrackingChannel = channel
                        } else {return []}
                        if let phone = data.value(forKey: "phoneNumber") as? String {
                            order.phoneNumber = phone
                        } else {return []}
                        if let name = data.value(forKey: "customerName") as? String {
                            order.customerName = name
                        } else {return []}
                        if let mail = data.value(forKey: "email") as? String {
                            order.email = mail
                        } else {return []}
                        if let address = data.value(forKey: "deliveryAddress") as? String {
                            order.deliveryAddress = address
                        } else {return []}
                        if let type = data.value(forKey: "addressType") as? String {
                            order.addressType = type
                        } else {return []}
                        if let lat = data.value(forKey: "latitude") as? String {
                            order.latitude = lat
                        }
                        if let long = data.value(forKey: "longitude") as? String {
                            order.longitude = long
                        } 
                        if let gidfted = data.value(forKey: "isGifted") as? String {
                            order.isGifted = gidfted
                        } else {return []}
                        if let by = data.value(forKey: "giftedBy") as? String {
                            order.giftedBy = by
                        } else {return []}
                        if let objId = data.value(forKey: "objectId") as? String {
                            order.objectId = objId
                        } else {return []}
                        if let area = data.value(forKey: "area") as? String {
                            order.area = area
                        } 
                        if let slot = data.value(forKey: "slot") as? String {
                            order.slot = slot
                        }
//                        if let created = data.value(forKey: "created") as? Date {
//                            order.created = created
//                        }
//                        if let updated = data.value(forKey: "updated") as? Date {
//                            order.updated = updated
//                        } 
                        if let id = data.value(forKey: "orderId") as? String {
                            order.orderId = id
                            
                            let req1 = NSFetchRequest<NSFetchRequestResult>(entityName: "OrderItems")
                            req1.returnsObjectsAsFaults = false
                            let predicate = NSPredicate(format: "%K == %@", "orderId" , id)
                            req1.predicate = predicate
                            do {
                            let newResults = try context.fetch(req1)
                                if newResults.count > 0 {
                                    for newResult in newResults {
                                        if let data1 = newResult as? NSManagedObject {
                                        let item = (OrderItems)()
                                            if let name = data1.value(forKey: "name") as? String {
                                            item.name = name
                                            }else{return[]}
                                            if let price = data1.value(forKey: "price") as? String {
                                            item.price = price
                                            }else {return[]}
                                            if let quantity = data1.value(forKey: "quantity") as? String {
                                            item.quantity = quantity
                                            }else{return[]}
                                            if let orderId = data1.value(forKey: "orderId") as? String {
                                            item.orderId = orderId
                                            } else {return[]}
                                            if let objectId = data1.value(forKey: "objectId") as? String {
                                                item.objectId = objectId
                                            } else {return[]}
                                            if let updated = data1.value(forKey: "updated") as? Date {
                                                item.updated = updated
                                            }
                                            order.items?.append(item)
                                        }else {return[]}
                                       
                                    }
                                }
                               
                            }catch {return []}
                            
                        } else {return []}
                        orders.append(order)
                    } else { return [] }
        
                }
            } else { return [] }
        }catch { return []}
        
        return orders
        
    }
    
    func deleteOrders() -> Bool {
        
      
        
        let context = appDelegate.persistentContainer.viewContext
        
        let request1 = NSFetchRequest<NSFetchRequestResult>(entityName : "OrderDetails")
        request1.returnsObjectsAsFaults = false
        let request2 = NSFetchRequest<NSFetchRequestResult>(entityName : "OrderItems")
        request2.returnsObjectsAsFaults = false
        
        
        do {
            let orders = try context.fetch(request1)
            if orders.count > 0 {
                for order in orders {
                    context.delete(order as! NSManagedObject)
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
        
        
        do {
            let items = try context.fetch(request2)
            if items.count > 0 {
              
                for item in items {
                  
                    context.delete(item as! NSManagedObject)
                    
                    do {
                        try context.save()
                     
                    }catch {
                       
                        return false
                    }
                }
            }
            
        } catch {
            return false
        }
        
        return true
    }
    
    
    func updateOrder(id : String , status : String) -> Bool {
    
 
        
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName :"OrderDetails")
        request.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(request)
            for result in results {
                if let obtained = result as? NSManagedObject {
                    if let orderId = obtained.value(forKey: "orderId") as? String {
                        if orderId == id {
                            
                            obtained.setValue(status, forKey: "status")
                            if status == "5" {
                                obtained.setValue("1", forKey: "isDelivered")
                            }
                            
                            do {
                                try context.save()
                               
                            } catch {
                                return false
                            }
                            
                            
                        }
                    } else {return false}
                } else {return false}
            }
        } catch {
            return false
            
        }
        
        
        return true
    }
    
    
    
    func updateLocationTrackingChannel(id : String , channel : String) -> Bool {
      
        
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName :"OrderDetails")
        request.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(request)
            for result in results {
                if let obtained = result as? NSManagedObject {
                    if let orderId = obtained.value(forKey: "orderId") as? String {
                        if orderId == id {
                            
                            obtained.setValue(channel, forKey: "locationTrackingChannel")

                            
                            do {
                                try context.save()
                                
                            } catch {
                                return false
                            }
                            
                            
                        }
                    } else {return false}
                } else {return false}
            }
        } catch {
            return false
        
        }
        
        
        return true
    }
    
    func deleteOrder ( id : String) -> Bool {
    
        let context = appDelegate.persistentContainer.viewContext
        
        let request1 = NSFetchRequest<NSFetchRequestResult>(entityName : "OrderDetails")
        request1.returnsObjectsAsFaults = false
        let request2 = NSFetchRequest<NSFetchRequestResult>(entityName : "OrderItems")
        request2.returnsObjectsAsFaults = false
        
        do {
        let orders = try context.fetch(request1)
            if orders.count > 0 {
                for order in orders {
                    if let data = order as? NSManagedObject {
                        if let orderId = data.value(forKey: "orderId") as? String{
                            if orderId == id {
                            context.delete(data)
                                do {
                               try context.save()
                                }catch {return false}
                                // fetch items and delete
                                let predicate = NSPredicate(format: "%K == %@", "orderId" , id)
                                request2.predicate = predicate
                                do {
                                let items = try context.fetch(request2)
                                    if items.count > 0 {
                                        for item in items {
                                            do {
                                            try context.delete(item as! NSManagedObject)
                                            }catch{}
                                        }
                                    }
                                }catch{}
                            }
                        }else{return false}
                    }else{return false}
                }
            }
        }catch {return false}
        
        return true
    }

    
  
}
