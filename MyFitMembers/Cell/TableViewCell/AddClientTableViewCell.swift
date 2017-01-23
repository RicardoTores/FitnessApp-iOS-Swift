//
//  AddClientTableViewCell.swift
//  MyFitMembers
//
//  Created by cbl24 on 9/24/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit

protocol DelegateAddClientTableViewCellTextFieldEditting {
    func delegateAddClientTableViewCellTextFieldEditting(showSkip: Bool)
}

class AddClientTableViewCell: UITableViewCell  , UITextFieldDelegate{

//MARK::- Outlets
    
    @IBOutlet weak var labelType: UILabel!
    
    @IBOutlet weak var textFieldValue: UITextField!
    @IBOutlet weak var labelMeasurement: UILabel!
    
    
//MARK::- VARIABLES
    
    var delegate: DelegateAddClientTableViewCellTextFieldEditting?
    
//MARK::- Ovveride functions
    override func awakeFromNib() {
        super.awakeFromNib()
        textFieldValue.delegate = self
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        textFieldValue.delegate = self
        // Configure the view for the selected state
    }
    
    
//MARK::- Functions
    
    func setValue(type:String,measurementType:String){
        labelType.text = type
        labelMeasurement.text = measurementType
    }
    
//MARK::- Actions
    
    @IBAction func btnActionTextField(sender: UITextField) {
        if sender.text?.characters.count > 0 && sender.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) != ""{
            delegate?.delegateAddClientTableViewCellTextFieldEditting(false)
        }else{
            delegate?.delegateAddClientTableViewCellTextFieldEditting(true)
        }
    }
    
    
    

}
