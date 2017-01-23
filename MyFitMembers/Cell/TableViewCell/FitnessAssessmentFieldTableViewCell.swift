//
//  FitnessAssessmentFieldTableViewCell.swift
//  MyFitMembers
//
//  Created by cbl24 on 9/29/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit

class FitnessAssessmentFieldTableViewCell: UITableViewCell {
    
//MARK::- Outlets
    
    @IBOutlet weak var labelType: UILabel!
    @IBOutlet weak var textFieldValue: UITextField!
    
    //MARK::- VARIABLES
var delegate: DelegateAddClientTableViewCellTextFieldEditting?
    
    
//MARK::- Ovveride functions
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    //MARK::- FUNCTIONS
    
    func setValue(type:String,measurementType:String){
        labelType.text = type
    }

    @IBAction func btnActionTextField(sender: UITextField) {
        if sender.text?.characters.count > 0 && sender.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) != ""{
            delegate?.delegateAddClientTableViewCellTextFieldEditting(false)
        }else{
            delegate?.delegateAddClientTableViewCellTextFieldEditting(true)
        }
    }
    
    
}
