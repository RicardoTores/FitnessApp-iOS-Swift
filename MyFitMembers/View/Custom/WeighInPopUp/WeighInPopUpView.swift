//
//  WeighInPopUpView.swift
//  MyFitMembers
//
//  Created by cbl24 on 10/25/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit
protocol DelegateAddWeighIn {
    func delegateAddWeighIn(weigh:String , unit:String)
}
class WeighInPopUpView: UIView {
    
    //MARK::- Outlets
    
    @IBOutlet weak var labelUnit: UILabel!
    @IBOutlet weak var textFieldAddField: UITextField!
    
    @IBOutlet weak var viewCustomisation: UIView!
    @IBOutlet weak var constraintHeightViewCustomisation: NSLayoutConstraint!
    
    
    //MARK::- VARIABLES
    var delegate:DelegateAddWeighIn?
    
    //MARK::- Functions
    func loadViewFromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "WeighInPopUpView", bundle: bundle)
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
    
    @IBAction func btnActionSwitch(sender: UISwitch) {
        if sender.on{
            labelUnit.text = "kg"
        }else{
            labelUnit.text = "lbs"
        }
        
    }
    
    @IBAction func btnActionOk(sender: UIButton) {
        guard let fieldName = textFieldAddField.text , unit = labelUnit.text else {return}
        if fieldName.characters.count > 0 && fieldName.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) != ""{
            delegate?.delegateAddWeighIn(fieldName , unit: unit)
            self.removeFromSuperview()
        }else{
            self.removeFromSuperview()
        }
        
    }
    
}
