//
//  LoginSignUp.swift
//  Glam360
//
//  Created by cbl16 on 6/28/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit
import EZSwiftExtensions
import Foundation

extension User {
    
    class func validateLoginFields (email : String? , password : String?) -> Bool{
        
        
        guard let mailId = email where mailId.characters.count != 0 && User.isValidEmail(mailId) else{
            return false
        }
//        guard let pass = password  where pass.characters.count != 0 && User.isValidPassword(pass)  else{
//            return false
//        }
        return true
        
    }
    
   class func isValidEmail(testStr:String) -> Bool {
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", RegularExpression.EmailRegex)
        return emailTest.evaluateWithObject(testStr)
    }
    
    class func isValidPassword(testStr:String) -> Bool {
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", RegularExpression.PasswordRegex)
        return emailTest.evaluateWithObject(testStr)
    }
}

internal struct RegularExpression {
    
    static let EmailRegex = "[A-Z0-9a-z._%+-]{3,}+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
    
    static let PasswordRegex = "[A-Za-z0-9]{6,20}"
    
    static let PhoneRegex = "[0-9]{6,14}"
    
}

