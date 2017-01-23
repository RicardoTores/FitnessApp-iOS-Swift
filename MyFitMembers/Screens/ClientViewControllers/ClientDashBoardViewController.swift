//
//  ClientDashBoardViewController.swift
//  MyFitMembers
//
//  Created by cbl24 on 10/18/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit
import IQKeyboardManager
import EZSwiftExtensions

class ClientDashBoardViewController: UIViewController , BannerRemoved  , InstantiateSameVc , InstantiateNewChart{
    
    //MARK::- OUTLETS
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var labelNumberOfUnreadMessages: UILabel!
    
    //MARK:- VARIABLES
    
    var collectionViewDataSource: DataSourceDashBoardCollectionView?
    var item : [AnyObject]?
    var foodPicsVc: ClientFoodPicsViewController?
    var weighInVc: ClientWeignInViewController?
    var fitnessAseessmentVc: ClientFitnessAssessmentsViewController?
    var measurementVc: ClientMeasurementViewController?
    var selfieVc: ClientSelfiesViewController?
    var lessonsVc: LessonCollectionViewController?
    var chatVc: ChatViewController?
    var broadCastMessage: String?
    var itemBroadCast: AnyObject?
    var nutritioResourceVc: NutritionAndResurcesViewController?
    
    
    //MARK::- OVERRIDE FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        checkPushFromKillState()
        
