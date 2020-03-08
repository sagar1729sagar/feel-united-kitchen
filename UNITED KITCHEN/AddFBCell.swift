//
//  AddFBCell.swift
//  UNITED KITCHEN
//
//  Created by VIDYA SAGAR on 09/05/17.
//  Copyright © 2017 SSappS. All rights reserved.
//

import UIKit
import Cosmos

class AddFBCell: UITableViewCell {
   // let backendless = Backendless.sharedInstance()
    var rating = CosmosView()
    var fbtext = UITextView()
    var submitButton = UIButton()
    var dismissButton = UIButton()
    var nameLabel = UILabel()
    var rated : Double = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        rating = CosmosView(frame: CGRect(x: 10, y: 10, width: UIScreen.main.bounds.width - 20, height: 30))
        rating.settings.fillMode = .half
        self.contentView.addSubview(rating)
        
        rating.didFinishTouchingCosmos = { rate in
            self.rated = rate
            
        }
        
        rating.didTouchCosmos = { rate in
            self.rated = rate
           
        }
        
        nameLabel = UILabel(frame: CGRect(x: 10, y: 40, width: UIScreen.main.bounds.width - 20, height: 30))
        self.contentView.addSubview(nameLabel)
        
        fbtext = UITextView(frame: CGRect(x: 10, y: 80, width: UIScreen.main.bounds.width - 20, height: 100))
       // fbtext.placeholderText = "Please enter your experience"
        fbtext.textColor = .black
        fbtext.text = ""
        fbtext.layer.borderWidth = 1
        fbtext.layer.borderColor = UIColor.gray.cgColor
        fbtext.layer.cornerRadius = 5
        fbtext.font = UIFont.systemFont(ofSize: 15)
        self.contentView.addSubview(fbtext)
        
        submitButton = UIButton(frame: CGRect(x: 2*UIScreen.main.bounds.width/3 - 20, y: 190, width: UIScreen.main.bounds.width/3, height: 30))
        submitButton.setTitle("SUBMIT", for: .normal)
        submitButton.setTitleColor(UIColor.white, for: .normal)
        submitButton.backgroundColor = UIColor.blue
        self.contentView.addSubview(submitButton)
        
        dismissButton = UIButton(frame: CGRect(x: UIScreen.main.bounds.width/3 - 60, y: 190, width: UIScreen.main.bounds.width/3, height: 30))
        dismissButton.setTitleColor(UIColor.white, for: .normal)
        dismissButton.setTitle("DISMISS", for: .normal)
        dismissButton.backgroundColor = UIColor.blue
        self.contentView.addSubview(dismissButton)
        
        
        
        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
       // fbtext.placeholderText = "Ënter your experience"
        fbtext.textColor = .black
        fbtext.text = ""
        fbtext.layer.borderWidth = 0
        fbtext.layer.borderColor = UIColor.gray.cgColor
        fbtext.layer.cornerRadius = 5
        
        submitButton.isHidden = false
        dismissButton.isHidden = false
        rating.rating
            = 1
    }

}
