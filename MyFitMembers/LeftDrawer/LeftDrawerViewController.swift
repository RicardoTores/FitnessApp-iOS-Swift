//
//  LeftDrawerViewController.swift
//  BarExchangeDemo
//
//  Created by cbl16 on 7/28/16.
//  Copyright © 2016 cbl16. All rights reserved.
//

import UIKit
import EZSwiftExtensions

var fromMenu = false

class LeftDrawerViewController: UIViewController,DelegateClientCollectionViewController {
    
    //MARK::- OUTLETS
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnUserImage: UIButton!{
        didSet{
            btnUserImage.layer.cornerRadius = btnUserImage.frame.height/2
        }
    }
    
    @IBOutlet weak var labelUserName: UILabel!
    
    
    //MARK::- VARIABLES
    var selectedMenuItem : Int = 0
    var dataSource:TableViewDataSource?{
        didSet{
            tableView?.dataSource = dataSource
            tableView?.delegate = dataSource
        }
    }
    var clientVc: ClientCollectionViewController?
    var broadCastVc: BroadCastViewController?
    var trainerProfileVc: TrainerProfileViewController?
    var lessonVc: LessonCollectionViewController?
    var dashBoardVc: DashBoardViewController?
    var trainerSettingsVc: TrainerSettingsViewController?
    
    var foodPicsVc: ClientFoodPicsViewController?
    var weighInVc: ClientWeignInViewController?
    var fitnessAssessmentVc: ClientFitnessAssessmentsViewController?
    var measurementVc: ClientMeasurementViewController?
    var selfiesVc: ClientSelfiesViewController?
    var lessonCenterVc: ClientLessonsCollectionViewController?
    var chatVc: ChatViewController?
    var clientProfile: ClientsInfoViewController?
    var nutritioResourceVc: NutritionAndResurcesViewController?
    
    //MARK::- OVERRIDE FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        instantiateViewControllers()
        setUpTableView()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LeftDrawerViewController.setUpTableView), name: "ConfigureLeftDrawer", object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        
    }
    
    //MARK::- FUNCTIONS
    func setUpProfile(){
        
    }
    
    func setUpTableView(){
        guard let isClient = UserDataSingleton.sharedInstance.loggedInUser?.isClient  else {return}
        if isClient{
            setupClientTableViewData()
        }else{
            setupTableViewData()
        }
        guard let imageUrl = UserDataSingleton.sharedInstance.loggedInUser?.userImage?.userOriginalImage else {return}
        guard let imageURL = NSURL(string: ApiCollection.apiImageBaseUrl + imageUrl) else {return}
        
        btnUserImage.yy_setImageWithURL(imageURL, forState: .Normal, options: .ProgressiveBlur)
        labelUserName.text = UserDataSingleton.sharedInstance.loggedInUser?.name
        
    }
    
    func instantiateViewControllers(){
        clientVc = StoryboardScene.Main.instantiateClientCollectionViewController()
        clientVc?.delegate = self
        broadCastVc = StoryboardScene.Main.instantiateBroadCastViewController()
        broadCastVc?.delegate = self
        trainerProfileVc = StoryboardScene.Main.instantiateTrainerProfileViewController()
        trainerProfileVc?.delegate = self
        lessonVc = StoryboardScene.Main.instantiateLessonCollectionViewController()
        lessonVc?.delegate = self
        dashBoardVc = StoryboardScene.Main.instantiateDashBoardViewController()
        trainerSettingsVc = StoryboardScene.Main.instantiateTrainerSettingsViewController()
        
        //MARK::- CLient
        foodPicsVc = StoryboardScene.ClientStoryboard.instantiateClientFoodPicsViewController()
        weighInVc = StoryboardScene.ClientStoryboard.instantiateClientWeignInViewController()
        fitnessAssessmentVc = StoryboardScene.ClientStoryboard.instantiateClientFitnessAssessmentsViewController()
        measurementVc = StoryboardScene.ClientStoryboard.instantiateClientMeasurementViewController()
        selfiesVc = StoryboardScene.ClientStoryboard.instantiateClientSelfiesViewController()
        
        chatVc = StoryboardScene.Main.instantiateChatViewController()
        //        clientProfile = StoryboardScene.ClientStoryboard.instantiateClientsInfoViewController()
        nutritioResourceVc = StoryboardScene.Main.instantiateNutritionAndResurcesViewController()
    }
    
}


