//
//  SelfieViewController.swift
//  MyFitMembers
//
//  Created by cbl24 on 10/12/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Fusuma
import AVFoundation

class ClientSelfiesViewController: UIViewController, CalendarViewDelegate , IndicatorInfoProvider , DelegateSelectedPicView{
    
    //MARK::- OUTLETS
    @IBOutlet var placeholderView: UIView!
    @IBOutlet weak var imagesSelfie: UIImageView!
    
    
    //MARK::- VARIABLES
    let calendarView = CalendarView.instance(NSDate(), selectedDate: NSDate())
    var boolPlusPressed = false
    var selectedPicView: SelectedPicView?
    var selfie: UIImage?
    var item : [AnyObject]? = []
    
    
    
    //MARK::- OVERRIDE FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedPicView = SelectedPicView(frame: self.view.frame)
    }
    
    override func viewWillAppear(animated: Bool) {
        isSelfie = true
        setUpSideBar(false,allowRighSwipe: false)
        guard let mnth = calendarView.baseDate?.month else {return}
        getMonthSelfies(mnth)
//        onTapImage()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if boolPlusPressed{
            removeAnimate(selectedPicView ?? UIView())
        }else{
            
        }
    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    //MARK::- DELEGATE
    func setUpCalendar(){
        calendarView.delegate = self
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        placeholderView.addSubview(calendarView)
        calendarView.selectedDate = NSDate()
        callSelfieDidSelectBlock(calendarView)
        placeholderView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[calendarView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["calendarView": calendarView]))
        placeholderView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[calendarView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["calendarView": calendarView]))
    }
    
    
    func btnPressed(){
        
    }
    
    
    func didSelectDate(date: Date , cell:DayCollectionCell , collectionView: UICollectionView) {
        print("\(date.year)-\(date.month)-\(date.day)")
        imagesSelfie.image = cell.imageSelfie.image
        
    }
    
    func indicatorInfoForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Selfies")
    }
    
    func callSelfieDidSelectBlock(calendarView : CalendarView?){
        
    }
    
    //MARK::- GESTURES
    
    func onTapImage(){
        imagesSelfie.addTapGesture { [unowned self] (tap) in
            let vc = StoryboardScene.Main.instantiateEnlargedPicViewController()
            vc.selfieImage = self.imagesSelfie.image
            vc.fromSelfie = true
            self.pushVC(vc)
        }
    }
    
    //MARK::- FUNCTIONS
    
    func getImage(type:String){
        
        CameraGalleryPickerBlock.sharedInstance.pickerImage(type: type, presentInVc: self, pickedListner: {
            [weak self]
            (image,imageUrl) -> () in
            self?.selfie = image
            self?.sendSelfie()
            
            }, canceledListner: {} , allowEditting: false)
    }
    
    func callFusumaImagePicker(){
        allowRev = true
        let controller = UIAlertController(title: title, message: "Choose action" , preferredStyle: UIAlertControllerStyle.ActionSheet)
        let buttons = ["Camera" , "Photo Library"]
        for btn in buttons{
            let action = UIAlertAction(title: btn, style: UIAlertActionStyle.Default, handler: { [unowned self] (action) -> Void in
                self.getImage(btn ?? "")
                })
            controller.addAction(action)
        }
        let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: "")
        , style: UIAlertActionStyle.Cancel) { (action) -> Void in
            
        }
        controller.addAction(cancel)
        presentViewController(controller, animated: true, completion: nil)
        //        CameraGalleryPickerBlock.sharedInstance.pickerImage(type: "Camera", presentInVc: self, pickedListner: {
        //            [weak self]
        //            (image,imageUrl) -> () in
        //            self?.selfie = image
        //            self?.sendSelfie()
        //
        //            }, canceledListner: {})
        
        
        //        let fusuma = FusumaViewController()
        //        fusuma.hasVideo = false
        //        fusuma.delegate = self
        //        fusuma.modeOrder = .CameraFirst
        //        fusumaCropImage = true
        //        self.presentViewController(fusuma, animated: true, completion: nil)
    }
    
    
    func instantiateControllers(){
        
        selectedPicView = SelectedPicView(frame: self.view.frame)
        selectedPicView?.delegate = self
    }
    
    //MARK::- ACTIONS
    
    @IBAction func btnActionBack(sender: UIButton) {
        popVC()
    }
    
    
    @IBAction func btnActionPlus(sender: UIButton) {
        boolPlusPressed = true
        callFusumaImagePicker()
    }
    
    
}

extension ClientSelfiesViewController : FusumaDelegate{
    //MARK::- Fusuma delegates
    
    func fusumaImageSelected(image: UIImage) {
        selfie = image
        sendSelfie()
        print("Image selected")
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
    
    //MARK::- DELEGATE PIC
    
    func delegateSelectedPicViewAccept(image: UIImage){
        
    }
    
    func delegateSelectedPicViewReject(){
        
    }
    
}


extension ClientSelfiesViewController{
    
    //MARK::- API
    
    func sendSelfie(){
        let dictForBackEnd = API.ApiCreateDictionary.ClientAddSelfie().formatParameters()
        
        guard let selfieImg = selfie  else {return}
        ApiDetector.getDataOfURL(ApiCollection.apiClientAddSelfie, dictForBackend: dictForBackEnd, failure: { (data) in
            print(data)
            }, success: { [unowned self] (data) in
                print(data)
                guard let mnth = self.calendarView.baseDate?.month else {return}
                self.getMonthSelfies(mnth)
                
            }, method: .PostWithImage, viewControl: self, pic: selfieImg, placeHolderImageName: "image", headers: [:] , showLoader: true, loaderColor: Colorss.DarkRed.toHex())
    }
    
    
    //MARK::- API
    
    func getMonthSelfies(mnth:Int){
        
        let dictForBackEnd = API.ApiCreateDictionary.ClientMonthlyFoodPics(month: mnth.toString).formatParameters()
        
        
        ApiDetector.getDataOfURL(ApiCollection.apiClientMonthlySelfie, dictForBackend: dictForBackEnd, failure: { (data) in
            print(data)
            }, success: { [weak self] (data) in
                guard let selfieData = data as? [Selfie] else {return}
                self?.item = selfieData
                selfiesPicItem = selfieData
                self?.setUpCalendar()
                
                let date = NSDate()
                let selfiePic = selfieData.filter({ (selfi) -> Bool in
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                    let selfieDate = dateFormatter.dateFromString(selfi.selfiePicDate ?? "") ?? NSDate()
                    return selfieDate.day == date.day && selfieDate.year == date.year && selfieDate.month == date.month
                })
                if selfiePic.count > 0{
                    guard let selfie1 = selfiePic[0].userImage?.userOriginalImage else {return}
                    guard let selfieUrl = NSURL(string: ApiCollection.apiImageBaseUrl + selfie1) else {return}
                    self?.imagesSelfie.yy_setImageWithURL(selfieUrl, options: .ProgressiveBlur)}else{}
            }, method: .POST, viewControl: self, pic: UIImage(), placeHolderImageName: "", headers: [:] , showLoader: true, loaderColor: Colorss.DarkRed.toHex())
        
    }
    
    
}
