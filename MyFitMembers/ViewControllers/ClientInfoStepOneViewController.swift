//
//  ClientInfoStepOneViewController.swift
//  MyFitMembers
//
//  Created by cbl24 on 9/29/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit
import RMMapper
import IQKeyboardManager

class ClientInfoStepOneViewController: UIViewController, UITextFieldDelegate , DelegateSelectedState , SetDate {
    
    //MARK::- OUTLETS
    
    @IBOutlet var textFieldInfo: [UITextField]!
    
    @IBOutlet weak var viewNextOverLay: UIView!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var textViewAddress: UITextField!
    
    @IBOutlet weak var btnDateOfBirth: UIButton!
    
    @IBOutlet weak var btnState: UIButton!
    
    @IBOutlet weak var textfieldPhoneNum: UITextField!
    //MARK::- VARIABLES
    
    var dateChooserView: DateChooser?
    var clientInfoStepTwoVc: ClientInfoStepTwoViewController?
    var validData = false
    var statePopPresent = false
    var statePopUp: CountryNameTableView?
    var country: [String]? = [
        "Alabama",
        "Alaska",
        "American Samoa",
        "Arizona",
        "Arkansas",
        "California",
        "Colorado",
        "Connecticut",
        "Delaware",
        "District Of Columbia",
        "Federated States Of Micronesia",
        "Florida",
        "Georgia",
        "Guam",
        "Hawaii",
        "Idaho",
        "Illinois",
        "Indiana",
        "Iowa",
        "Kansas",
        "Kentucky",
        "Louisiana",
        "Maine",
        "Marshall Islands",
        "Maryland",
        "Massachusetts",
        "Michigan",
        "Minnesota",
        "Mississippi",
        "Missouri",
        "Montana",
        "Nebraska",
        "Nevada",
        "New Hampshire",
        "New Jersey",
        "New Mexico",
        "New York",
        "North Carolina",
        "North Dakota",
        "Northern Mariana Islands",
        "Ohio",
        "Oklahoma",
        "Oregon",
        "Palau",
        "Pennsylvania",
        "Puerto Rico",
        "Rhode Island",
        "South Carolina",
        "South Dakota",
        "Tennessee",
        "Texas",
        "Utah",
        "Vermont",
        "Virgin Islands",
        "Virginia",
        "Washington",
        "West Virginia",
        "Wisconsin",
        "Wyoming"
    ]
    var boolAllowedNext = false
    var boolStateSelected = false
    var boolDateOfBirthSelected = false
    
    
    //MARK::- OVVERIDE FUNCTIONS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textfieldPhoneNum.delegate = self
        instantiateViewControllers()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        setUpSideBar(false,allowRighSwipe: false)
        setDelegate()
        btnNext.enabled = false
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if statePopPresent{
            statePopUp?.removeFromSuperview()
        }else{}
        removeAnimate(dateChooserView ?? UIView())
        self.view.endEditing(true)
    }
    
    override func viewDidDisappear(animated: Bool) {
        
    }
    
    
    //MARK::- FUNCTIONS
    
    func instantiateViewControllers(){
        dateChooserView = DateChooser(frame: CGRectMake(0, 0, DeviceDimensions.width, DeviceDimensions.height))
        dateChooserView?.delegate = self
    }
    
    
    func setDelegate(){
        for textField in textFieldInfo{
            textField.delegate = self
        }
    }
    
    
    //MARK::- DELEGATE
    
    func setDate(date:String){
        boolDateOfBirthSelected = true
        btnDateOfBirth.setTitleColor(UIColor.blackColor(), forState: .Normal)
        btnDateOfBirth.setTitle(date, forState: .Normal)
        if boolAllowedNext && boolStateSelected && boolDateOfBirthSelected{
            viewNextOverLay.hidden = true
            btnNext.enabled = true
           
        }else{
            viewNextOverLay.hidden = false
            btnNext.enabled = false
        }
    }
    
    
    //MARK::- ACTIONS
    
    @IBAction func btnActionNext(sender: UIButton) {
        sendUserInfo()
        NSUserDefaults.standardUserDefaults().setValue(nil, forKey: "ImageSelected")
    }
    
    @IBAction func btnActionBack(sender: UIButton) {
        boolPopSelf = false
        popVC()
    }
    
    @IBAction func btnActionDateOfBirth(sender: UIButton) {
        view.endEditing(true)
        showAnimate(dateChooserView ?? UIView() )
        self.view.addSubview(dateChooserView ?? UIView())
    }
    
    @IBAction func btnActionShowStates(sender: UIButton) {
        view.endEditing(true)
        let alertcontroller =   UIAlertController.showActionSheetController(title: "State", buttons: country ?? [""], success: { [unowned self]
            (state) -> () in
            self.btnState.setTitleColor(UIColor.blackColor(), forState: .Normal)
            self.btnState.setTitle(state, forState: .Normal)
            self.boolStateSelected = true
            if self.boolAllowedNext && self.boolStateSelected && self.boolDateOfBirthSelected{
                self.viewNextOverLay.hidden = true
                self.btnNext.enabled = true
            }else{
                self.viewNextOverLay.hidden = false
                self.btnNext.enabled = false
            }
            })
        presentViewController(alertcontroller, animated: true, completion: nil)
    }
}

