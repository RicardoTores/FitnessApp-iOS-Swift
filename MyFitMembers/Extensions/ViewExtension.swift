//
//  View.swift
//  NeverMynd
//
//  Created by cbl24 on 7/7/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    

    @IBInspectable var borderWidth: CGFloat  {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
            
        }
    }
    
    
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(CGColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.CGColor
        }
    }
    
}

extension CALayer {
    var borderUIColor: UIColor {
        set {
            self.borderColor = newValue.CGColor
        }
        
        get {
            return UIColor(CGColor: self.borderColor!)
        }
    }
}



class AssignCornerRadius: UIView{
    
    func makeCircle(view: UIView)->UIView{
        view.layer.cornerRadius = view.frame.height/2
        return view
    }
    
}


extension NSBundle {
    
    class var applicationVersionNumber: String {
        if let version = NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as? String {
            return version
        }
        return "Version Number Not Available"
    }
    
    class var applicationBuildNumber: String {
        if let build = NSBundle.mainBundle().infoDictionary?["CFBundleVersion"] as? String {
            return build
        }
        return "Build Number Not Available"
    }
    
}

func removeAnimate(view:UIView){
    UIView.animateWithDuration(0.25, animations: {
        view.transform = CGAffineTransformMakeScale(1.3, 1.3)
        view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                view.removeFromSuperview()
            }
    })
}

func showAnimate(view:UIView){
    view.transform = CGAffineTransformMakeScale(1.3, 1.3)
    view.alpha = 0.0;
    UIView.animateWithDuration(0.25, animations: {
        view.alpha = 1.0
        view.transform = CGAffineTransformMakeScale(1.0, 1.0)
    })
}