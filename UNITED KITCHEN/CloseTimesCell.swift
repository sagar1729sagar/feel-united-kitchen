//
//  CloseTimesCell.swift
//  UNITED KITCHEN
//
//  Created by VIDYA SAGAR on 21/07/17.
//  Copyright © 2017 SSappS. All rights reserved.
//

import UIKit

class CloseTimesCell: UITableViewCell {
    
    var day = UILabel()
    var time = UITextField()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        day = UILabel(frame: CGRect(x: 10, y: 10, width: UIScreen.main.bounds.width/2 - 10, height: 40))
        day.textAlignment
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
