//
//  Order.swift
//  UNITED KITCHEN
//
//  Created by VIDYA SAGAR on 04/05/17.
//  Copyright © 2017 SSappS. All rights reserved.
//

import Foundation

class OrderDetails : NSObject {
    
    
    var orderId : String?
    var deliveryDate : Date?
    var deliveryTime : String?
    var items : [OrderItems]?
    var status : String?
    var isDelivered : String?
    var locationTrackingChannel : String?
    var phoneNumber : String?
    var customerName : String?
    var email : String?
    var deliveryAddress : String?
    var addressType : String?
    var latitude : String?
    var longitude : String?
    var isGifted : String?
    var giftedBy : String?
    var objectId : String?
    var created : Date?
    var updated : Date?
}


class OrderItems : NSObject {
    
    var name : String?
    var price : String?
    var quantity : String?
    var orderId : String?
    var objectId : String?
    var created : Date?
    var updated : Date?

}


/**
 
 Delivery time 
 0 - Lunch
 1 - Dinner
 
 Status
 
 0 - placed
 1 - confirmed
 2 - cooking started
 3 - packed
 4 - out for delivery
 5 - delivered
 
 isDelivered
 0 - not delivered
 1 - delivered
 2 - Cancelled
 3 - Rejected
 
 Location tracking channel 
 nil - no delivery person assigned
 any other number - delviery person phone number
 
 Address type 
 0 - physical address
 1 - location coordinates
 
 isGifted
 0 - no
 1 - yes
 
 giftedBy 
 nil - no one
 any number - number of customer
 
 **/
