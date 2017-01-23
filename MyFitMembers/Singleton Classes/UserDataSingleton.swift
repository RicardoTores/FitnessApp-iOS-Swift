//
//  SDataSingleton.swift
//  Glam360
//
//  Created by cbl16 on 7/5/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit
import RMMapper

class UserDataSingleton {
        
        class var sharedInstance: UserDataSingleton {
            struct Static {
                static var instance: UserDataSingleton?
                static var token: dispatch_once_t = 0
            }
            
            dispatch_once(&Static.token) {
                Static.instance = UserDataSingleton()
            }
            
            return Static.instance!
    }
    
    
    var loggedInUser : User?{
        get{
            var user : User?
            if let data = NSUserDefaults.standardUserDefaults().rm_customObjectForKey("profile") as? User{
                user = data
            }
            return user
        }
        set{
            let defaults = NSUserDefaults.standardUserDefaults()
            if let value = newValue{
                defaults.rm_setCustomObject(value, forKey: "profile")
            }
            else{
                defaults.removeObjectForKey("profile")
            }
        }
    }
    var fitnessAssesment : FitnessAssesment?{
        get{
             return NSUserDefaults.standardUserDefaults().rm_customObjectForKey("CurrentCustomerFitnessAssesment") as? FitnessAssesment
        }
        set{
            let defaults = NSUserDefaults.standardUserDefaults()
            if let value = newValue{
                defaults.rm_setCustomObject(value, forKey: "CurrentCustomerFitnessAssesment")
            }
            else{
                defaults.removeObjectForKey("CurrentCustomerFitnessAssesment")
            }
        }
    }
    
    var fitnessAssesment1 : FitnessAssesment1?{
        get{
            return NSUserDefaults.standardUserDefaults().rm_customObjectForKey("CurrentCustomerFitnessAssesment1") as? FitnessAssesment1
        }
        set{
            let defaults = NSUserDefaults.standardUserDefaults()
            if let value = newValue{
                defaults.rm_setCustomObject(value, forKey: "CurrentCustomerFitnessAssesment1")
            }
            else{
                defaults.removeObjectForKey("CurrentCustomerFitnessAssesment1")
            }
        }
    }
    
    var pushDict: NSDictionary?

    
    

}