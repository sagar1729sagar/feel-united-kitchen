//
//  CartItems.swift
//  UNITED KITCHEN
//
//  Created by VIDYA SAGAR on 27/04/17.
//  Copyright © 2017 SSappS. All rights reserved.
//

import UIKit

class CartItems: UITableViewCell {
    
    var itemImage = UIImageView()
    var priceLabel = UILabel()
    var addButton = UIButton()
    var quantityLabel = UILabel()
    var subButton = UIButton()
    var nameLabel = UILabel()
  //  var typeView = UIImageView()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let rowHeight = UIScreen.main.bounds.height/10 + 20
        
        
        itemImage = UIImageView(frame: CGRect(x: 10, y: 10, width: UIScreen.main.bounds.height/10, height: UIScreen.main.bounds.height/10))
        self.contentView.addSubview(itemImage)
        
        priceLabel = UILabel(frame: CGRect(x: UIScreen.main.bounds.width - UIScreen.main.bounds.width/4, y: rowHeight/2, width: UIScreen.main.bounds.width/4, height: rowHeight/2))
        priceLabel.textAlignment = .center
        priceLabel.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.width/16.2)
        self.contentView.addSubview(priceLabel)
        print(UIScreen.main.bounds.width/20)
        
        nameLabel = UILabel(frame: CGRect(x: itemImage.frame.origin.x + itemImage.bounds.width + 10, y: 0, width: UIScreen.main.bounds.width - itemImage.bounds.width - 10, height: rowHeight/2))
        nameLabel.textAlignment = .left
        nameLabel.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.width/16.2)
        self.contentView.addSubview(nameLabel)
        
        addButton = UIButton(frame: CGRect(x: 3*UIScreen.main.bounds.width/4 - rowHeight/2 - UIScreen.main.bounds.width/26 - 10, y: (rowHeight/2) , width: rowHeight/2 - 12.5, height: rowHeight/2 - 12.5))
        addButton.layer.cornerRadius = 0.5 * addButton.bounds.width
        addButton.clipsToBounds = true
        let btn_image = UIImage(named: "add.png")
        addButton.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        addButton.setImage(btn_image, for: .normal)
        self.contentView.addSubview(addButton)
        
        quantityLabel = UILabel(frame: CGRect(x: addButton.frame.origin.x - 3*UIScreen.main.bounds.width/16.2, y: (rowHeight/2) , width: 3*UIScreen.main.bounds.width/16.2, height: rowHeight/2 - 10))
        quantityLabel.textColor = UIColor.black
        quantityLabel.textAlignment = .center
        quantityLabel.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.width/16.2)
        self.contentView.addSubview(quantityLabel)
        
        subButton = UIButton(frame: CGRect(x: quantityLabel.frame.origin.x - (rowHeight/2) - 12.5, y: (rowHeight/2) , width: rowHeight/2 - 12.5, height: rowHeight/2 - 12.5))
        subButton.layer.cornerRadius = 0.5 * subButton.bounds.width
        subButton.clipsToBounds = true
        let sbtn_image = UIImage(named: "sub.png")
        subButton.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        subButton.setImage(sbtn_image, for: .normal)
        self.contentView.addSubview(subButton)
        
    
        
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func prepareForReuse() {
        itemImage.image = nil
        nameLabel.text = ""
    }

}