        instantiateViewControllers()
        configureCollectionView()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ClientDashBoardViewController.handlePush), name: "Push", object: nil)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        ez.runThisAfterDelay(seconds: 10) {
            let chk = NSUserDefaults.standardUserDefaults().valueForKey("DeviceTokenUpdated") as? Bool ?? false
            if chk{
                
            }else{
                self.updateDeviceToken()
            }
            
        }
        getBroadCastMessages()
        collaborateCellImages()
        setUpSideBar(true,allowRighSwipe: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    
    //MARK::- FUNCTIONS
    
    func calculateBanner(message: String)->CGFloat{
        let textView = UITextView()
        textView.frame = CGRect(x: 0, y: 0, w: ((self.collectionView?.bounds.size.width ?? 0 / 4) ?? 2) ?? 0, h: 50)
        textView.text = broadCastMessage
        var neededHeight = textView.contentSize.height
        print(neededHeight)
        if neededHeight < 50{
            neededHeight += 40
        }else{
            neededHeight += 100
        }
        print(neededHeight)
        var height = neededHeight
        if message == ""{
            height = 0.0
        }
        return height
    }
    
    func instantiateViewControllers(){
        foodPicsVc = StoryboardScene.ClientStoryboard.instantiateClientFoodPicsViewController()
        selfieVc = StoryboardScene.ClientStoryboard.instantiateClientSelfiesViewController()
        lessonsVc = StoryboardScene.Main.instantiateLessonCollectionViewController()
        lessonsVc?.ofClient = true
        nutritioResourceVc = StoryboardScene.Main.instantiateNutritionAndResurcesViewController()
    }
    
    func collaborateCellImages(){
        item = ["foodpics","weighin","fitness","ic_measure_dashboard","selfie","ic_lessons" , "ic_nutrition-1"]
    }
    
    func configureCollectionView(){
        collectionViewDataSource = DataSourceDashBoardCollectionView(collectionView: collectionView, configureCellBlock: { (cell, item, indexPath) in
            guard let cell = cell as? DashBoardCollectionViewCell else {return}
            guard let imgName = item?[indexPath.row] as? String else {return}
            cell.setImage(imgName)
            }, configureDidSelectBlock: { [weak self] (cell, item, indexPath) in
                self?.showScreen(indexPath.row)
            }, cellIdentifier: CellIdentifiers.DashBoardCollectionViewCell.rawValue)
        collectionView.delegate = collectionViewDataSource
        collectionView.dataSource = collectionViewDataSource
        collectionViewDataSource?.item = item ?? []
        let cellWidth = DeviceDimensions.width - 48
        collectionViewDataSource?.cellSize = CGSizeMake(cellWidth/2, cellWidth/2)
        collectionViewDataSource?.cellInterItemSpacing = 16.0
        collectionViewDataSource?.cellSpacing = 16.0
        collectionViewDataSource?.boolFromClientPager = false
        collectionViewDataSource?.message = broadCastMessage
        collectionViewDataSource?.bannerHeight = calculateBanner(broadCastMessage ?? "")
        collectionViewDataSource?.delegate = self
        collectionView.reloadData()
    }
    
    func getFitnessAssessment(){
        let dictForBackEnd = API.ApiCreateDictionary.ClientListing().formatParameters()
        ApiDetector.getDataOfURL(ApiCollection.apiWeeklyAssessmentOfClient, dictForBackend: dictForBackEnd, failure: { (data) in
            print(data)
            }, success: { [weak self] (data) in
                let fitnessAssessmentData = data as? FitnessAssesment
                UserDataSingleton.sharedInstance.fitnessAssesment = fitnessAssessmentData
                let fitnessAseessmentVc = StoryboardScene.ClientStoryboard.instantiateClientFitnessAssessmentsViewController()
                fitnessAseessmentVc.delegate = self
                self?.pushVC(fitnessAseessmentVc)
            }, method: .POST, viewControl: self, pic: UIImage(), placeHolderImageName: "", headers: [:] , showLoader: true , loaderColor: Colorss.DarkRed.toHex())
    }
    
    
    
    func getWeighIn(){
        let dictForBackEnd = API.ApiCreateDictionary.ClientListing().formatParameters()
        ApiDetector.getDataOfURL(ApiCollection.apiWeeklyWeighInsOfClient, dictForBackend: dictForBackEnd, failure: { (data) in
            print(data)
            }, success: { [weak self] (data) in
                guard let weighInData = data as? [WeighIn] else {return}
                var dateArray = [String]()
                var pointData = [CGFloat]()
                var unitArray = [String]()
                for values in weighInData{
                    let pt = values.weigh?.toInt()?.toCGFloat
                    let date = values.weighPicDate
                    pointData.append(pt ?? 0.0)
                    let time = changeStringDateFormat(date ?? "",fromFormat:"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'",toFormat:"MM/dd")
                    dateArray.append(time ?? "")
                    let unitVal = values.weighUnit ?? ""
                    unitArray.append(unitVal)
                }
                NSUserDefaults.standardUserDefaults().setValue(pointData, forKey: "GraphPointsClient")
                NSUserDefaults.standardUserDefaults().setValue(dateArray, forKey: "GraphDatesClient")
                NSUserDefaults.standardUserDefaults().setValue(unitArray, forKey: "GraphUnitsClient")
                let weighInVc = StoryboardScene.ClientStoryboard.instantiateClientWeignInViewController()
                self?.pushVC(weighInVc)
            }, method: .POST, viewControl: self, pic: UIImage(), placeHolderImageName: "", headers: [:] , showLoader: true, loaderColor: Colorss.DarkRed.toHex())
    }
    
    func getClientMeasurements(){
        let dictForBackEnd = API.ApiCreateDictionary.ClientListing().formatParameters()
        ApiDetector.getDataOfURL(ApiCollection.apiWeeklyMeasurementOfClient, dictForBackend: dictForBackEnd, failure: { (data) in
            print(data)
            }, success: { [weak self] (data) in
                let fitnessAssessmentData1 = data as? FitnessAssesment1
                UserDataSingleton.sharedInstance.fitnessAssesment1 = fitnessAssessmentData1
                let measurementVc = StoryboardScene.ClientStoryboard.instantiateClientMeasurementViewController()
                measurementVc.delegate = self
                self?.pushVC(measurementVc)
            }, method: .POST, viewControl: self, pic: UIImage(), placeHolderImageName: "", headers: [:] , showLoader: true, loaderColor: Colorss.DarkRed.toHex())
    }
    
    enum DashBoardElemets: Int{
        case foodPics = 0
        case WeighIn = 1
        case fitnessAssessment = 2
        case measurements = 3
        case selfie = 4
        case lessson = 5
        case nutrition = 6
    }
    
    func showScreen(item:Int){
        switch item {
        case DashBoardElemets.foodPics.rawValue:
            guard let foodPicsVc = foodPicsVc else {return}
            pushVC(foodPicsVc)
        case DashBoardElemets.WeighIn.rawValue:
            getWeighIn()
        case DashBoardElemets.fitnessAssessment.rawValue:
            getFitnessAssessment()
        case DashBoardElemets.measurements.rawValue:
            getClientMeasurements()
        case DashBoardElemets.selfie.rawValue:
            guard let selfieVc = selfieVc else {return}
            pushVC(selfieVc)
        case DashBoardElemets.lessson.rawValue:
            guard let lessonsVc = lessonsVc else {return}
            pushVC(lessonsVc)
        case DashBoardElemets.nutrition.rawValue:
            guard let nutritioResourceVc = nutritioResourceVc else {return}
            pushVC(nutritioResourceVc)
            
        default:
            break
        }
    }
    
    //MARK::- DELEGATE
    
    func instantiateNewChartForAssessment(){
        guard let navigationControllerStack = self.navigationController?.viewControllers else {return}
        for controller in navigationControllerStack{
            if controller is ClientFitnessAssessmentViewController{
                self.navigationController?.popViewControllerAnimated(false)
            }else if controller is ClientFitnessAssessmentsViewController{
                self.navigationController?.popViewControllerAnimated(false)
            }else{
                
            }
        }
        let fitnessAseessmentVc = StoryboardScene.ClientStoryboard.instantiateClientFitnessAssessmentsViewController()
        fitnessAseessmentVc.delegate = self
        self.navigationController?.pushViewController(fitnessAseessmentVc, animated: false)
    }
    
    func instantiateSameVc(){
        
        guard let navigationControllerStack = self.navigationController?.viewControllers else {return}
        for controller in navigationControllerStack{
            if controller is ClientAddMeasurementViewController{
                self.navigationController?.popViewControllerAnimated(false)
            }else if controller is ClientMeasurementViewController{
                self.navigationController?.popViewControllerAnimated(false)
            }else{
                
            }
        }
        let measurementVc = StoryboardScene.ClientStoryboard.instantiateClientMeasurementViewController()
        measurementVc.delegate = self
        self.navigationController?.pushViewController(measurementVc, animated: false)
        
        
        
    }
    
    //MARK::- ACTIONS
    
    @IBAction func btnActionSideMenu(sender: UIButton) {
        toggleSideMenuView()
    }
    
    @IBAction func btnActionChat(sender: UIButton) {
        chatVc = StoryboardScene.Main.instantiateChatViewController()
        guard let chatVc = chatVc else {return}
        chatVc.clientId = UserDataSingleton.sharedInstance.loggedInUser?.trainer
        print(chatVc.clientId)
        pushVC(chatVc)
    }
    
}

