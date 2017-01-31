//
//  HotelTableViewCell.swift
//  HotelLister
//
//  Created by Nicholas Allio on 23/11/2016.
//  Copyright © 2016 Nicholas Allio. All rights reserved.
//

import UIKit
import QuartzCore

class HotelTableViewCell: UITableViewCell {

    @IBOutlet weak var nameHotelLabel: UILabel!
    @IBOutlet weak var addressHotelLabel: UILabel!
    @IBOutlet weak var ratingHotelLabel: UILabel!
    @IBOutlet weak var starRatingHotelLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //Rounded corners
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = false
        
        //Shadow
        self.layer.shadowColor = UIColor.blue.cgColor
        self.layer.shadowRadius = 2
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize.zero
    }
    
    override var frame: CGRect {
        get {
            return super.frame
        }
        set (newFrame) {
            super.frame = CGRect(x: newFrame.origin.x + 5, y: newFrame.origin.y + 5, width: newFrame.width - 10, height: newFrame.height - 10)
        }
    }
}
