//
//  AddFoodPicView.swift
//  MyFitMembers
//
//  Created by cbl24 on 10/19/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit

protocol DelegateAddFoodPicViewFoodSelected {
    func delegateAddFoodPicViewFoodSelected(foodPic:String)
}


class AddFoodPicView: UIView {
    
    
    //MARK::- VARIABLES
    
    var delegate: DelegateAddFoodPicViewFoodSelected?
    
    //MARK::- Functions
    func loadViewFromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "AddFoodPicView", bundle: bundle)
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
    
    @IBAction func btnActionBreakFast(sender: UIButton) {
        delegate?.delegateAddFoodPicViewFoodSelected("BREAKFAST")
    }
    
    @IBAction func btnActionLunch(sender: UIButton) {
        delegate?.delegateAddFoodPicViewFoodSelected("LUNCH")
        
    }
    
    @IBAction func btnActionDinner(sender: UIButton) {
        delegate?.delegateAddFoodPicViewFoodSelected("DINNER")
    }
    
    @IBAction func btnActionMorningSnacks(sender: UIButton) {
        delegate?.delegateAddFoodPicViewFoodSelected("AFTERNOONSNACK")
    }
    
    @IBAction func btnActionEveningSnacks(sender: UIButton) {
        delegate?.delegateAddFoodPicViewFoodSelected("EVENINGSNACK")
    }
    
    
    
}
