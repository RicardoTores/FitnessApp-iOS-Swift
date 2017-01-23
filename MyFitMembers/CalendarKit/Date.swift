//
//  Date.swift
//  CalendarLogic
//
//  Created by Lancy on 01/06/15.
//  Copyright (c) 2015 Lancy. All rights reserved.
//

import Foundation

class Date: CustomStringConvertible, Equatable {
    
    var day: Int
    var month: Int
    var year: Int
//    var breakFast = false
//    var dinner = false
//    var lunch = false
//    var noonSnacks = false
//    var eveningSnacks = false
    
    
    var isToday: Bool {
        let today = Date(date: NSDate())
        return (isEqual(today) == .OrderedSame)
    }
    
    func isEqual(date: Date) -> NSComparisonResult {
        let selfComposite = (year * 10000) + (month * 100) + day
        let otherComposite = (date.year * 10000) + (date.month * 100) + date.day
        
        if selfComposite < otherComposite {
            return .OrderedAscending
        } else if selfComposite == otherComposite {
            return .OrderedSame
        } else {
            return .OrderedDescending
        }
    }
    
    init(day: Int, month: Int, year: Int) {
        self.day = day
        self.month = month
        self.year = year
        
//        guard let arrayFoodPic = calendarFoodPicItem as? [FoodPics] else {return}
//        for foodPic in arrayFoodPic{
//            let strDate = foodPic.foodPicDate ?? ""
//            let dateFormatter = NSDateFormatter()
//            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
//            let foodDate = dateFormatter.dateFromString( strDate ) ?? NSDate()
//            
//            if year == foodDate.year && month == foodDate.month && day == foodDate.day{
//                guard let foodType = foodPic.foodType else {return}
//                switch(foodType){
//                case "BREAKFAST":
//                    self.breakFast = true
//                    
//                case "AFTERNOONSNACK":
//                    self.noonSnacks = true
//                    
//                case "LUNCH":
//                    self.lunch = true
//                    
//                case "EVENINGSNACK":
//                        self.eveningSnacks = true
//                    
//                case "DINNER":
//                    self.dinner = true
//                    
//                default:
//                    break
//                }
//            }else{}
//            
//            
//            
//        }
        
        
        
    }
    
    init(date: NSDate) {
        let part = date.monthDayAndYearComponents
        
        self.day = part.day
        self.month = part.month
        self.year = part.year
        
//        guard let arrayFoodPic = calendarFoodPicItem as? [FoodPics] else {return}
//        for foodPic in arrayFoodPic{
//            let strDate = foodPic.foodPicDate ?? ""
//            let dateFormatter = NSDateFormatter()
//            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
//            let foodDate = dateFormatter.dateFromString( strDate ) ?? NSDate()
//            
//            if year == foodDate.year && month == foodDate.month && day == foodDate.day{
//                guard let foodType = foodPic.foodType else {return}
//                switch(foodType){
//                case "BREAKFAST":
//                    self.breakFast = true
//                    
//                case "AFTERNOONSNACK":
//                    self.noonSnacks = true
//                    
//                case "LUNCH":
//                    self.lunch = true
//                    
//                case "EVENINGSNACK":
//                    self.eveningSnacks = true
//                    
//                case "DINNER":
//                    self.dinner = true
//                    
//                default:
//                    break
//                }
//            }else{}
//            
//        }

        
    }
    
    var nsdate: NSDate {
        return NSDate.date(day, month: month, year: year)
    }
    
    var description: String {
        return "\(day)-\(month)-\(year)"
    }
}

func ==(lhs: Date, rhs: Date) -> Bool {
    return ((lhs.day == rhs.day) && (lhs.month == rhs.month) && (lhs.year == rhs.year))
}
