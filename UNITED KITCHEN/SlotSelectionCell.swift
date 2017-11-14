//
//  SlotSelectionCell.swift
//  UNITED KITCHEN
//
//  Created by VIDYA SAGAR on 14/11/17.
//  Copyright © 2017 SSappS. All rights reserved.
//

import UIKit
import UIDropDown
//import DropDown

class SlotSelectionCell: UITableViewCell {
    
    var descLable = UILabel()
    var dropDown = UIDropDown()
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let rowHeight = UIScreen.main.bounds.height/10 + 20
        
        descLable = UILabel(frame: CGRect(x: 10, y: 10, width: UIScreen.main.bounds.width - 20, height: rowHeight/2))
        descLable.text = "Please select a slot for delivery"
       // nameLabel.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.width/16.2)
        descLable.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.width/20)
        descLable.textColor = UIColor.black
        self.contentView.addSubview(descLable)
        
        dropDown = UIDropDown(frame: CGRect(x: 20, y: descLable.bounds.origin.y + descLable.bounds.height + 20, width: UIScreen.main.bounds.width - 40, height: descLable.bounds.height))
        dropDown.placeholder = "Please select your area"
        dropDown.options = ["1","2","3"]
        dropDown.animationType = .Bouncing
//        dropDown.tableDidAppear { 
//            print("table appeared")
//        }
        self.contentView.addSubview(dropDown)
        
        
//        dropDown.anchorView = contentView
//        dropDown.direction = .any
//        dropDown.dataSource = ["Please wait","second wait"]
//        dropDown.width = UIScreen.main.bounds.width
//        
//        contentView.addSubview(dropDown)
//        
//        dropDown.show()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
