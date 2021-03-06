//
//  OrderDisplayCell.swift
//  UNITED KITCHEN
//
//  Created by VIDYA SAGAR on 07/05/17.
//  Copyright © 2017 SSappS. All rights reserved.
//

import UIKit
import FlexibleSteppedProgressBar
import SCLAlertView
import SwiftLocation
import Backendless

class OrderDisplayCell: UITableViewCell , FlexibleSteppedProgressBarDelegate{
    
    let backendless = Backendless.shared
    var giftedLabel = UILabel()
    var statusLabel = UILabel()
    var navInd = UIActivityIndicatorView()
    var progressBar = FlexibleSteppedProgressBar()
    var orderIdLabel = UILabel()
    var orderPerson = UILabel()
    var orderEmail = UILabel()
    var orderPhone = UILabel()
    var deliveryTimeLabel = UILabel()
    var ItemsHeading = UILabel()
    var getItemsButton = UIButton()
    var itemLabels = [UILabel]()
    var totalLabel = UILabel()
    var deliveryPreferenceLabel = UILabel()
    var addressLabel = UILabel()
    var addressTV = UITextView()
    var locationLabel = UILabel()
    var latitudeLabel = UILabel()
    var longitueLabel = UILabel()
    var revGeoCodingLabel = UILabel()
    var revGeoCodTV = UITextView()
    var orderCancelButton = UIButton()
    var intr = 0
    var order = OrderDetails(){
        didSet{
            setViews()
        }
    }
    

