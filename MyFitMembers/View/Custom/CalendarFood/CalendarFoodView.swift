//
//  CalendarFoodView.swift
//  MyFitMembers
//
//  Created by cbl24 on 10/13/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit

class CalendarFoodView: UIView {
    
    //MARK::- OUTLETS
    
    
    //MARK::- VARIABLES
    @IBOutlet weak var labelBreakfast: UILabel!
    
    @IBOutlet weak var labelLunch: UILabel!
    
    @IBOutlet weak var labelDinner: UILabel!
    
    @IBOutlet weak var labelMorningSnacks: UILabel!
    
    @IBOutlet weak var labelEveningSnacks: UILabel!
    
    
    //MARK::- Functions
    func loadViewFromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "CalendarFoodView", bundle: bundle)
        guard let view = nib.instantiateWithOwner(self, options: nil)[0] as? UIView else {return UIView()}
        return view
    }
    
    func xibSetup() {
        let view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        addSubview(view)
    }
    
    //MARK::- Ovveride Functions
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
        hideAllLabels()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        xibSetup()
        hideAllLabels()
    }
    
    func hideAllLabels(){
        labelBreakfast.hidden = true
        labelLunch.hidden = true
        labelDinner.hidden = true
        labelMorningSnacks.hidden = true
        labelEveningSnacks.hidden = true
    }
    
    func updateColor(red: Bool){
        if red{
            labelBreakfast.backgroundColor = Colorss.DarkRed.toHex()
            labelLunch.backgroundColor = Colorss.DarkRed.toHex()
            labelDinner.backgroundColor = Colorss.DarkRed.toHex()
            labelMorningSnacks.backgroundColor = Colorss.DarkRed.toHex()
            labelEveningSnacks.backgroundColor = Colorss.DarkRed.toHex()
        }else{
            labelBreakfast.backgroundColor = Colorss.dotBlueColor.toHex()
            labelLunch.backgroundColor = Colorss.dotBlueColor.toHex()
            labelDinner.backgroundColor = Colorss.dotBlueColor.toHex()
            labelMorningSnacks.backgroundColor = Colorss.dotBlueColor.toHex()
            labelEveningSnacks.backgroundColor = Colorss.dotBlueColor.toHex()

        }
        
    }
    
    
    //MARK::- Actions
    
    
}
