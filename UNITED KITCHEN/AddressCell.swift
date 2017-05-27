//
//  AddressCell.swift
//  UNITED KITCHEN
//
//  Created by VIDYA SAGAR on 29/04/17.
//  Copyright © 2017 SSappS. All rights reserved.
//

import UIKit

class AddressCell: UITableViewCell {
    
    var add = UIButton()
    var addressTV = UITextView()
    var addressChangeButton = UIButton()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
       // if ProfileData().profileCount().0 == 0 {
             add = UIButton(frame: CGRect(x: 10, y: 10, width: UIScreen.main.bounds.width - 20, height: UIScreen.main.bounds.height/10))
            add.setTitle("LOGIN/SIGNUP", for: .normal)
            add.backgroundColor = UIColor(red: 65/255, green: 105/255, blue: 225/255, alpha: 1)
            add.setTitleColor(UIColor.white, for: .normal)
            add.layer.cornerRadius = 10
            self.contentView.addSubview(add)
          //  add.isHidden = false
           // addressTV.isHidden = true
            
     //   } else {
            addressTV = UITextView(frame: CGRect(x: 10, y: 10, width: UIScreen.main.bounds.width - 20, height: UIScreen.main.bounds.height/6))
            addressTV.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.width/27)
            addressTV.textAlignment = .center
            self.contentView.addSubview(addressTV)
            addressChangeButton = UIButton(frame: CGRect(x: 10, y: addressTV.frame.origin.y + addressTV.bounds.height, width: UIScreen.main.bounds.width - 20, height: 30))
            addressChangeButton.setTitle("Change address?", for: .normal)
            addressChangeButton.setTitleColor(UIColor.blue, for: .normal)
            addressChangeButton.titleLabel?.textAlignment = .right
            addressChangeButton.titleLabel?.font = UIFont.systemFont(ofSize: UIScreen.main
        .bounds.width/27)
            addressChangeButton.addTarget(self, action: #selector(changePressed(sender:)), for: .touchDown)
            self.contentView.addSubview(addressChangeButton)
         //   add.isHidden = true
         //   addressTV.isHidden = false
            
      //  }
        
        
        
    }
    
    
    func changePressed(sender : UIButton) {
        addressTV.isEditable = true
        addressTV.layer.borderWidth = 1
        addressTV.layer.borderColor = UIColor.blue.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        add.isHidden = true
        addressTV.isHidden = true
        addressChangeButton.isHidden = true
//        if ProfileData().profileCount().0 != 0 {
//        add.isHidden = true
//        addressTV.isHidden = false
//        } else {
//        add.isHidden = false
//        addressTV.isHidden = true
//        }
//        for sv in self.contentView.subviews {
//        self.contentView.willRemoveSubview(sv)
//        }
    }

}