extension ClientDashBoardViewController{
    
    //MARK::- DATASOURCE DELEGATE
    func removeBanner(){
        removeBroadCast()
    }
    
    //MARK::- APIs
    func removeBroadCast(){
        
        guard let msg = itemBroadCast as? BroadCastMessage else {return}
        guard let msgId = msg.messageId else {return}
        let dictForBackEnd = API.ApiCreateDictionary.ReadBroadCast(messageId: msgId).formatParameters()
        ApiDetector.getDataOfURL(ApiCollection.apiClientRemoveBanner, dictForBackend: dictForBackEnd, failure: { (data) in
            
            }, success: { [unowned self] (data) in
                print(data)
                
            }, method: .POST, viewControl: self, pic: UIImage(), placeHolderImageName: "", headers: [:], showLoader: false, loaderColor: Colorss.DarkRed.toHex())
    }
    
    
    
    
    func getBroadCastMessages(){
        
        let dictForBackEnd = API.ApiCreateDictionary.BroadCastListing().formatParameters()
        
        ApiDetector.getDataOfURL(ApiCollection.apiClientGetBroadCastMessage, dictForBackend: dictForBackEnd, failure: { (data) in
            
            }, success: { [unowned self] (data) in
                print(data)
                guard let msg = data as? BroadCastMessage else {return}
                self.itemBroadCast = msg
                self.broadCastMessage = msg.message
                print(self.broadCastMessage)
                self.configureCollectionView()
                self.labelNumberOfUnreadMessages.text = unReadMessages.toString
            }, method: .POST, viewControl: self, pic: UIImage(), placeHolderImageName: "", headers: [:], showLoader: false, loaderColor: Colorss.DarkRed.toHex())
    }
    
    
    func updateDeviceToken(){
        guard let devToken =  deviceToken else {
            AlertView.callAlertView("", msg: "Please allow push notification service in settings", btnMsg: "OK", vc: self)
            return
        }
        
        let dictForBackEnd = API.ApiCreateDictionary.UpdateDeviceToken(deviceToken: devToken).formatParameters()
        ApiDetector.getDataOfURL(ApiCollection.apiClientUpdateDeviceToken, dictForBackend: dictForBackEnd, failure: { (data) in
            self.updateDeviceToken()
            }, success: { (data) in
                print(data)
                NSUserDefaults.standardUserDefaults().setValue(true, forKey: "DeviceTokenUpdated")
            }, method: .POST, viewControl: self, pic: UIImage(), placeHolderImageName: "", headers: [:], showLoader: false, loaderColor: Colorss.DarkRed.toHex())
        
    }
}


