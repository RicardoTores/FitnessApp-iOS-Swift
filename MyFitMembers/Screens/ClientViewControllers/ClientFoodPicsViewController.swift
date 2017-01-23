//
//  FoodPicsViewController.swift
//  MyFitMembers
//
//  Created by cbl24 on 10/10/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Fusuma

var fromEnlargedScreen = false

class ClientFoodPicsViewController: UIViewController ,  CalendarViewDelegate, IndicatorInfoProvider , DelegateAddFoodPicViewFoodSelected , DelegateSelectedPicView{
    
    //MARK::- OUTLETS
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var viewCalendar: UIView!
    
    //MARK::- VARIABLES
    var dataSourceTableView: DataSourceTableView?
    var item:[AnyObject]?
    let calendarView = CalendarView.instance(NSDate(), selectedDate: NSDate())
    var addFoodPicView: AddFoodPicView?
    var boolPlusPressed = false
    var selectedPicView: SelectedPicView?
    var calendarFoodView: CalendarFoodView?
    var foodPicSelected = ""
    
    //MARK::- OVERRIDE FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        instantiateControllers()
        calendarFoodView = CalendarFoodView(frame: self.view.frame)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        if fromEnlargedScreen{
            fromEnlargedScreen = false
        }else{
            fromEnlargedScreen = false
            guard let mnth = calendarView.baseDate?.month else {return}
            getMonthImages(mnth , moved: false)
            isSelfie = false
            setUpSideBar(false,allowRighSwipe: false)
            callSelfieDidSelectBlock(calendarView)
        }
        allowRev = false
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if boolPlusPressed{
            removeAnimate(addFoodPicView ?? UIView())
        }else{
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    //MARK::- FUNCTIONS
    
    func calendarLoad(selectedDate: NSDate , moved: Bool){
        calendarView.delegate = self
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        viewCalendar.addSubview(calendarView)
        if moved{
            
        }else{
            calendarView.selectedDate = selectedDate
        }
        callSelfieDidSelectBlock(calendarView)
        viewCalendar.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[calendarView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["calendarView": calendarView]))
        viewCalendar.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[calendarView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["calendarView": calendarView]))
    }
    
    func instantiateControllers(){
        addFoodPicView = AddFoodPicView(frame: self.view.frame)
        addFoodPicView?.delegate = self
        selectedPicView = SelectedPicView(frame: self.view.frame)
        selectedPicView?.delegate = self
    }
    
    func configureTableView(itemVal:[AnyObject]){
        dataSourceTableView = DataSourceTableView(tableView: tableView, cell: CellIdentifiers.ClientsFoodPicTableViewCell.rawValue , item: itemVal, configureCellBlock: { [weak self] (cell, item, indexPath) in
            guard let cell = cell as? ClientsFoodPicTableViewCell else {return}
            guard let foodPicArray = itemVal as? [FoodPics] else {return}
            cell.setData(foodPicArray[indexPath.row])
            }, configureDidSelect: { [unowned self] (indexPath) in
                let vc = StoryboardScene.Main.instantiateEnlargedPicViewController()
                guard let foodPicArray = itemVal as? [FoodPics] else {return}
                let foodData = foodPicArray[indexPath.row]
                guard let image  = foodData.userImage?.userOriginalImage else {return}
                let imgUrl = ApiCollection.apiImageBaseUrl + image
                print(imgUrl)
                vc.fromSelfie = false
                vc.imageProd = imgUrl
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
        return IndicatorInfo(title: "FoodPics")
    }
    
    func callFusumaImagePicker(item:String){
       
        CameraGalleryPickerBlock.sharedInstance.pickerImage(type: item, presentInVc: self, pickedListner: {
            [weak self]
            (image,imageUrl) -> () in
            self?.addFoodPicView?.removeFromSuperview()
            self?.sendFoodPic(image)
            }, canceledListner: { [weak self] in
                self?.addFoodPicView?.removeFromSuperview()
            } , allowEditting:true)
        
    }
    
    //MARK::- DELEGATES
    
    func delegateAddFoodPicViewFoodSelected(foodPic:String){
        print(foodPic)
        foodPicSelected = foodPic
        let alertcontroller =   UIAlertController.showActionSheetController(title: "Choose your action", buttons: ["Camera" , "Photo Library"], success: { [weak self]
            (state) -> () in
            self?.callFusumaImagePicker(state)
            })
        presentViewController(alertcontroller, animated: true, completion: nil)
        
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
    
    func btnPressed(){
        guard let mnth = calendarView.baseDate?.month else {return}
        getMonthImages(mnth , moved: true)
    }
    
    func callSelfieDidSelectBlock(calendarView : CalendarView?){}
    
    //MARK::- ACTIONS
    
    @IBAction func btnActionBack(sender: UIButton) {
        popVC()
    }
    
    @IBAction func btnActionAddSelfie(sender: UIButton) {
        boolPlusPressed = true
        self.view.addSubview(addFoodPicView ?? UIView())
        showAnimate(addFoodPicView ?? UIView())
    }
    
}

extension ClientFoodPicsViewController : FusumaDelegate{
    //MARK::- Fusuma delegates
    
    func fusumaImageSelected(image: UIImage) {
        addFoodPicView?.removeFromSuperview()
        sendFoodPic(image)
    }
    
    // Return the image but called after is dismissed.
    func fusumaDismissedWithImage(image: UIImage) {
        print("Called just after FusumaViewController is dismissed.")
    }
    
    // When camera roll is not authorized, this method is called.
    func fusumaCameraRollUnauthorized() {
        print("Camera roll unauthorized")
    }
    
    func fusumaVideoCompleted(withFileURL fileURL: NSURL) {
    }
    
    //MARK::- Selected Image Or Reject Image
    
    func delegateSelectedPicViewAccept(image: UIImage){
        removeAnimate(selectedPicView ?? UIView())
    }
    
    func delegateSelectedPicViewReject(){
        removeAnimate(selectedPicView ?? UIView())
    }
}




extension ClientFoodPicsViewController{
    
    //MARK::- API
    
    func sendFoodPic(image:UIImage){
        let dictForBackEnd = API.ApiCreateDictionary.AddFoodPicByClient(picType: foodPicSelected).formatParameters()
        print(dictForBackEnd)
        ApiDetector.getDataOfURL(ApiCollection.apiClientAddFoodPic, dictForBackend: dictForBackEnd, failure: { (data) in
            print(data)
            }, success: { [weak self] (data) in
                print(data)
                guard let mnth = self?.calendarView.baseDate?.month else {return}
                self?.getMonthImages(mnth , moved: false)
            }, method: .PostWithImage, viewControl: self, pic: image, placeHolderImageName: "image" , headers: [:] , showLoader: true, loaderColor: Colorss.DarkRed.toHex())
    }
    
    func getMonthImages(mnth:Int , moved: Bool){
        
        let dictForBackEnd = API.ApiCreateDictionary.ClientMonthlyFoodPics(month: mnth.toString).formatParameters()
        print(dictForBackEnd)
        
        ApiDetector.getDataOfURL(ApiCollection.apiMonthlyClientFoodPics, dictForBackend: dictForBackEnd, failure: { (data) in
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
                print(self?.item)
                
                self?.calendarLoad(NSDate() , moved: moved)
                self?.configureTableView(filteredFoodPic)
            }, method: .POST, viewControl: self, pic: UIImage(), placeHolderImageName: "", headers: [:] , showLoader: true, loaderColor: Colorss.DarkRed.toHex())
        
    }
}