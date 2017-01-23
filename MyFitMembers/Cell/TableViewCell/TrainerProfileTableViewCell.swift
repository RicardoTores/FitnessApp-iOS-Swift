//
//  TrainerProfileTableViewCell.swift
//  MyFitMembers
//
//  Created by cbl24 on 10/6/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit

protocol DatePressed{
   func stateButtonPressed()
}
class TrainerProfileTableViewCell: UITableViewCell , UITextFieldDelegate {
    
    //MARK::- OUTLETS
    
    @IBOutlet weak var labelEmailId: UITextField!
    
    @IBOutlet weak var labelGymName: UITextField!
    @IBOutlet weak var labelAddress: UITextField!
    @IBOutlet weak var labelPhoneNumber: UITextField!{
        didSet{
            labelPhoneNumber.delegate = self
        }
    }
    
    @IBOutlet weak var textFieldZipCode: UITextField!
    @IBOutlet weak var btnState: UIButton!
    @IBOutlet weak var textFieldCity: UITextField!
    @IBOutlet weak var labelLastLogInDate: UILabel!
    @IBOutlet weak var labelRegisterationDate: UILabel!
    
    
    var delegate: DatePressed?
    
    
    //MARK::- OVERRIDE FUNCTIONS
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    //MARK::- Functions
    
    
    func setValue(data: AnyObject){
        guard let data = data as? TrainerProfile else {return}
        labelEmailId.text = data.emailAddress
        let gymName = data.gym?.name
        let names = gymName?.split(" ")
        var gym = ""
        
        if names?.count > 0{
            for name in names ?? []{
                gym = gym + " " + name.uppercaseFirst
            }
        }else{
            gym = data.gym?.name ?? ""
        }
        
        labelGymName.text = gym
        labelAddress.text = data.address
        labelPhoneNumber.text = data.phoneNumber
        
        let lastLoginDate = changeStringDateFormat(data.lastLogIn ?? "",fromFormat:"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'",toFormat:"MM/dd/yyyy")
        
        let registerationDate = changeStringDateFormat(data.dateRegistered ?? "",fromFormat:"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'",toFormat:"MM/dd/yyyy")
        
        labelLastLogInDate.text = lastLoginDate
        labelRegisterationDate.text = registerationDate
        textFieldCity.text = data.city
        textFieldZipCode.text = data.pinCode?.toString
        btnState.setTitle(data.state, forState: .Normal)
    }
    
    
    @IBAction func btnActionRegisteredDate(sender: UIButton) {
//        delegate?.datePressed()
    }
    
    @IBAction func btnActionState(sender: UIButton) {
        delegate?.stateButtonPressed()
    }
    
}

extension TrainerProfileTableViewCell{
    
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
