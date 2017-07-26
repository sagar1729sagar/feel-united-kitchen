//
//  AddressSelectionCell.swift
//  UNITED KITCHEN
//
//  Created by VIDYA SAGAR on 01/05/17.
//  Copyright © 2017 SSappS. All rights reserved.
//

import UIKit
import M13Checkbox

class AddressSelectionCell: UITableViewCell {
    
    var t1 = UILabel()
    var b1 = M13Checkbox()
    var t2 = UILabel()
    var b2 = M13Checkbox()
    var  orderButton = UIButton()
    var giftButton = UIButton()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
       
        t1 = UILabel(frame: CGRect(x: 10, y: 10, width: UIScreen.main.bounds.width - UIScreen.main.bounds.width/6.48, height: UIScreen.main.bounds.width/10.8))
        t1.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.width/21.6)
        t1.text = "Delivery address"
        self.contentView.addSubview(t1)
        
     
         b1 = M13Checkbox(frame: CGRect(x: UIScreen.main.bounds.width - UIScreen.main.bounds.width/6.48, y: 10, width:
            UIScreen.main.bounds.width/8.1, height: UIScreen.main.bounds.width/10.8))
        self.contentView.addSubview(b1)
        
        t2 = UILabel(frame: CGRect(x: 10 , y: UIScreen.main.bounds.width/10.8 + UIScreen.main.bounds.width/32.4, width: UIScreen.main.bounds.width - UIScreen.main.bounds.width/6.48, height: UIScreen.main.bounds.width/10.8))
        t2.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.width/21.6)
        t2.text = "Delivery Location"
        self.contentView.addSubview(t2)
        
        b2 = M13Checkbox(frame: CGRect(x: UIScreen.main.bounds.width - UIScreen.main.bounds.width/6.48, y: UIScreen.main.bounds.width/10.8 + UIScreen.main.bounds.width/32.4, width: UIScreen.main.bounds.width/8.1, height: UIScreen.main.bounds.width/10.8))
        self.contentView.addSubview(b2)
        
        orderButton = UIButton(frame: CGRect(x: 10, y: t2.bounds.height + t2.frame.origin.y + UIScreen.main.bounds.width/32.4, width: UIScreen.main.bounds.width - 20, height: UIScreen.main.bounds.width/8.1))
        orderButton.backgroundColor = UIColor(red: 220/255, green: 20/255, blue: 60/255, alpha: 1)
        orderButton.setTitleColor(UIColor.white, for: .normal)
        orderButton.setTitle("ORDER NOW", for: .normal)
        orderButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: UIScreen.main.bounds.width/16.2)
        self.contentView.addSubview(orderButton)
        
        giftButton = UIButton(frame: CGRect(x: 10, y: orderButton
            .bounds.height + orderButton.frame.origin.y + UIScreen.main.bounds.width/32.4, width: UIScreen.main.bounds.width - 20, height: UIScreen.main.bounds.width/8.1))
        giftButton.backgroundColor = UIColor(red: 65/255, green: 105/255, blue:225/255, alpha: 1)
        giftButton.setTitleColor(UIColor.white, for: .normal)
        giftButton.setTitle("GIFT THIS ORDER", for: .normal)
        giftButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: UIScreen.main.bounds.width/16.2)
        self.contentView.addSubview(giftButton)
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    


}