extension ClientInfoStepOneViewController{
    
    //MARK::- GATHER DATA
    
    func sendUserInfo(){
        if btnState.titleLabel?.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) != "" && btnState.titleLabel?.text?.characters.count > 0 && textViewAddress.text?.characters.count > 0 &&  textViewAddress?.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) != ""{
            validData = true
        }else{
            AlertView.callAlertView("", msg: "Please fill in all the input fields.", btnMsg: "OK", vc: self)
            return
        }
        
        for textField in textFieldInfo{
            if textField.text?.characters.count > 0{
                if textField.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) != ""{
                    
                    validData = true
                }else{
                    validData = false
                    break
                }
            }else{
                validData = false
                break
            }
        }
        
        if User.isValidEmail(textFieldInfo[2].text ?? ""){
            
            if validData{
                
                let firstName = textFieldInfo[0].text?.lowercaseString
                let lastName = textFieldInfo[1].text?.uppercaseFirst
                let phoneNum = textfieldPhoneNum.text
                let email = textFieldInfo[2].text
                let city = textFieldInfo[3].text
                let zipCopde = textFieldInfo[4].text
                let address = textViewAddress.text
                let age = btnDateOfBirth.titleLabel?.text
                guard let state = btnState.titleLabel?.text else {return}
                
                
                let dictForBackEnd = API.ApiCreateDictionary.ClientInfo(firstName: firstName, lastName: lastName, info: "info", countryCode: "+1", phoneNumber: phoneNum, email: email, addressLine: address, city: city, state: state, pinCode: zipCopde , age: age).formatParameters()
                print(dictForBackEnd)
                NSUserDefaults.standardUserDefaults().rm_setCustomObject(dictForBackEnd, forKey: "AddNewUserInformation")
                
                let clientInfoStepTwoVc = StoryboardScene.Main.instantiateClientInfoStepTwoViewController()
                pushVC(clientInfoStepTwoVc)
            }else{
                AlertView.callAlertView("", msg: "Please fill in all the input fields.", btnMsg: "OK", vc: self)
                
            }
        }else{
            AlertView.callAlertView("", msg: "Enter valid email address", btnMsg: "OK", vc: self)
        }
    }
}

extension ClientInfoStepOneViewController{
    
    //MARK::- DelegateSelectedState
    
    func delegateSelectedState(state: String){
        btnState.setTitleColor(UIColor.blackColor(), forState: .Normal)
        removeAnimate(statePopUp ?? UIView())
        btnState.setTitle(state, forState: .Normal)
        
    }
    
    func textFieldDidBeginEditing(textField: UITextField){
        
       
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if textField == textfieldPhoneNum{
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
        }
        
        for textField in textFieldInfo{
            if textField.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) != "" && textField.text?.characters.count > 0{
                boolAllowedNext = true
            }else{
                boolAllowedNext = false
                break
            }
        }
        if boolAllowedNext && boolStateSelected && boolDateOfBirthSelected{
            viewNextOverLay.hidden = true
            btnNext.enabled = true
        }else{
            viewNextOverLay.hidden = false
            btnNext.enabled = false
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

