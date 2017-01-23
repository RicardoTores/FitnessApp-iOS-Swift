//
//  AddFitnessAssessmentFieldPopUp.swift
//  MyFitMembers
//
//  Created by cbl24 on 9/29/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit

protocol DelegateAddFitnessAssessmentField {
    func delegateAddFitnessAssessmentField(fieldName:String)
}

class AddFitnessAssessmentFieldPopUp: UIView {
    
    //MARK::- Outlets
    
    @IBOutlet weak var labelHeader: UILabel!
    @IBOutlet weak var textFieldAddField: UITextField!
    //MARK::- VARIABLES
    var delegate:DelegateAddClientMeasurementsField?
    
    //MARK::- Functions
    func loadViewFromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "AddFitnessAssessmentFieldPopUp", bundle: bundle)
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
    
    
    @IBAction func btnActionOk(sender: UIButton) {
        guard let fieldName = textFieldAddField.text else {return}
        
        if fieldName.characters.count > 0 && fieldName.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) != ""{
            delegate?.delegateAddClientMeasurementsField(textFieldAddField.text ?? "")
            self.removeFromSuperview()
        }else{
            return
        }
    }
    
}
