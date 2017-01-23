//
//  DashBoardViewController.swift
//  MyFitMembers
//
//  Created by cbl24 on 9/21/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit
import EZSwiftExtensions

class DashBoardViewController: UIViewController , BannerRemoved {
    
    //MARK::- OUTLETS
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var labelNumberOfUnreadMessages: UILabel!
    
    //MARK:- VARIABLES
    
    var collectionViewDataSource: DataSourceDashBoardCollectionView?
    var item : [AnyObject]?
    var clientCollection: ClientCollectionViewController?
    var messageCollectionVc: MessageViewController?
    var broadcastVc : BroadCastViewController?
    var lessonVc: LessonCollectionViewController?
    var itemBroadCast: AnyObject?
    var broadCastMessage: String?
    var nutritioResourceVc: NutritionAndResurcesViewController?
    
    //MARK::- OVERRIDE FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        fromKillState()
        instantiateViewControllers()
        configureCollectionView()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(DashBoardViewController.handlePush), name: "Push", object: nil)
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
        setUpSideBar(true,allowRighSwipe: true)
        collaborateCellImages()
        configureCollectionView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func instantiateViewControllers(){
        clientCollection = StoryboardScene.Main.instantiateClientCollectionViewController()
        messageCollectionVc = StoryboardScene.Main.instantiateMessageViewController()
        messageCollectionVc?.fromPush = false
        broadcastVc = StoryboardScene.Main.instantiateBroadCastViewController()
        lessonVc = StoryboardScene.Main.instantiateLessonCollectionViewController()
        lessonVc?.ofClient = false
        nutritioResourceVc = StoryboardScene.Main.instantiateNutritionAndResurcesViewController()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    //MARK::- FUNCTIONS
    
    func collaborateCellImages(){
        item = ["ic_clients","ic_lessons","ic_broadcastLarge" , "ic_nutrition-1"]
        
    }
    
    
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
    
    
    enum DashBoard: Int{
        case client =  0
        case lesson =  1
        case broadCast = 2
        case nutrition = 3
    }
    
    func showScreen(item:Int){
        switch item {
        case DashBoard.client.rawValue:
            guard let clientVc = clientCollection else {return}
            pushVC(clientVc)
        case DashBoard.lesson.rawValue:
            guard let lessonVc = lessonVc else {return}
            pushVC(lessonVc)
        case DashBoard.broadCast.rawValue:
            guard let broadcastVc = broadcastVc else {return}
            pushVC(broadcastVc)
        case DashBoard.nutrition.rawValue:
            guard let nutritioResourceVc = nutritioResourceVc else {return}
            pushVC(nutritioResourceVc)
        default:
            break
        }
    }
    
    
    //MARK::- ACTIONS
    
    @IBAction func btnActionSidePanel(sender: UIButton) {
        toggleSideMenuView()
    }
    
    @IBAction func btnActionMessage(sender: UIButton) {
        guard let messageCollectionVc = messageCollectionVc else {return}
        messageCollectionVc.fromPush = false
        pushVC(messageCollectionVc)
    }
    
    
    
}


extension DashBoardViewController{
    
    //MARK::- DATASOURCE DELEGATE
    func removeBanner(){
        removeBroadCast()
    }
    
    //MARK::- APIs
    func removeBroadCast(){
        guard let msg = itemBroadCast as? BroadCastMessage else {return}
        guard let msgId = msg.messageId else {return}
        let dictForBackEnd = API.ApiCreateDictionary.ReadBroadCast(messageId: msgId).formatParameters()
        ApiDetector.getDataOfURL(ApiCollection.apiSingleBroadCastRead, dictForBackend: dictForBackEnd, failure: { (data) in
            
            }, success: { [unowned self] (data) in
                print(data)
            }, method: .POST, viewControl: self, pic: UIImage(), placeHolderImageName: "", headers: [:], showLoader: false, loaderColor: Colorss.DarkRed.toHex())
    }
    
    func getBroadCastMessages(){
        
        let dictForBackEnd = API.ApiCreateDictionary.BroadCastListing().formatParameters()
        ApiDetector.getDataOfURL(ApiCollection.apiSingleBroadCastListing, dictForBackend: dictForBackEnd, failure: { (data) in
            self.configureCollectionView()
            }, success: { [unowned self] (data) in
                print(data)
                guard let msg = data as? BroadCastMessage else {return}
                self.itemBroadCast = msg
                self.broadCastMessage = msg.message
                print( self.broadCastMessage )
                self.configureCollectionView()
                self.labelNumberOfUnreadMessages.text = unReadMessages.toString
            }, method: .POST, viewControl: self, pic: UIImage(), placeHolderImageName: "", headers: [:], showLoader: false, loaderColor: Colorss.DarkRed.toHex())
    }
    
    
    func updateDeviceToken(){
        guard let devToken = deviceToken else {
            AlertView.callAlertView("", msg: "Please allow push notification service in settings", btnMsg: "OK", vc: self)
            return
        }
        let dictForBackEnd = API.ApiCreateDictionary.UpdateDeviceToken(deviceToken: devToken).formatParameters()
        ApiDetector.getDataOfURL(ApiCollection.apiUpdateDeviceToken, dictForBackend: dictForBackEnd, failure: { (data) in
            print(data)
            self.updateDeviceToken()
            }, success: { (data) in
                print(data)
                NSUserDefaults.standardUserDefaults().setValue(true, forKey: "DeviceTokenUpdated")
            }, method: .POST, viewControl: self, pic: UIImage(), placeHolderImageName: "", headers: [:], showLoader: false, loaderColor: Colorss.DarkRed.toHex())
        
    }
    
}

