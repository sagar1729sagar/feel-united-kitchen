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
        newOrder.setValue(orderDetails.created, forKey: "created")
        newOrder.setValue(orderDetails.updated, forKey: "updated")
        print("while saving items count \(orderDetails.items?.count) and \(orderDetails.orderId)")
        for item in orderDetails.items! {
            let newItem = NSEntityDescription.insertNewObject(forEntityName: "OrderItems", into: context)
            newItem.setValue(item.name, forKey: "name")
            newItem.setValue(item.price, forKey: "price")
            newItem.setValue(item.quantity, forKey: "quantity")
            newItem.setValue(item.orderId, forKey: "orderId")
            newItem.setValue(item.objectId, forKey: "objectId")
            newItem.setValue(item.created, forKey: "created")
            newItem.setValue(item.updated, forKey: "updated")
            newOrder.setValue(NSSet(object : newItem), forKey: "items")
            
        }
        
        do {
            try context.save()
        } catch {return false}
        print("Order saved ]")
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
                        } else {print(1);return []}
                        if let time = data.value(forKey: "deliveryTime") as? String {
                            order.deliveryTime = time
                        } else {print(2);return []}
                        if let status = data.value(forKey: "status") as? String {
                            order.status = status
                        } else {print(3);return []}
                        if let isDelivered = data.value(forKey: "isDelivered") as? String {
                            order.isDelivered = isDelivered
                        } else {print(4);return []}
                        if let channel = data.value(forKey: "locationTrackingChannel") as? String {
                            order.locationTrackingChannel = channel
                        } else {print(5);return []}
                        if let phone = data.value(forKey: "phoneNumber") as? String {
                            order.phoneNumber = phone
                        } else {print(6);return []}
                        if let name = data.value(forKey: "customerName") as? String {
                            order.customerName = name
                        } else {print(7);return []}
                        if let mail = data.value(forKey: "email") as? String {
                            order.email = mail
                        } else {print(8);return []}
                        if let address = data.value(forKey: "deliveryAddress") as? String {
                            order.deliveryAddress = address
                        } else {print(9);return []}
                        if let type = data.value(forKey: "addressType") as? String {
                            order.addressType = type
                        } else {print(10);return []}
                        if let lat = data.value(forKey: "latitude") as? String {
                            order.latitude = lat
                        }
                        if let long = data.value(forKey: "longitude") as? String {
                            order.longitude = long
                        } 
                        if let gidfted = data.value(forKey: "isGifted") as? String {
                            order.isGifted = gidfted
                        } else {print(13);return []}
                        if let by = data.value(forKey: "giftedBy") as? String {
                            order.giftedBy = by
                        } else {print(14);return []}
                        if let objId = data.value(forKey: "objectId") as? String {
                            order.objectId = objId
                        } else {print(15);return []}
                        if let created = data.value(forKey: "created") as? Date {
                            order.created = created
                        }
                        if let updated = data.value(forKey: "updated") as? Date {
                            order.updated = updated
                        } 
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
                                            }else{print(18);return[]}
                                            if let price = data1.value(forKey: "price") as? String {
                                            item.price = price
                                            }else {print(19);return[]}
                                            if let quantity = data1.value(forKey: "quantity") as? String {
                                            item.quantity = quantity
                                            }else{print(20);return[]}
                                            if let orderId = data1.value(forKey: "orderId") as? String {
                                            item.orderId = orderId
                                            } else {print(21);return[]}
                                            if let objectId = data1.value(forKey: "objectId") as? String {
                                                item.objectId = objectId
                                            } else {print(22);return[]}
                                            if let created = data1.value(forKey: "created") as? Date {
                                                item.created = created
                                            }
                                            if let updated = data1.value(forKey: "updated") as? Date {
                                                item.updated = updated
                                            }
                                            order.items?.append(item)
                                        }else {print(25);return[]}
                                       // order.items?.append(item)
                                    }
                                }
                                //else {print(26);return []}
                            }catch {print(27);return []}
                            
                        } else {print(28);return []}
                        orders.append(order)
                    } else { print(29);return [] }
        
                }
            } else { print(30);return [] }
        }catch {print(31); return []}
        print("final return")
        return orders
        
    }
    
    func deleteOrders() -> Bool {
        
       // var isDeleted = false
        
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
                        //print("Couldnt delete")
                        return false
                    }
                }
            }
            //isDeleted = true
        } catch {
           // isDeleted = false
            return false
        }
        
        
        do {
            let items = try context.fetch(request2)
            if items.count > 0 {
              //  print(1)
                for item in items {
                   // print(2)
                    context.delete(item as! NSManagedObject)
                    //print(3)
                    do {
                        try context.save()
                      //  print(4)
                    }catch {
                        //print(5)
                        return false
                    }
                }
            }
            print("item count after relation destroyed \(items.count)")
        } catch {
            return false
        }
        //print("Ïs relation destroyed? \(isDeleted)")
        return true
    }
    
    
    func updateOrder(id : String , status : String) -> Bool {
     //   var isSuccess = false
        
        //        if order.confirmationStatus == "5" {
        //            order.deliveryStatus = "1"
        //        }
        
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
                                //isSuccess = true
                            } catch {
                                return false
                            }
                            
                            
                        }
                    } else {return false}
                } else {return false}
            }
        } catch {
            return false
            print("Cannot fetech order for status updation")
        }
        
        
        return true
    }
    
    
    
    func updateLocationTrackingChannel(id : String , channel : String) -> Bool {
        //   var isSuccess = false
        
        //        if order.confirmationStatus == "5" {
        //            order.deliveryStatus = "1"
        //        }
        
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
//                            if status == "5" {
//                                obtained.setValue("1", forKey: "isDelivered")
//                            }
                            
                            do {
                                try context.save()
                                //isSuccess = true
                            } catch {
                                return false
                            }
                            
                            
                        }
                    } else {return false}
                } else {return false}
            }
        } catch {
            return false
            print("Cannot fetech order for status updation")
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
