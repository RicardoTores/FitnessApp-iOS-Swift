//
//  ClientLeftDrawerViewController.swift
//  MyFitMembers
//
//  Created by cbl24 on 10/19/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit
import EZSwiftExtensions

class ClientLeftDrawerViewController:  UIViewController {
    
//    //MARK::- OUTLETS
//    @IBOutlet weak var tableView: UITableView!
//    @IBOutlet weak var btnUserName: UIButton!{
//        didSet{
//            btnUserName.layer.cornerRadius = btnUserName.frame.height/2
//        }
//    }
//    
//    //MARK::- VARIABLES
//    var selectedMenuItem : Int = 0
//    var dataSource:TableViewDataSource?{
//        didSet{
//            tableView?.dataSource = dataSource
//            tableView?.delegate = dataSource
//        }
//    }
//    var foodPicsVc: ClientFoodPicsViewController?
//    var weighInVc: ClientWeignInViewController?
//    var fitnessAssessmentVc: ClientFitnessAssessmentsViewController?
//    var measurementVc: ClientMeasurementViewController?
//    var selfiesVc: ClientSelfiesViewController?
//    var lessonCenterVc: ClientLessonsCollectionViewController?
//    var chatVc: ClientChatViewController?
//    var clientProfile: ClientsInfoViewController?
//    
//    
//    //MARK::- OVERRIDE FUNCTIONS
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        instantiateViewControllers()
//        setupTableViewData()
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LeftDrawerViewController.setUpProfile), name: "setupProfileImage", object: nil)
//    }
//    
//    override func viewWillAppear(animated: Bool) {
//        setUpProfile()
//    }
//    
//    
//    //MARK::- FUNCTIONS
//    func setUpProfile(){
//        
//    }
//    
//    func instantiateViewControllers(){
//        foodPicsVc = StoryboardScene.ClientStoryboard.instantiateClientFoodPicsViewController()
//        weighInVc = StoryboardScene.ClientStoryboard.instantiateClientWeignInViewController()
//        fitnessAssessmentVc = StoryboardScene.ClientStoryboard.instantiateClientFitnessAssessmentsViewController()
//        measurementVc = StoryboardScene.ClientStoryboard.instantiateClientMeasurementViewController()
//        selfiesVc = StoryboardScene.ClientStoryboard.instantiateClientSelfiesViewController()
//        lessonCenterVc = StoryboardScene.ClientStoryboard.instantiateClientLessonsCollectionViewController()
//        chatVc = StoryboardScene.ClientStoryboard.instantiateClientChatViewController()
//        clientProfile = StoryboardScene.ClientStoryboard.instantiateClientsInfoViewController()
//    }
    
}


//MARK : - setupTableViewData

extension ClientLeftDrawerViewController {
    
//    func setupClientTableViewData() {
//        dataSource = TableViewDataSource(items: [["image":"ic_food_pics","title":"Food Pics"],["image":"ic_weigh-in","title":"Weigh-In"],["image":"ic_fitness","title":"Fitness Assessments"],["image":"drawing","title":"Measurements"],["image":"ic_selfie_s","title":"Selfies"], ["image":"ic_lessonsSmall","title":"Lesson Center"],["image":"ic_chat","title":"Chat with Trainer"],["image":"ic_nutrition","title":"Food/Nutrition Resources"]], height:56, tableView: tableView, cellIdentifier:"DrawerTableViewCell1", configureCellBlock: { (cell, item,indexPath) in
//            
//            (cell as? DrawerTableViewCell)?.objData =  item as? [String: String]
//            
//            
//            }, aRowSelectedListener: { (indexPath) in
//                
//                
//                switch indexPath.row{
//                    
//                case 0 :
//                    guard let viewControl = self.foodPicsVc else {return}
//                    fromMenu = true
//                    self.pushVcr(viewControl)
//                    
//                case 1 :
//                    guard let viewControl = self.weighInVc else {return}
//                    fromMenu = true
//                    self.pushVcr(viewControl)
//                    
//                case 2:
//                    guard let viewControl = self.fitnessAssessmentVc else {return}
//                    fromMenu = true
//                    self.pushVcr(viewControl)
//                    
//                case 3:
//                    guard let viewControl = self.measurementVc else {return}
//                    fromMenu = true
//                    self.pushVcr(viewControl)
//                    
//                case 4:
//                    guard let viewControl = self.selfiesVc else {return}
//                    fromMenu = true
//                    self.pushVcr(viewControl)
//                    
//                case 5:
//                    guard let viewControl = self.lessonCenterVc else {return}
//                    fromMenu = true
//                    self.pushVcr(viewControl)
//                    
//                case 6:
//                    guard let viewControl = self.chatVc else {return}
//                    fromMenu = true
//                    self.pushVcr(viewControl)
//                    
//                case 7:
//                    break
//                    
//                    
//                default:
//                    print("")
//                }
//                
//        })
//        
//        tableView?.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Fade)
//        
//    }
//    
//    func pushVcr(vc : UIViewController)  {
//        
//        
//        
//        if let navVC = (UIApplication.sharedApplication().delegate as? AppDelegate)?.window?.rootViewController as? LeftNavigationViewController,VC = navVC.topViewController {
//            VC.toggleSideMenuView()
//            VC.pushVC(vc)
//        }
//        
//        //        sideMenuController()?.setContentViewController(vc)
//    }
//    
//    
//    //MARK::- DELEGATE
//    
//    @IBAction func btnActionProfileButton(sender: UIButton) {
//        guard let vc = clientProfile else {return}
//        pushVcr(vc)
//    }
    
}

