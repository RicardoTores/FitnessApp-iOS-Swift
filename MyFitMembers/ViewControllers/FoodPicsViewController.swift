//
//  FoodPicsViewController.swift
//  MyFitMembers
//
//  Created by cbl24 on 10/10/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit
import XLPagerTabStrip

var calendarFoodPicItem:[AnyObject] = []

class FoodPicsViewController: UIViewController ,  CalendarViewDelegate,IndicatorInfoProvider{
    
    //MARK::- OUTLETS
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var labelNoDataFound: UILabel!
    @IBOutlet weak var viewCalendar: UIView!
    
    //MARK::- VARIABLES
    var dataSourceTableView: DataSourceTableView?
    var item:[AnyObject]? = []
    let calendarView = CalendarView.instance(NSDate(), selectedDate: NSDate())
    
    var clientId: String?
    
    //MARK::- OVERRIDE FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        clientId = NSUserDefaults.standardUserDefaults().valueForKey("CurrentClientId") as? String
        guard let mnth = calendarView.baseDate?.month else {return}
        getMonthImages(mnth)
        isSelfie = false
        setUpSideBar(false,allowRighSwipe: false)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    //MARK::- FUNCTIONS
    
    func calendarLoad(){
        calendarView.delegate = self
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        viewCalendar.addSubview(calendarView)
        calendarView.selectedDate = NSDate()
        callSelfieDidSelectBlock(calendarView)
        
        
        viewCalendar.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[calendarView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["calendarView": calendarView]))
        viewCalendar.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[calendarView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["calendarView": calendarView]))
        
        
    }
    
    func configureTableView(itemVal:[AnyObject]){
        dataSourceTableView = DataSourceTableView(tableView: tableView, cell: CellIdentifiers.FoodPicsTableViewCell.rawValue , item: itemVal, configureCellBlock: { [weak self] (cell, item, indexPath) in
            guard let cell = cell as? FoodPicsTableViewCell else {return}
            guard let foodPicArray = self?.item as? [FoodPics] else {return}
            cell.setData(foodPicArray[indexPath.row])
            }, configureDidSelect: {  (indexPath) in
                let vc = StoryboardScene.Main.instantiateEnlargedPicViewController()
                guard let foodPicArray = itemVal as? [FoodPics] else {return}
                let foodData = foodPicArray[indexPath.row]
                guard let image  = foodData.userImage?.userOriginalImage else {return}
                let imgUrl = ApiCollection.apiImageBaseUrl + image
                print(imgUrl)
                vc.imageProd = imgUrl
                vc.fromSelfie = false
                self.pushVC(vc)
        })
        tableView.delegate = dataSourceTableView
        tableView.dataSource = dataSourceTableView
        dataSourceTableView?.headerHight = 0.0
        dataSourceTableView?.footerHeight = 0.0
        dataSourceTableView?.cellHeight = 60.0
        tableView.reloadData()
    }
    
    
    func indicatorInfoForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Food Pics")
    }
    
    
    //MARK::- DELEGATES
    
    func btnPressed(){
        guard let mnth = calendarView.baseDate?.month else {return}
        getMonthImages(mnth)
    }
    
    
    func didSelectDate(date: Date , cell:DayCollectionCell , collectionView: UICollectionView) {
        
        print("\(date.year)-\(date.month)-\(date.day)")
        guard let foodPicArray = calendarFoodPicItem as? [FoodPics] else {return}
        let filteredFoodPic = foodPicArray.filter({ (foodPic) -> Bool in
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            let selfieDate = dateFormatter.dateFromString( foodPic.foodPicDate ?? "") ?? NSDate()
            return selfieDate.day == date.day && selfieDate.year == date.year && selfieDate.month == date.month
        })
        self.item = filteredFoodPic
        configureTableView(self.item ?? [])
        
    }
    
    func callSelfieDidSelectBlock(calendarView : CalendarView?){}
    
    //MARK::- ACTIONS
    
    
}


extension String {
    
    func toDate(format : String?) -> NSDate?{
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = format ?? ""
        return dateFormatter.dateFromString(self)
    }
}


extension FoodPicsViewController{
    
    //MARK::- API
    
    func getMonthImages(mnth:Int){
        let clientId = NSUserDefaults.standardUserDefaults().valueForKey("CurrentClientId") as? String
        guard let clientId1 = clientId else {return}
        let dictForBackEnd = API.ApiCreateDictionary.MonthlyFoodPics(clientId: clientId1 , month: mnth.toString).formatParameters()
        ApiDetector.getDataOfURL(ApiCollection.apiMonthlyFoodPics, dictForBackend: dictForBackEnd, failure: { (data) in
            print(data)
            }, success: { [weak self] (data) in
                print(data)
                guard let foodPicData = data as? [FoodPics] else {return}
                calendarFoodPicItem = foodPicData
                guard let foodPicArray = foodPicData as? [FoodPics] else {return}
                let date = NSDate()
                let filteredFoodPic = foodPicArray.filter({ (foodPic) -> Bool in
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                    let selfieDate = dateFormatter.dateFromString( foodPic.foodPicDate ?? "") ?? NSDate()
                    return selfieDate.day == date.day && selfieDate.year == date.year && selfieDate.month == date.month
                })
                self?.item = filteredFoodPic
                self?.configureTableView(filteredFoodPic)
                self?.calendarLoad()
            }, method: .POST, viewControl: self, pic: UIImage(), placeHolderImageName: "", headers: [:] , showLoader: true, loaderColor: Colorss.DarkRed.toHex())
        
    }
    
    
}