extension DashBoardViewController{
    
    //MARK::- Handle Push
    
    func fromKillState(){
        if let dict = UserDataSingleton.sharedInstance.pushDict{
            let clientId = dict["id"]
            let clientName = dict["name"]
            let image = dict["profilePic"]
            print(clientId)
            print(clientName)
            let status = dict["status"] as? Int
            if status == 1{
                var boolChatVcFound = false
                let controllers = self.navigationController?.viewControllers ?? []
                for control in controllers{
                    if self.navigationController?.visibleViewController is ChatViewController{
                        boolChatVcFound = true
                        UserDataSingleton.sharedInstance.pushDict = nil
                        break
                    }else if control is MessageViewController{
                        guard let vc = control as? MessageViewController else {return}
                        boolChatVcFound  = true
                        vc.fromPush = true
                        vc.clientId = clientId as? String ?? ""
                        vc.clientName = clientName as? String ?? ""
                        vc.image = image as? String ?? ""
                        self.pushVC(control)
                        break
                    }
                }
                
                if boolChatVcFound {
                    
                }else{
                    let vc = StoryboardScene.Main.instantiateMessageViewController()
                    vc.fromPush = true
                    vc.clientId = clientId as? String ?? ""
                    vc.clientName = clientName as? String ?? ""
                    vc.image = image as? String ?? ""
                    pushVC(vc)
                }
                UserDataSingleton.sharedInstance.pushDict = nil
            }else if status == 2{
//                var boolChatVcFound = false
//                let controllers = self.navigationController?.viewControllers ?? []
//                for control in controllers{
//                    if self.navigationController?.visibleViewController is BroadCastViewController{
//                        boolChatVcFound = true
//                        UserDataSingleton.sharedInstance.pushDict = nil
//                        break
//                    }
//                }
//                
//                if boolChatVcFound {
//                    
//                }else{
//                    let vc = StoryboardScene.Main.instantiateBroadCastViewController()
//                    pushVC(vc)
//                }
//                UserDataSingleton.sharedInstance.pushDict = nil
            }else{
                
            }
            
        }else{}
    }
    
    
    
    func handlePush(notification: NSNotification){
        print(notification.userInfo)
        let info = notification.userInfo
        let clientId = info?["id"]
        let clientName = info?["name"]
        let image = info?["profilePic"]
        let status = info?["status"] as? Int
        if status == 1{
            if boolEnterBackGround{
                
                var boolChatVcFound = false
                let controllers = self.navigationController?.viewControllers ?? []
                for control in controllers{
                    if self.navigationController?.visibleViewController is ChatViewController{
                        boolChatVcFound = true
                        break
                    }else if control is MessageViewController{
                        guard let vc = control as? MessageViewController else {return}
                        boolChatVcFound  = true
                        vc.fromPush = true
                        vc.clientId = clientId as? String ?? ""
                        vc.clientName = clientName as? String ?? ""
                        vc.image = image as? String ?? ""
                        self.pushVC(control)
                        break
                    }
                }
                
                if boolChatVcFound {
                    
                }else{
                    let vc = StoryboardScene.Main.instantiateMessageViewController()
                    vc.fromPush = true
                    vc.clientId = clientId as? String ?? ""
                    vc.clientName = clientName as? String ?? ""
                    vc.image = image as? String ?? ""
                    pushVC(vc)
                }
                boolEnterBackGround = false
            }else{
                boolEnterBackGround = false
            }
        }else if status == 2{
            
//            if boolEnterBackGround{
//                
//                var boolChatVcFound = false
//                let controllers = self.navigationController?.viewControllers ?? []
//                for control in controllers{
//                    if self.navigationController?.visibleViewController is BroadCastViewController{
//                        boolChatVcFound = true
//                        break
//                    }
//                }
//                
//                if boolChatVcFound {
//                    
//                }else{
//                    let vc = StoryboardScene.Main.instantiateBroadCastViewController()
//                    pushVC(vc)
//                }
//                boolEnterBackGround = false
//            }else{
//                boolEnterBackGround = false
//            }
            
            
        }else{
            
        }
        print(status)
        print(clientId)
        print(clientName)
        print(boolEnterBackGround)
        
        
    }
}