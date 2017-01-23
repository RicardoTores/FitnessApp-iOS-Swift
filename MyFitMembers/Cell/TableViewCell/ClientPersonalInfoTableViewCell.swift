//
//  ClientPersonalInfoTableViewCell.swift
//  MyFitMembers
//
//  Created by cbl24 on 10/25/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit
protocol StatePressed {
    func stateButtonPressed()
    func dateClicked()
}


class ClientPersonalInfoTableViewCell: UITableViewCell , UITextFieldDelegate  {
    
    //MARK::- OUTLETS
    
    @IBOutlet weak var btnDate: UIButton!
    @IBOutlet weak var labelName: UITextField!
    @IBOutlet weak var labelAddress: UITextField!
    @IBOutlet weak var labelPhoneNumber: UITextField!{
        didSet{
            labelPhoneNumber.delegate = self
        }
    }
    
    @IBOutlet weak var textFieldPinCode: UITextField!
    @IBOutlet weak var labelEmail: UITextField!
    @IBOutlet weak var labelRegisterationDate: UILabel!
    @IBOutlet weak var labelLastLogin: UILabel!
    @IBOutlet weak var labelAge: UITextField!
    
    @IBOutlet weak var textFieldCity: UITextField!
    
    @IBOutlet weak var btnState: UIButton!
    
    
    //MARK::- VARIABLES
    
    var delegate:StatePressed?
    var dateChooserView: DateChooser?
    
    //MARK::- OVERRIDE FUNCTIONS
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    //MARK::- FUNCTIONS
    
    func setValue(profileData: ClientPersonalInfo){
        labelName.text = profileData.name
        labelAddress.text = profileData.address
        labelPhoneNumber.text = profileData.phoneNumber
        labelEmail.text = profileData.emailAddress
        let registerDate = changeStringDateFormat(profileData.dateRegistered ?? "",fromFormat:"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'",toFormat:"MM/dd/yyyy")
        labelRegisterationDate.text = registerDate
        let lognDate = changeStringDateFormat(profileData.lastLogIn ?? "",fromFormat:"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'",toFormat:"MM/dd/yyyy")
        labelLastLogin.text = lognDate
        labelAge.text = profileData.age
        textFieldCity.text = profileData.city
        textFieldPinCode.text = profileData.pinCode?.toString
        btnState.setTitle(profileData.state, forState: .Normal)
    }
    
    @IBAction func btnActionState(sender: UIButton) {
        delegate?.stateButtonPressed()
    }
    
    @IBAction func btnActionDate(sender: UIButton) {
        delegate?.dateClicked()
    }
    
}


extension ClientPersonalInfoTableViewCell{
    
//MARK::- DELEGATE
    
//MARK::- TEXTFIELD DELEGATE
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let length = Int(getLength(textField.text!))
        if length == 10 {
            if range.length == 0 {
                return false
            }
        }
        if length == 3 {
            let num = formatNumber(textField.text!)
            textField.text = "(\(num)) "
            if range.length > 0 {
                textField.text = "\(num.substringToIndex(num.startIndex.advancedBy(3)))"
            }
        }
        else if length == 6 {
            let num = formatNumber(textField.text!)
            textField.text = "(\(num.substringToIndex(num.startIndex.advancedBy(3)))) \(num.substringFromIndex(num.startIndex.advancedBy(3)))-"
            if range.length > 0 {
                textField.text = "(\(num.substringToIndex(num.startIndex.advancedBy(3)))) \(num.substringFromIndex(num.startIndex.advancedBy(3)))"
            }
        }
        
        return true
    }
    
    
    func formatNumber( mobileNumber: String) -> String {
        var mobileNumber = mobileNumber.stringByReplacingOccurrencesOfString("(", withString: "")
        mobileNumber = mobileNumber.stringByReplacingOccurrencesOfString(")", withString: "")
        mobileNumber = mobileNumber.stringByReplacingOccurrencesOfString(" ", withString: "")
        mobileNumber = mobileNumber.stringByReplacingOccurrencesOfString("-", withString: "")
        mobileNumber = mobileNumber.stringByReplacingOccurrencesOfString("+", withString: "")
        print("\(mobileNumber)")
        let length = mobileNumber.characters.count
        if length > 10 {
            mobileNumber = mobileNumber.substringFromIndex(mobileNumber.startIndex.advancedBy(length - 10))
            print("\(mobileNumber)")
        }
        return mobileNumber
    }
    
    func getLength(mobileNumber: String) -> Int {
        var mobileNumber = mobileNumber.stringByReplacingOccurrencesOfString("(", withString: "")
        mobileNumber = mobileNumber.stringByReplacingOccurrencesOfString(")", withString: "")
        mobileNumber = mobileNumber.stringByReplacingOccurrencesOfString(" ", withString: "")
        mobileNumber = mobileNumber.stringByReplacingOccurrencesOfString("-", withString: "")
        mobileNumber = mobileNumber.stringByReplacingOccurrencesOfString("+", withString: "")
        let length = Int(mobileNumber.length)
        return length
    }
    
}