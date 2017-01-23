//
//  Colors.swift
//  MyFitMembers
//
//  Created by cbl24 on 9/22/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit

enum Colorss {
    case LightRed
    case DarkRed
    case GreyColor
    case CalendarGreyColor
    case PagerBlackShade
    case lineChartBackgroundColor
    case dotBlueColor
    case LinChartGreyColor
    case StateGreyColor
    
    func toHex() -> UIColor {
        switch self {
        case .LightRed:
            return hexStringToUIColor("#FA8E98")
        case .DarkRed:
            return hexStringToUIColor("#EC2A3C")
            
        case .GreyColor:
            return hexStringToUIColor("#D9D9D9")
            
        case .CalendarGreyColor:
            return hexStringToUIColor("#4A4A4A")
            
        case .PagerBlackShade:
            return hexStringToUIColor("#4A4A4A")
            
        case .lineChartBackgroundColor:
            return hexStringToUIColor("#F2F2F2")
            
        case .dotBlueColor:
            return hexStringToUIColor("#00AAFB")
            
        case .LinChartGreyColor:
            return hexStringToUIColor("#DBDBDB")
            
        case .StateGreyColor:
            return hexStringToUIColor("#232628")
            
            
        }
    }
    func toHex(mark : String) -> UIColor {
        switch self {
        case .LightRed:
            return hexStringToUIColor("#FA8E98")
        case .DarkRed:
            return hexStringToUIColor("#EC2A3C")
            
        case .GreyColor:
            return hexStringToUIColor("#D9D9D9")
            
        case .CalendarGreyColor:
            return hexStringToUIColor("#4A4A4A")
            
        case .PagerBlackShade:
            return hexStringToUIColor("#4A4A4A")
            
        case .lineChartBackgroundColor:
            return hexStringToUIColor("#F2F2F2")
            
        case .dotBlueColor:
            return hexStringToUIColor("#00AAFB")
            
        case .LinChartGreyColor:
            return hexStringToUIColor("#DBDBDB")
            
        case .StateGreyColor:
            return hexStringToUIColor("#232628")
            
            
        }
    }
}

func hexStringToUIColor (hex:String) -> UIColor {
    var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet() as NSCharacterSet).uppercaseString
    
    if (cString.hasPrefix("#")) {
        cString = cString.substringFromIndex(cString.startIndex.advancedBy(1))
    }
    
    if ((cString.characters.count) != 6) {
        return UIColor.grayColor()
    }
    
    var rgbValue:UInt32 = 0
    NSScanner(string: cString).scanHexInt(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}