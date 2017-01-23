//
//  NSDateExtension.swift
//  NeverMynd
//
//  Created by vivek on 03/09/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit


extension NSDate {
    
    func dateInMilliseconds() -> String {
         let date = String((NSDate().timeIntervalSince1970 * 1000))
        return date.componentsSeparatedByString(".").first ?? ""
    }
    
    
    
    func changeStringDateFormat(dateStr:String,fromFormat:String,toFormat:String) -> String {
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = fromFormat
        guard let date =  formatter.dateFromString(dateStr) else { return "" }
        formatter.dateFormat = toFormat
        return formatter.stringFromDate(date)

    }
    
    func changeFormatOnly(format:String , date:NSDate)->String{
        let formatter = NSDateFormatter()
        formatter.dateStyle = .FullStyle
        formatter.timeZone = NSTimeZone.localTimeZone()
        formatter.dateFormat = format
  
        let dateString = formatter.stringFromDate(date)
        return dateString
    }
    
    
}

func changeDateFormat(dateStr:NSDate,fromFormat:String,toFormat:String) -> String {
    
    let formatter = NSDateFormatter()
    formatter.dateFormat = fromFormat
    formatter.dateFormat = toFormat
    return formatter.stringFromDate(dateStr)
    
}

func changeStringDateFormat1(dateStr:String,fromFormat:String,toFormat:String) -> NSDate {
    
    let formatter = NSDateFormatter()
    formatter.dateFormat = fromFormat
    guard let date =  formatter.dateFromString(dateStr) else { return NSDate() }
    formatter.dateFormat = toFormat
    return date
    
}

func changeStringDateFormat(dateStr:String,fromFormat:String,toFormat:String) -> String {
    
    let formatter = NSDateFormatter()
    formatter.dateFormat = fromFormat
    guard let date =  formatter.dateFromString(dateStr) else { return "" }
    formatter.dateFormat = toFormat
    return formatter.stringFromDate(date)
    
}

func dateFromTimestamp(utcTimestamp:String?,format:String) -> String {
    
    let timeStamp = utcTimestamp?.toDouble()
    let date = NSDate(timeIntervalSince1970:(timeStamp ?? 0.0)/1000.0)
    let formatter = NSDateFormatter()
    formatter.dateStyle = .FullStyle
    formatter.timeZone = NSTimeZone.localTimeZone()
    formatter.dateFormat = format
    let dateString = formatter.stringFromDate(date)
    return dateString
}


extension NSDate {
    func toLocalTime() -> NSDate {
        let timeZone = NSTimeZone.localTimeZone()
        let seconds : NSTimeInterval = Double(timeZone.secondsFromGMTForDate(self))
        let localDate = NSDate(timeInterval: seconds, sinceDate: self)
        return localDate
    }
}