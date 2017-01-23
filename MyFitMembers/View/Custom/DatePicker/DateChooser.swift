//
//  DateChooser.swift
//  MyFitMembers
//
//  Created by cbl24 on 29/11/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit

protocol SetDate {
    func setDate(date:String)
}


class DateChooser: UIView {
    
    //MARK::- Outlets
    
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    //MARK::- VARIABLES
    var delegate:SetDate?
    
    //MARK::- Functions
    func loadViewFromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "DateChooser", bundle: bundle)
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
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        xibSetup()
        
    }
    
    //MARK::- Actions
    
    @IBAction func btnActionDone(sender: UIButton) {
        let date = datePicker.date.changeFormatOnly("MM/dd/yyyy", date: datePicker.date)
        delegate?.setDate(date)
        removeAnimate(self)
    }
    
    @IBAction func btnActionDatePicker(sender: UIDatePicker) {
        let date = sender.date.changeFormatOnly("MM/dd/yyyy", date: sender.date)
        delegate?.setDate(date)
    }
    
}