    func setViews() {
        giftedLabel = UILabel(frame: CGRect(x: 5, y: 0, width: UIScreen.main.bounds.width - 10, height: 30))
        giftedLabel.textAlignment = .right
        if order.isGifted == "1"{
        giftedLabel.text = "Gifted by : "+order.giftedBy!
        } else {
        giftedLabel.text = ""
        }
        self.contentView.addSubview(giftedLabel)
        
        statusLabel = UILabel(frame: CGRect(x: 10, y: 50, width: UIScreen.main.bounds.width - 10, height: 40))
        statusLabel.textColor = UIColor.blue
        statusLabel.textAlignment = .center
        statusLabel.text = getStatus(code: order.status!)
        self.contentView.addSubview(statusLabel)
        
        progressBar = FlexibleSteppedProgressBar(frame: CGRect(x: 20, y: 90, width: UIScreen.main.bounds.width - 50, height: 50))
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        progressBar.numberOfPoints = 6
        progressBar.lineHeight = 6
        progressBar.radius = 13
        progressBar.progressRadius = 10
        progressBar.progressLineHeight = 6
        progressBar.delegate = self
        progressBar.backgroundShapeColor = UIColor.gray.withAlphaComponent(0.2)
        progressBar.currentSelectedCenterColor = UIColor(red: 0/255, green: 204/255, blue: 0/255, alpha: 1)
        progressBar.selectedBackgoundColor = UIColor(red: 0/255, green: 204/255, blue: 0/255, alpha: 1)
        progressBar.textDistance = 50
          progressBar.currentIndex = Int(order.status!)!
        self.contentView.addSubview(progressBar)
        
        orderIdLabel = UILabel(frame: CGRect(x: 10, y: 150, width: UIScreen.main.bounds.width - 20, height: 30))
        orderIdLabel.textAlignment = .left
        orderIdLabel.text = "Order ID : "+order.orderId!
        self.contentView.addSubview(orderIdLabel)
        
        orderPerson = UILabel(frame: CGRect(x: 10, y: 190, width: UIScreen.main.bounds.width - 20, height: 30))
        orderPerson.textAlignment = .left
        orderPerson.text = "Order for : "+order.customerName!
        self.contentView.addSubview(orderPerson)
        
        orderEmail = UILabel(frame: CGRect(x: 10, y: 230, width: UIScreen.main.bounds.width - 20, height: 30))
        orderEmail.textAlignment = .left
        orderEmail.text = "Email : "+order.email!
        self.contentView.addSubview(orderEmail)
        
        orderPhone = UILabel(frame: CGRect(x: 10, y: 270, width: UIScreen.main.bounds.width - 20, height: 30))
        orderPhone.textAlignment = .left
        orderPhone.text = "Phone : "+order.phoneNumber!
        self.contentView.addSubview(orderPhone)
        
        deliveryTimeLabel = UILabel(frame: CGRect(x: 10, y: 310, width: UIScreen.main.bounds.width - 10, height: 90))
        deliveryTimeLabel.textAlignment = .left

        deliveryTimeLabel.numberOfLines = 0
        
        var intr_text = "To be be delivered on :\n"+DateHandler().dateToString(date: order.deliveryDate!)
        if order.deliveryTime == "0" {
            intr_text.append(" for Lunch \n")
        } else if order.deliveryTime == "1"{
            intr_text.append(" for Dinner \n")
        }
        if order.area != nil && order.slot != nil {
            intr_text.append(" between "+order.slot!+" at "+order.area!)
        }
        deliveryTimeLabel.text = intr_text
//        if order.deliveryTime == "0" {
//            deliveryTimeLabel.text = "To be be delivered on :\n"+DateHandler().dateToString(date: order.deliveryDate!)+" for Lunch"
//        } else if order.deliveryTime == "1"{
//            deliveryTimeLabel.text = "To be be delivered on :\n"+DateHandler().dateToString(date: order.deliveryDate!)+" for Dinner"
//        }
        self.contentView.addSubview(deliveryTimeLabel)
        
        deliveryPreferenceLabel = UILabel(frame: CGRect(x: 10, y: 410, width: UIScreen.main.bounds.width - 20, height: 30))
        if order.addressType == "0" {
            deliveryPreferenceLabel.text = "Address preference : Address"
        } else if order.addressType == "1" {
            deliveryPreferenceLabel.text = "Address preference : GPS Location"
            }
        self.contentView.addSubview(deliveryPreferenceLabel)
        
        addressLabel = UILabel(frame: CGRect(x: 10, y: 450, width: UIScreen.main.bounds.width - 20, height: 30))
        addressLabel.text = "Registered address :"
        self.contentView.addSubview(addressLabel)
        
        addressTV = UITextView(frame: CGRect(x: 10, y: 490, width: UIScreen.main.bounds.width - 20, height: 100))
        addressTV.font = UIFont.systemFont(ofSize: 15)
        addressTV.text = order.deliveryAddress
        self.contentView.addSubview(addressTV)
        
        locationLabel = UILabel(frame: CGRect(x: 10, y: 590, width: UIScreen.main.bounds.width - 20, height: 30))
        locationLabel.text = "Location :"
        self.contentView.addSubview(locationLabel)
        
        latitudeLabel = UILabel(frame: CGRect(x: 10, y: 630, width: UIScreen.main.bounds.width - 20, height: 30))
        latitudeLabel.text = "latitude : "+order.latitude!
        self.contentView.addSubview(latitudeLabel)
        
        longitueLabel = UILabel(frame: CGRect(x: 10, y: 670, width: UIScreen.main.bounds.width - 20, height: 30))
        longitueLabel.text = "longitude : "+order.longitude!
        self.contentView.addSubview(longitueLabel)
        

        
        
        ItemsHeading = UILabel(frame: CGRect(x: 10, y: 710, width: UIScreen.main.bounds.width - 20, height: 30))
        ItemsHeading.textAlignment = .left
        ItemsHeading.text = "Items :"
        self.contentView.addSubview(ItemsHeading)
        
        if order.items?.count == 0 {
        
        getItemsButton = UIButton(frame: CGRect(x: 30, y: 750, width: UIScreen.main.bounds.width/2 - 30, height: 30))
        getItemsButton.setTitle("Get items", for: .normal)
        getItemsButton.backgroundColor = UIColor.blue
        getItemsButton.setTitleColor(UIColor.white, for: .normal)
        getItemsButton.addTarget(self, action: #selector(getItems(sender:)), for: .touchDown)
        self.contentView.addSubview(getItemsButton)
            

            
        } else {
            
            for i in 0...((order.items?.count)! - 1) {
                let itemnameLabel = UILabel(frame: CGRect(x: 10, y: 750 + i*50, width: Int(UIScreen.main.bounds.width - 20), height: 40))
                itemnameLabel.textAlignment = .left
                itemnameLabel.text = order.items?[i].name
                self.contentView.addSubview(itemnameLabel)
                itemLabels.append(itemnameLabel)
                
                let quantityLabel = UILabel(frame: CGRect(x: Int(UIScreen.main.bounds.width/2 - 10), y: 720 + i*50, width: 100, height: 40))
                quantityLabel.textAlignment = .left
                quantityLabel.text = "x"+(order.items?[i].quantity!)!
                self.contentView.addSubview(quantityLabel)
                itemLabels.append(quantityLabel)
                
                let priceLabel = UILabel(frame: CGRect(x: Int(UIScreen.main.bounds.width - 120), y: 720 + i*50, width: 100, height: 40))
                priceLabel.textAlignment = .right
                priceLabel.text = "$"+multiply(quantity: (order.items?[i].quantity)!, price: (order.items?[i].price)!)
                self.contentView.addSubview(priceLabel)
                itemLabels.append(priceLabel)
                
            }
            
            totalLabel = UILabel(frame: CGRect(x:20, y: 750 + CGFloat((order.items?.count)!*50), width: UIScreen.main.bounds.width - 40, height: 40))
            totalLabel.textAlignment = .right
            totalLabel.text = "Total : $"+getTotal()
            self.contentView.addSubview(totalLabel)
            
          
        }
        
        


    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }
    
    func progressBar(_ progressBar: FlexibleSteppedProgressBar, textAtIndex index: Int, position: FlexibleSteppedProgressBarTextLocation) -> String {
        return ""
    }
    
    func progressBar(_ progressBar: FlexibleSteppedProgressBar, didSelectItemAtIndex index: Int) {
       
        // update order status
        navInd.startAnimating()
        let preIndex = Int(order.status!)!
        order.status = "\(index)"
        if index == 5 {
            order.isDelivered = "1"
        }
        statusLabel.text = getStatus(code: order.status!)
        backendless.data.of(OrderDetails.self).save(entity: order, responseHandler: { (result) in
            
            if OrderData().updateOrder(id: self.order.orderId!, status: "\(index)") {
                self.sendNotification(order: self.order)
            }
            
            
        }, errorHandler: { (error) in
             self.order.status = "\(preIndex)"
             progressBar.currentIndex = preIndex
             self.statusLabel.text = self.order.status
             self.order.isDelivered = "0"
                self.navInd.stopAnimating()
            SCLAlertView().showError("Cannot update", subTitle: "Server entry cannot be updated because of the following error \(String(describing: error.message))")
        })
        
        
    }
    
    func progressBar(_ progressBar: FlexibleSteppedProgressBar, canSelectItemAtIndex index: Int) -> Bool {
        if index <= progressBar.currentIndex {
        return false
        }
        return true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

    
    
    func sendNotification( order :OrderDetails ) {
       
        let publishOptions = PublishOptions()
//        let headers = ["ios-alert":" Order Update recieved","ios-badge":"1","ios-sound":"default","type":"orderupdate","orderId":order.orderId!,"status":order.status!,"android-ticker-text":" Order Update","android-content-title":order.orderId,"android-content-text":order.status]
        let headers = ["ios-alert":" Order Update recieved","ios-badge":"1","ios-sound":"default","type":"orderupdate","orderId":order.orderId!,"status":order.status!]
     //   publishOptions.assignHeaders(headers)
        publishOptions.setHeaders(headers: headers)
//        backendless?.messaging.publish("C"+order.phoneNumber!, message: "Any", publishOptions: publishOptions, response: { (status) in
//           
//            self.navInd.stopAnimating()
//            }, error: { (error) in
//                self.navInd.stopAnimating()
//                SCLAlertView().showWarning("Cannot notify", subTitle: "Notification couldnt be sent as the following fault occured \(error?.message)")
//        })
        
        if order.isGifted == "1" {
            backendless.messaging.publish(channelName: "C"+order.giftedBy!, message: "ANy", publishOptions: publishOptions, responseHandler: { (resposne) in
                
            }, errorHandler: { (fault) in
                   
            })
        }
        
        let deliveryOptions = DeliveryOptions()
      //  deliveryOptions.pushBroadcast(FOR_IOS.rawValue)
        deliveryOptions.setPushBroadcast(pushBroadcast: PushBroadcastEnum.FOR_IOS.rawValue)
        
        backendless.messaging.publish(channelName: "C"+order.phoneNumber!, message: "Any", publishOptions: publishOptions, deliveryOptions: deliveryOptions, responseHandler: { (status) in
            self.navInd.stopAnimating()
        }, errorHandler: { (error) in
                self.navInd.stopAnimating()
            SCLAlertView().showWarning("Cannot notify", subTitle: "Notification couldnt be sent as the following fault occured \(String(describing: error.message))")
        })
        
        
        
//        print("sending android")
        
        
        let publishOptions1 = PublishOptions()
//        let headers1 = ["android-ticker-text":" Order Update","android-content-title":order.orderId,"android-content-text":order.status,"orderid":order.orderId]
          let headers1 = ["android-ticker-text":" Order Update","android-content-title":order.orderId,"android-content-text":order.status,"orderid":order.orderId]
       // publishOptions1.assignHeaders(headers1)
        publishOptions1.setHeaders(headers: headers1 as [String : Any])
        let deliveryOptions1 = DeliveryOptions()
       // deliveryOptions.pushBroadcast(FOR_ANDROID.rawValue)
        deliveryOptions.setPushBroadcast(pushBroadcast: PushBroadcastEnum.FOR_ANDROID.rawValue)
        backendless.messaging.publish(channelName: "C"+order.phoneNumber!, message: order.orderId!+"and"+order.status!, publishOptions: publishOptions1, deliveryOptions: deliveryOptions1, responseHandler: { (status) in
            //do nothing
            
        }, errorHandler: { (fault) in
                //do nothing
            
        })
//        backendless?.messaging.publish("C"+order.giftedBy!, message: "Order update", publishOptions: publishOptions1, response: { (status) in
//            //code
//            print("sending android sent")
//            }, error: { (fault) in
//                // fault
//                print("sending android fault \(fault?.message)")
//        })

        
        
    }
    
    @objc func getItems(sender:UIButton) {
        order.items?.removeAll()
        navInd.startAnimating()
        let whereClause = "orderId = "+order.orderId!
        let queryBuilder = DataQueryBuilder()
        queryBuilder.setPageSize(pageSize: 100)
        queryBuilder.setWhereClause(whereClause: whereClause)
        backendless.data.of(OrderItems.self).find(queryBuilder: queryBuilder, responseHandler: { (data) in
            self.navInd.stopAnimating()
            
            if (data.count) > 0 {
                for element in data {
                    if let item = element as? OrderItems {
                        self.order.items?.append(item)
                    }
                }
                
                if OrderData().deleteOrder(id: self.order.orderId!) {
                    if OrderData().addOrder(orderDetails: self.order) {
                        self.prepareForReuse()
                        self.setViews()
                    }
                }
            }
        }, errorHandler: { (error) in
                self.navInd.stopAnimating()
                
            SCLAlertView().showWarning("Error", subTitle: "Cannot get items because of the error \(String(describing: error.message))")
        })
        
        
    }
    
    func getTotal() -> String {
        var total : Double = 0
        for item in order.items! {
            let price = multiply(quantity: item.quantity!, price: item.price!)
            let priceD = Double(price)
            total = total + priceD!
        }
        return String(total)
    }
    

    
    func getStatus(code : String) -> String {
        switch code {
        case "0":
            return "Order placed"
        case "1":
            return "Order confirmed"
        case "2":
            return "Cooking started"
        case "3":
            return "Food packed"
        case "4":
            return "Out for delivery"
        case "5":
            return "Delivered"
        default:
            return "I have no idea where it is"
        }
    }
    
    func multiply(quantity : String , price : String ) -> String {
        
        let quan = Double(quantity)
        let pr = Double(price)
        let final = quan! * pr!
        return String(final)
        
        
    }
    
    override func prepareForReuse() {
        giftedLabel.text = ""
        statusLabel.text = ""
        orderIdLabel.text = ""
        orderPhone.text = ""
        orderPerson.text = ""
        orderEmail.text = ""
        addressTV.text = ""
        deliveryTimeLabel.text = ""
        deliveryPreferenceLabel.text = ""
        totalLabel.text = ""
        latitudeLabel.text = ""
        longitueLabel.text = ""
        revGeoCodTV.text = ""
        for label in itemLabels{
        label.text = ""
        }
    }

}
