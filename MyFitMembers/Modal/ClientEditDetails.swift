//
//  ClientEditDetails.swift
//  MyFitMembers
//
//  Created by cbl24 on 30/11/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit

var boolDataIsValid = false
var createdDict: [String:AnyObject]?

class ClientEditDetails: NSObject {
    var firstName:String?
    var lastName:String?
    var phoneNumber:String?
    var countryCode:String?
    var address:String?
    var email:String?
    var pinCode: String?
    var state: String?
    var city: String?
    var elementArray:[String?] = []
    
    
    
    init(firstName:String? , lastName:String? ,phoneNumber:String? ,countryCode:String? , address:String? , email:String?, pinCode: String? , state: String? , city: String? ){
        self.firstName = firstName
        self.lastName = lastName
        self.phoneNumber = phoneNumber
        self.countryCode = countryCode
        self.address = address
        self.email = email
        self.pinCode = pinCode
        self.state = state
        self.city = city
        elementArray.append(firstName)
        elementArray.append(lastName)
        elementArray.append(phoneNumber)
        elementArray.append(countryCode)
        elementArray.append(address)
        elementArray.append(email)
        elementArray.append(pinCode)
        elementArray.append(state)
        elementArray.append(city)
        for element in elementArray{
            guard let trimmedString = element?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) else {
                boolDataIsValid = false
                break
                return}
            if !trimmedString.isBlank{
                boolDataIsValid = true
                createdDict = API.ApiCreateDictionary.EditDetails(firstName: self.firstName ?? "", lastName: self.lastName ?? "", phoneNumber: self.phoneNumber ?? "", countryCode: self.countryCode ?? "", address: self.address ?? "", email: self.email ?? "", pinCode: self.pinCode ?? "", state: self.state ?? "", city: self.city ?? "").formatParameters()
            }else{
                boolDataIsValid = false
                break
            }
        }
    }
    
    class func getValidationResult()->Bool{
        
        return boolDataIsValid
    }
}
