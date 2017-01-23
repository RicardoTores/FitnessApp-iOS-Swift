//
//  DayCollectionCell.swift
//  Calendar
//
//  Created by Lancy on 02/06/15.
//  Copyright (c) 2015 Lancy. All rights reserved.
//

import UIKit

class DayCollectionCell: UICollectionViewCell {
    
    @IBOutlet var label: UILabel!
    @IBOutlet var markedView: UIView!{
        didSet{
            if isSelfie{
                markedView.backgroundColor = Colorss.DarkRed.toHex()
            }else{
                markedView.backgroundColor = UIColor.whiteColor()
            }
        }
    }
    @IBOutlet weak var constraintBottomLabel: NSLayoutConstraint!
    @IBOutlet weak var imageSelfie: UIImageView!{
        didSet{
            imageSelfie.layer.cornerRadius = imageSelfie.frame.width/2
        }
    }
    @IBOutlet weak var viewFoodInfo: UIView!
    
    @IBOutlet weak var labelBreakFast: UILabel!
    
    @IBOutlet weak var labelLunch: UILabel!
    @IBOutlet weak var labelDinner: UILabel!
    
    @IBOutlet weak var labelEveningSnacks: UILabel!
    @IBOutlet weak var labelNoonSnacks: UILabel!
    
    //MARK::- VARIABLES
    var date: Date? {
        didSet {
            if date != nil {
                label.text = "\(date!.day)"
            } else {
                label.text = ""
            }
        }
    }
    var disabled: Bool = false {
        didSet {
            if disabled {
                alpha = 0.0
            } else {
                alpha = 1.0
            }
        }
    }
    var mark: Bool = false {
        didSet {
            if mark {
                markedView?.hidden = false
                if isSelfie{
                    label.textColor = UIColor.whiteColor()
                }else{
                    label.textColor = Colorss.CalendarGreyColor.toHex()
                    labelLunch.backgroundColor = Colorss.DarkRed.toHex()
                    labelDinner.backgroundColor = Colorss.DarkRed.toHex()
                    labelBreakFast.backgroundColor = Colorss.DarkRed.toHex()
                    labelNoonSnacks.backgroundColor = Colorss.DarkRed.toHex()
                    labelEveningSnacks.backgroundColor = Colorss.DarkRed.toHex()
                }
            } else {
                if isSelfie{
                    markedView!.hidden = true
                    label.textColor = Colorss.CalendarGreyColor.toHex()
                }else{
                    markedView!.hidden = true
                    label.textColor = Colorss.CalendarGreyColor.toHex()
                    label.textColor = Colorss.CalendarGreyColor.toHex()
                    labelLunch.backgroundColor = Colorss.dotBlueColor.toHex()
                    labelDinner.backgroundColor = Colorss.dotBlueColor.toHex()
                    labelBreakFast.backgroundColor = Colorss.dotBlueColor.toHex()
                    labelNoonSnacks.backgroundColor = Colorss.dotBlueColor.toHex()
                    labelEveningSnacks.backgroundColor = Colorss.dotBlueColor.toHex()
                }
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
}
