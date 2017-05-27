//
//  GiftedPersonDetailsCell.swift
//  UNITED KITCHEN
//
//  Created by VIDYA SAGAR on 04/05/17.
//  Copyright © 2017 SSappS. All rights reserved.
//

import UIKit


class GiftedPersonDetailsCell: UITableViewCell {
    
    var nameLabel = UILabel()
    var nameTF = UITextField()
    var mobileLabel = UILabel()
    var mobileTF = UITextField()
    var addressLabel = UILabel()
    var addressTV = UITextView()
    var proceedButton = UIButton()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        nameLabel = UILabel(frame: CGRect(x: 0, y: 5, width: UIScreen.main.bounds.width/4, height: UIScreen.main.bounds.height/14))
        nameLabel.text = "Name : "
        nameLabel.textAlignment = .right
        nameLabel.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.width/21.6)
        nameLabel.backgroundColor = UIColor.white
        self.contentView.addSubview(nameLabel)
        
        nameTF = UITextField(frame: CGRect(x: UIScreen.main.bounds.width/4, y: 5, width: 3*UIScreen.main.bounds.width/4, height: UIScreen.main.bounds.height/14))
        nameTF.backgroundColor = UIColor.white
        nameTF.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.width/21.6)
        self.contentView.addSubview(nameTF)
        
        mobileLabel = UILabel(frame: CGRect(x: 0, y: 5 + UIScreen.main.bounds.height/14 + 1 , width: UIScreen.main.bounds.width/4, height: UIScreen.main.bounds.height/14))
        mobileLabel.text = "Phone : "
        mobileLabel.textAlignment = .right
        mobileLabel.backgroundColor = UIColor.white
        mobileLabel.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.width/21.6)
        self.contentView.addSubview(mobileLabel)
        
        mobileTF = UITextField(frame: CGRect(x: UIScreen.main.bounds.width/4, y: 5 + UIScreen.main.bounds.height/14 + 1 , width: 3*UIScreen.main.bounds.width/4, height: UIScreen.main.bounds.height/14))
        mobileTF.backgroundColor = UIColor.white
        mobileTF.keyboardType = .phonePad
        nameTF.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.width/21.6)
        self.contentView.addSubview(mobileTF)
        
        addressLabel = UILabel(frame: CGRect(x: 0, y: 5 + 2*UIScreen.main.bounds.height/14 + 2 , width: UIScreen.main.bounds.width/4, height: UIScreen.main.bounds.height/14))
        addressLabel.text = "Address : "
        addressLabel.textAlignment = .justified
        addressLabel.backgroundColor = UIColor.white
        addressLabel.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.width/21.6)
        self.contentView.addSubview(addressLabel)
        
        addressTV = UITextView(frame: CGRect(x: UIScreen.main.bounds.width/4, y: 5 + 2*UIScreen.main.bounds.height/14 + 2, width: 3*UIScreen.main.bounds.width/4, height: 4*UIScreen.main.bounds.height/14))
        addressTV.backgroundColor = UIColor.white
        addressTV.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.width/27)
        self.contentView.addSubview(addressTV)
        
        proceedButton = UIButton(frame: CGRect(x: 10, y: addressLabel.frame.origin.y + addressTV.bounds.height + 5, width: UIScreen.main.bounds.width - 10, height: UIScreen.main.bounds.height/14))
        proceedButton.setTitle("GIFT IT !!!", for: .normal)
        proceedButton.backgroundColor = UIColor.blue
        proceedButton.setTitleColor(UIColor.white, for: .normal)
        proceedButton.titleLabel?.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.width/21.6)
        self.contentView.addSubview(proceedButton)
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
