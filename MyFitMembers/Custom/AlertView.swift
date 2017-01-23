//
//  CustomViews.swift
//  GoHobo
//
//  Created by CBL24pc on 4/9/16.
//  Copyright © 2016 GCode. All rights reserved.
//

import UIKit

class AlertView: NSObject{
    
    static func callAlertView(title:String,msg: String, btnMsg: String, vc: UIViewController){
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: btnMsg, style: UIAlertActionStyle.Default,handler: nil))
        vc.presentViewController(alertController, animated: true, completion: nil)
    }
}
