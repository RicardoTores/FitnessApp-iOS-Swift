//
//  MonthCollectionCell.swift
//  Calendar
//
//  Created by Lancy on 02/06/15.
//  Copyright (c) 2015 Lancy. All rights reserved.
//

import UIKit

typealias CalendarCellForRow = (cell : AnyObject?,date : Date?,indexPath : NSIndexPath) -> ()

protocol MonthCollectionCellDelegate: class {
    func didSelect(date: Date , cell:DayCollectionCell , collectionView: UICollectionView)
}

class MonthCollectionCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet var collectionView: UICollectionView!
    weak var monthCellDelgate: MonthCollectionCellDelegate?
    
    var dates = [Date]()
    var previousMonthVisibleDatesCount = 0
    var currentMonthVisibleDatesCount = 0
    var nextMonthVisibleDatesCount = 0
    var calendarCellForRow : CalendarCellForRow?
    var logic: CalendarLogic? {
        didSet {
            populateDates()
            if collectionView != nil {
                collectionView.reloadData()
            }
        }
    }
    
    var selectedDate: Date? {
        didSet {
            if collectionView != nil {
                collectionView.reloadData()
            }
        }
    }
    
    func populateDates() {
        if logic != nil {
            dates = [Date]()
            
            dates += logic!.previousMonthVisibleDays!
            dates += logic!.currentMonthDays!
            dates += logic!.nextMonthVisibleDays!
            
            previousMonthVisibleDatesCount = logic!.previousMonthVisibleDays!.count
            currentMonthVisibleDatesCount = logic!.currentMonthDays!.count
            nextMonthVisibleDatesCount = logic!.nextMonthVisibleDays!.count
            
        } else {
            dates.removeAll(keepCapacity: false)
        }
        
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let nib = UINib(nibName: "DayCollectionCell", bundle: nil)
        self.collectionView.registerNib(nib, forCellWithReuseIdentifier: "DayCollectionCell")
        
        let headerNib = UINib(nibName: "WeekHeaderView", bundle: nil)
        self.collectionView.registerNib(headerNib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "WeekHeaderView")
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 7*6 = 42 :- 7 columns (7 days in a week) and 6 rows (max 6 weeks in a month)
        return 42
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("DayCollectionCell", forIndexPath: indexPath) as! DayCollectionCell
        let date = dates[indexPath.item]
        print(date)
        var bk = false
        var lnch = false
        var dnr = false
        var bks = false
        var dnrs = false
        
        
        cell.date = (indexPath.item < dates.count) ? date : nil
        cell.mark = (selectedDate == date)
        if !isSelfie{
            let arrayFoodPic = calendarFoodPicItem as? [FoodPics]
            for foodPic in arrayFoodPic ?? []{
                let strDate = foodPic.foodPicDate ?? ""
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                let foodDate = dateFormatter.dateFromString( strDate ) ?? NSDate()
                
                if date.day == foodDate.day && date.year == foodDate.year && date.month == foodDate.month{
                    cell.constraintBottomLabel.constant = 12
                    let foodType = foodPic.foodType ?? ""
                    if foodType == "Breakfast" {
                        bk = true
                        cell.labelBreakFast.hidden = false
                    }else if foodType == "Afternoon Snack" {
                        bks = true
                        cell.labelNoonSnacks.hidden = false
                    }else if foodType == "Lunch" {
                        lnch = true
                        cell.labelLunch.hidden = false
                    }else if foodType == "Evening Snack" {
                        dnrs = true
                        cell.labelEveningSnacks.hidden = false
                    }else if foodType == "Dinner" {
                        dnr = true
                        cell.labelDinner.hidden = false
                    }else {
                        
                        cell.labelBreakFast.hidden = true
                        cell.labelNoonSnacks.hidden = true
                        cell.labelLunch.hidden = true
                        cell.labelEveningSnacks.hidden = true
                        cell.labelDinner.hidden = true
                        cell.imageSelfie.hidden = true
                    }
                    
                }else{
                    
                    print(date.day)
                    print(foodDate.day)
                    print(date.year)
                    print(foodDate.year)
                    print(date.month)
                    print(foodDate.month)
                    
                    if bk{
                        
                        cell.labelBreakFast.hidden = false
                    }else{
                        cell.labelBreakFast.hidden = true
                    }
                    if bks{
                        cell.labelNoonSnacks.hidden = false
                    }else{
                        cell.labelNoonSnacks.hidden = true
                    }
                    if lnch{
                        cell.labelLunch.hidden = false
                    }else{
                        cell.labelLunch.hidden = true
                    }
                    if dnrs{
                        cell.labelEveningSnacks.hidden = false
                    }else{
                        cell.labelEveningSnacks.hidden = true
                    }
                    if dnr{
                        cell.labelDinner.hidden = false
                    }else{
                        cell.labelDinner.hidden = true
                    }
                    
                    if bk || lnch || dnr || bks || dnrs{
                        cell.constraintBottomLabel.constant = 12
                    }else{
                        cell.constraintBottomLabel.constant = 0
                    }
                    
                    cell.imageSelfie.hidden = true
                }
            }
            cell.imageSelfie.hidden = true
        }else{
            var selfiePresent = false
            let selfieCollection = selfiesPicItem as? [Selfie]
            for selfie in selfieCollection ?? []{
                let strDate = selfie.selfiePicDate ?? ""
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                let selfieDate = dateFormatter.dateFromString( strDate ) ?? NSDate()
                
                if date.day == selfieDate.day && date.year == selfieDate.year && date.month == selfieDate.month{
                    cell.imageSelfie.hidden = false
                    cell.constraintBottomLabel.constant = 0
                    guard let imagePath = selfie.userImage?.userOriginalImage else {return UICollectionViewCell() }
                    guard let imageUrl = NSURL(string: ApiCollection.apiImageBaseUrl + imagePath) else {return UICollectionViewCell() }
                    selfiePresent = true
                    cell.imageSelfie.yy_setImageWithURL(imageUrl, placeholder: UIImage(named: "ic_placeholder"))
                    
                }else{
                    if selfiePresent{
                        cell.constraintBottomLabel.constant = 0
                        cell.viewFoodInfo.hidden = false
                        cell.imageSelfie.hidden = false
                    }else{
                        cell.constraintBottomLabel.constant = 0
                        cell.viewFoodInfo.hidden = true
                        cell.imageSelfie.hidden = true
                    }
                    
                }
                
            }
        }
        
        cell.disabled = (indexPath.item < previousMonthVisibleDatesCount) ||
            (indexPath.item >= previousMonthVisibleDatesCount
                + currentMonthVisibleDatesCount)
        
        if let block = calendarCellForRow {
            block(cell : cell,date : date,indexPath : indexPath)
        }
        
        
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if monthCellDelgate != nil {
            guard let cell = collectionView.cellForItemAtIndexPath(indexPath) as? DayCollectionCell else {return}
            cell.mark = true
            
            monthCellDelgate!.didSelect(dates[indexPath.item] , cell: cell , collectionView: collectionView)
        }
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        return collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "WeekHeaderView", forIndexPath: indexPath)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(collectionView.frame.width/7.0, collectionView.frame.height/7.0)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSizeMake(collectionView.frame.width, collectionView.frame.height/7.0)
    }
    
    
    
}
