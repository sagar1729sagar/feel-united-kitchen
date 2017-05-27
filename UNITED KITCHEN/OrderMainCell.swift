//
//  OrderMainCell.swift
//  UNITED KITCHEN
//
//  Created by VIDYA SAGAR on 09/05/17.
//  Copyright © 2017 SSappS. All rights reserved.
//

import UIKit
import FlexibleSteppedProgressBar

class OrderMainCell: UITableViewCell , FlexibleSteppedProgressBarDelegate{
    
    var order = OrderDetails(){
        didSet {
            setViews()
        }
    }
    var orderid = UILabel()
    var giftedLabel = UILabel()
    var statusLabel = UILabel()
    var progressBar = FlexibleSteppedProgressBar()
    var delTime = UILabel()
    var itemH = UILabel()
    var itemLabels = [UILabel]()
    var totalLabel = UILabel()
    
    
    

    func setViews() {
    
        orderid = UILabel(frame: CGRect(x: 5, y: 5, width: UIScreen.main.bounds.width - 10, height: 30))
        orderid.textAlignment = .left
        orderid.text = "Order ID : "+order.orderId!
        self.contentView.addSubview(orderid)
        
        giftedLabel = UILabel(frame: CGRect(x: UIScreen.main.bounds.width - 110, y: 5, width: 100, height: 30))
        giftedLabel.textAlignment = .right
        if order.isGifted == "0"{
        giftedLabel.text = ""
        } else if order.isGifted == "1" {
        giftedLabel.text = "GIFTED"
        }
        self.contentView.addSubview(giftedLabel)
        
        statusLabel = UILabel(frame: CGRect(x: 10, y: 50, width: UIScreen.main.bounds.width - 20, height: 30))
        statusLabel.textAlignment = .center
        statusLabel.textColor = UIColor.blue
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
        
        delTime = UILabel(frame: CGRect(x: 10, y: 150, width: UIScreen.main.bounds.width - 20, height: 30))
        if order.deliveryTime == "0" {
        delTime.text = "Delivery on "+DateHandler().dateToString(date: order.deliveryDate!)+" for Lunch"
        } else if order.deliveryTime == "1" {
        delTime.text = "Delivery on "+DateHandler().dateToString(date: order.deliveryDate!)+" for Dinner"
        }
        self.contentView.addSubview(delTime)
        
        itemH = UILabel(frame : CGRect(x: 10, y: 190, width: UIScreen.main.bounds.width - 20, height: 30))
        itemH.text = "Items : "
        self.contentView.addSubview(itemH)
        
        for i in 0...((order.items?.count)! - 1) {
            let name = UILabel(frame: CGRect(x: 10, y: Int(230 + CGFloat(i*40)), width: Int(UIScreen.main.bounds.width/2), height: 30))
            name.text = order.items?[i].name
            self.contentView.addSubview(name)
            itemLabels.append(name)
            
            let quantity = UILabel(frame: CGRect(x: UIScreen.main.bounds.width/2 + 10, y: 230 + CGFloat(i*40), width: UIScreen.main.bounds.width/4, height: 30))
            quantity.text = "x"+(order.items?[i].quantity)!
            self.contentView.addSubview(quantity)
            itemLabels.append(quantity)
            
            let price = UILabel(frame: CGRect(x: 3*UIScreen.main.bounds.width/4, y: 230 + CGFloat(i*40), width: UIScreen.main.bounds.width/4 - 20, height: 30))
            price.textAlignment = .right
            price.text = "$"+multiply(quantity: (order.items?[i].quantity!)!, price: (order.items?[i].price!)!)
            self.contentView.addSubview(price)
            itemLabels.append(price)
        }
        
        totalLabel = UILabel(frame: CGRect(x: 10, y: 230 + order.items!.count*40 , width: Int(UIScreen.main.bounds.width - 30), height: 30))
        totalLabel.textAlignment = .right
        totalLabel.text = "Total : $"+getTotal()
        self.contentView.addSubview(totalLabel)
        
        
        
        
    
        
    
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
    func progressBar(_ progressBar: FlexibleSteppedProgressBar, textAtIndex index: Int, position: FlexibleSteppedProgressBarTextLocation) -> String {
        return ""
    }
    func progressBar(_ progressBar: FlexibleSteppedProgressBar, canSelectItemAtIndex index: Int) -> Bool {
        return false
    }
    
    func multiply(quantity : String , price : String ) -> String {
        
        let quan = Double(quantity)
        let pr = Double(price)
        let final = quan! * pr!
        return String(final)
        
        
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
    
    
    override func prepareForReuse() {
        orderid.text = ""
        giftedLabel.text = ""
        statusLabel.text = ""
        delTime.text = ""
        for label in itemLabels{
        label.text = ""
        }
        totalLabel.text = ""
    }

}
