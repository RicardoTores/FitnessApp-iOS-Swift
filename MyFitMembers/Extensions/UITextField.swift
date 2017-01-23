//
//  UITextField.swift
//  MyFitMembers
//
//  Created by cbl24 on 9/22/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit

import UIKit

extension UITextField {
        
    @IBInspectable var padding: CGFloat {
        get {
            return self.padding
        }
        set {
            leftView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: self.frame.size.height))
            leftViewMode = .Always
        }
    }
    
}

extension UITextView {
    
    @IBInspectable var padding: CGFloat {
        get {
            return self.padding
        }
        set {
            textContainerInset = UIEdgeInsetsMake(newValue, newValue, 0, 0)
            textAlignment = .Left
        }
    }
    
}

extension UIButton{
    @IBInspectable var shadowRadius: CGFloat  {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
            
        }
    }
    
    @IBInspectable var shadowOffset: CGFloat  {
        get {
            return self.shadowOffset
        }
        set {
            layer.shadowOffset = CGSize(width: 0.0, height: newValue)
        }
    }
    
    @IBInspectable var shadowColor: UIColor?  {
        get {
            return UIColor(CGColor: layer.borderColor!)
        }
        set {
            layer.shadowColor = newValue?.CGColor
        }
    }
    
    @IBInspectable var shadowOpacity: Float?  {
        get {
            return self.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue!
        }
    }
    
    @IBInspectable var masksToBounds: Bool?{
        get {
            return self.masksToBounds
        }
        set {
            layer.masksToBounds = newValue!
        }
    }
}
