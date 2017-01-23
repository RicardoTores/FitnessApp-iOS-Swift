//
//  ClientPersonalInfo.swift
//  MyFitMembers
//
//  Created by cbl24 on 10/26/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit

class ClientPersonalInfo: NSObject , JSONDecodable {
    
    var name : String?
    var address : String?
    var phoneNumber : String?
    var age : String?
    var emailAddress: String?
    var dateRegistered: String?
    var lastLogIn: String?
    var firstName : String?
    var lastName: String?
    var addressLine1: String?
    var addressLine2: String?
    var userImageJSON: OptionalSwiftJSONParameters?
    var userImage: UserImage?
    var pinCode:Int?
    var city:String?
    var state:String?
    
    required init(withAttributes attributes: OptionalSwiftJSONParameters) {
        super.init()
        self.firstName = .firstName => attributes
        self.lastName = .lastName => attributes
        self.age = .age => attributes
        self.name = (self.firstName?.uppercaseFirst ?? "") + " " + (self.lastName?.uppercaseFirst ?? "" )
        self.addressLine1 = .address_line1 => attributes
        self.addressLine2 = .address_line2 => attributes
        self.address = self.addressLine1 ?? ""
        self.phoneNumber = .phoneNo => attributes
        self.emailAddress = .email => attributes
        self.dateRegistered = .registrationDate => attributes
        self.lastLogIn = .lastLogin => attributes
        self.pinCode = .pincode =- attributes
        self.state = .state => attributes
        self.city = .city => attributes
        self.userImageJSON = .profilePic =&* attributes
        self.userImage = UserImage(withAttributes: self.userImageJSON ?? [:])
    }
    
    override init() {
        super.init()
    }
    
}