extension ClientDashBoardViewController{
    
    func checkPushFromKillState(){
        
        if let dict = UserDataSingleton.sharedInstance.pushDict{
            let status = dict["status"] as? Int
            if status == 1{
                var boolChatVcFound = false
                let controllers = self.navigationController?.viewControllers ?? []
                for control in controllers{
                    if self.navigationController?.visibleViewController is ChatViewController{
                        boolChatVcFound = true
                        UserDataSingleton.sharedInstance.pushDict = nil
                        break
                    }else if control is ChatViewController{
                        boolChatVcFound  = true
                        guard let vc = control as? ChatViewController else {return}
                        vc.clientId = UserDataSingleton.sharedInstance.loggedInUser?.trainer
                        self.pushVC(vc)
                        UserDataSingleton.sharedInstance.pushDict = nil
                        break
                    }
                }
                
                if boolChatVcFound {
                    
                }else{
                    let vc = StoryboardScene.Main.instantiateChatViewController()
                    vc.clientId = UserDataSingleton.sharedInstance.loggedInUser?.trainer
                    pushVC(vc)
                }
            }else if status == 2{
                
            }else{
                
            }
            UserDataSingleton.sharedInstance.pushDict = nil
        }else{}
    }
    
    
    func handlePush(notification: NSNotification){
        
        print(notification.userInfo)
        let userInfo = notification.userInfo
        let notificationType = userInfo?["status"] as? Int
        if notificationType == 1{
            if !boolEnterBackGround{
                
                boolEnterBackGround = false
            }else{
                boolEnterBackGround = false
                var boolChatVcFound = false
                let controllers = self.navigationController?.viewControllers ?? []
                for control in controllers{
                    if self.navigationController?.visibleViewController is ChatViewController{
                        boolChatVcFound = true
                        break
                    }else if control is ChatViewController{
                        boolChatVcFound  = true
                        guard let vc = control as? ChatViewController else {return}
                        vc.clientId = UserDataSingleton.sharedInstance.loggedInUser?.trainer
                        self.pushVC(vc)
                        break
                    }
                }
                
                if boolChatVcFound {
                    
                }else{
                    let vc = StoryboardScene.Main.instantiateChatViewController()
                    vc.clientId = UserDataSingleton.sharedInstance.loggedInUser?.trainer
                    pushVC(vc)
                }
            }
            
        }else if notificationType == 2{
            
        }else{
            
        }
        print(notificationType)
    }
}