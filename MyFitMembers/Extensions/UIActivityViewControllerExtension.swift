//
//  UIActivityViewControllerExtension.swift
//  Color_Scopes
//
//  Created by CBL24pc on 4/1/16.
//  Copyright © 2016 codebrew. All rights reserved.
//

import UIKit

extension UIActivityViewController{
    class func showActivityViewController(text text : String ,img :UIImage, viewController : UIViewController){
        let textToShare = text
        let image = img
        let objectsToShare = [textToShare,image]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        
        activityVC.excludedActivityTypes = [UIActivityTypeAirDrop, UIActivityTypeAddToReadingList]
        viewController.presentViewController(activityVC, animated: true, completion: nil)
        
    }
}