//MARK : - setupTableViewData

extension LeftDrawerViewController {
    
    enum TrainerSideBarElemets: Int{
        case clientVc = 0
        case lessonVc = 1
        case broadCast = 2
        case nutrition = 3
    }
    
    enum ClientSideBarElemets: Int{
        case foodVc = 0
        case wightVc = 1
        case fitnessVc = 2
        case measurement = 3
        case selfie = 4
        case lesson = 5
        case chat = 6
        case nutrition = 7
    }
    
    func setupTableViewData() {
        dataSource = TableViewDataSource(items: [["image":"ic_Clients","title":"Clients"],["image":"ic_lessonsSmall","title":"Lessons"],["image":"ic_broadcast","title":"Broadcast"] , ["image":"ic_nutrition","title":"Nutrition/Meal Planning Resources"]], height:56, tableView: tableView, cellIdentifier:"DrawerTableViewCell1", configureCellBlock: { (cell, item,indexPath) in
            
            (cell as? DrawerTableViewCell)?.objData =  item as? [String: String]
            
            
            }, aRowSelectedListener: { [unowned self] (indexPath) in
                
                switch indexPath.row{
                    
                case TrainerSideBarElemets.clientVc.rawValue :
                    guard let viewControl = self.clientVc else {return}
                    fromMenu = true
                    self.pushContentVc(viewControl)
                    
                case TrainerSideBarElemets.lessonVc.rawValue :
                    guard let viewControl = self.lessonVc else {return}
                    viewControl.ofClient = false
                    fromMenu = true
                    self.pushContentVc(viewControl)
                    
                case TrainerSideBarElemets.broadCast.rawValue:
                    guard let viewControl = self.broadCastVc else {return}
                    fromMenu = true
                    self.pushContentVc(viewControl)
                    
                case TrainerSideBarElemets.nutrition.rawValue:
                    guard let viewControl = self.nutritioResourceVc else {return}
                    self.pushContentVc(viewControl)
                    
                default:
                    print("")
                }
                
        })
        
        tableView?.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Fade)
        
    }
    
    func setupClientTableViewData() {
        dataSource = TableViewDataSource(items: [["image":"ic_food_pics","title":"Food Pics"],["image":"ic_weigh-in","title":"Weigh-In"],["image":"ic_fitness","title":"Fitness Assessments"],["image":"drawing","title":"Measurements"],["image":"ic_selfie_s","title":"Selfies"], ["image":"ic_lessonsSmall","title":"Lesson Center"],["image":"ic_chat","title":"Chat with Trainer"] ,["image":"ic_nutrition","title":"Nutrition/Meal Planning Resources"] ], height:56, tableView: tableView, cellIdentifier:"DrawerTableViewCell1", configureCellBlock: { (cell, item,indexPath) in
            
            (cell as? DrawerTableViewCell)?.objData =  item as? [String: String]
            
            
            }, aRowSelectedListener: { (indexPath) in
                
                
                switch indexPath.row{
                    
                case  ClientSideBarElemets.foodVc.rawValue:
                    guard let viewControl = self.foodPicsVc else {return}
                    fromMenu = true
                    self.pushContentVc(viewControl)
                    
                case ClientSideBarElemets.wightVc.rawValue :
                    guard let viewControl = self.weighInVc else {return}
                    fromMenu = true
                    self.pushContentVc(viewControl)
                    
                case ClientSideBarElemets.fitnessVc.rawValue:
                    guard let viewControl = self.fitnessAssessmentVc else {return}
                    fromMenu = true
                    self.pushContentVc(viewControl)
                    
                case ClientSideBarElemets.measurement.rawValue:
                    guard let viewControl = self.measurementVc else {return}
                    fromMenu = true
                    self.pushContentVc(viewControl)
                    
                case ClientSideBarElemets.selfie.rawValue:
                    guard let viewControl = self.selfiesVc else {return}
                    fromMenu = true
                    self.pushContentVc(viewControl)
                    
                case ClientSideBarElemets.lesson.rawValue:
                    guard let viewControl = self.lessonVc else {return}
                    fromMenu = true
                    viewControl.ofClient = true
                    self.pushContentVc(viewControl)
                    
                case ClientSideBarElemets.chat.rawValue:
                    guard let viewControl = self.chatVc else {return}
                    viewControl.clientId = UserDataSingleton.sharedInstance.loggedInUser?.trainer
                    fromMenu = true
                    self.pushContentVc(viewControl)
                    
                case ClientSideBarElemets.nutrition.rawValue:
                    guard let viewControl = self.nutritioResourceVc else {return}
                    fromMenu = true
                    self.pushContentVc(viewControl)

                default:
                    print("")
                }
                
        })
        
        tableView?.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Fade)
        
    }
    
    func getFitnessAssessment(vc : UIViewController){
        let dictForBackEnd = API.ApiCreateDictionary.ClientListing().formatParameters()
        ApiDetector.getDataOfURL(ApiCollection.apiWeeklyAssessmentOfClient, dictForBackend: dictForBackEnd, failure: { (data) in
            print(data)
            }, success: { [weak self] (data) in
                let fitnessAssessmentData = data as? FitnessAssesment
                UserDataSingleton.sharedInstance.fitnessAssesment = fitnessAssessmentData
                if let navVC = (UIApplication.sharedApplication().delegate as? AppDelegate)?.window?.rootViewController as? LeftNavigationViewController,VC = navVC.topViewController {
                    VC.pushVC(vc)
                }
            }, method: .POST, viewControl: self, pic: UIImage(), placeHolderImageName: "", headers: [:] , showLoader: true, loaderColor: Colorss.DarkRed.toHex())
    }
    
    func getWeighIn(vc : UIViewController){
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
                if let navVC = (UIApplication.sharedApplication().delegate as? AppDelegate)?.window?.rootViewController as? LeftNavigationViewController,VC = navVC.topViewController {
                    VC.pushVC(vc)
                }
            }, method: .POST, viewControl: self, pic: UIImage(), placeHolderImageName: "", headers: [:] , showLoader: true, loaderColor: Colorss.DarkRed.toHex())
    }
    
    func getClientMeasurements(vc : UIViewController){
        let dictForBackEnd = API.ApiCreateDictionary.ClientListing().formatParameters()
        ApiDetector.getDataOfURL(ApiCollection.apiWeeklyMeasurementOfClient, dictForBackend: dictForBackEnd, failure: { (data) in
            print(data)
            }, success: { [weak self] (data) in
                let fitnessAssessmentData1 = data as? FitnessAssesment1
                UserDataSingleton.sharedInstance.fitnessAssesment1 = fitnessAssessmentData1
                if let navVC = (UIApplication.sharedApplication().delegate as? AppDelegate)?.window?.rootViewController as? LeftNavigationViewController,VC = navVC.topViewController {
                    VC.pushVC(vc)
                }
            }, method: .POST, viewControl: self, pic: UIImage(), placeHolderImageName: "", headers: [:] , showLoader: true, loaderColor: Colorss.DarkRed.toHex())
    }
    
    func pushContentVc(vc : UIViewController)  {
        if let navVC = (UIApplication.sharedApplication().delegate as? AppDelegate)?.window?.rootViewController as? LeftNavigationViewController,VC = navVC.topViewController {
            VC.toggleSideMenuView()
            if vc is ClientWeignInViewController{
                getWeighIn(vc)
            }else if vc is ClientFitnessAssessmentsViewController{
                getFitnessAssessment(vc)
            }else if vc is ClientMeasurementViewController{
                getClientMeasurements(vc)
            }else{
                VC.pushVC(vc)
            }
            
        }
    }
    
    
    //MARK::- DELEGATE
    
    func delegateClientCollectionViewController(){
        guard let viewControl = self.dashBoardVc else {return}
        fromMenu = false
        self.pushContentVc(viewControl)
        hideSideMenuView()
    }
    
    @IBAction func btnActionProfileButton(sender: UIButton) {
        guard let isClient = UserDataSingleton.sharedInstance.loggedInUser?.isClient  else {return}
        let vc = StoryboardScene.ClientStoryboard.instantiateClientsInfoViewController()
        pushContentVc(vc)
    }
    
    
}

