//
//  ClientSettingsViewController.swift
//  MyFitMembers
//
//  Created by cbl24 on 10/18/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit

class ClientSettingsViewController: UIViewController  , DelegateClientSettingsTableViewCellNotificationSwitchClicked{
    
    
    //MARK::- OUTLETS
    
    @IBOutlet weak var labelVersionNumber: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    //MARK::- VARIABLES
    
    var dataSourceTableView: DataSourceTableView?
    let notificationTypes = ["Trainer Messages" ,"Weekly Reminder"]
    var changePasswordVC: ChangePasswordViewController?
    //MARK::- OVERRIDE FUNCTIONS
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changePasswordVC = StoryboardScene.Main.instantiateChangePasswordViewController()
        // Do any additional setup after loading the view.
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        configureTableView()
        setUpSideBar(false,allowRighSwipe: false)
        let versionNumber = NSBundle.applicationVersionNumber
        print(versionNumber)
        labelVersionNumber.text = "version " + versionNumber
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    //MARK::- FUNCTIONS
    
    func configureTableView(){
        
        dataSourceTableView = DataSourceTableView(tableView: tableView, cell: CellIdentifiers.ClientSettingsTableViewCell.rawValue , item: notificationTypes, configureCellBlock: { (cell, item, indexPath) in
            guard let cell = cell as? ClientSettingsTableViewCell else {return}
            cell.setData(indexPath.row , notificationName:self.notificationTypes[indexPath.row])
            
            }, configureDidSelect: { (indexPath) in
                
        })
        tableView.delegate = dataSourceTableView
        tableView.dataSource = dataSourceTableView
        dataSourceTableView?.item = notificationTypes ?? []
        dataSourceTableView?.cellHeight = UITableViewAutomaticDimension
        tableView.reloadData()
    }
    
    func apiHandlingMultipleActions(api: String , dictForBkend: OptionalDictionary){
        print(dictForBkend)
        print(api)
        ApiDetector.getDataOfURL(api, dictForBackend: dictForBkend, failure: { (data) in
            print(data)
            }, success: { (data) in
                print(data)
            }, method: .POST, viewControl: self, pic: UIImage(), placeHolderImageName: "", headers: [:], showLoader: true, loaderColor: Colorss.DarkRed.toHex())
    }
    
    func handleLogOutAndDeleteAccount (api: String){
        let dictForBackEnd = API.ApiCreateDictionary.ClientListing().formatParameters()
        
        ApiDetector.getDataOfURL(api, dictForBackend: dictForBackEnd, failure: { (data) in
            print(data)
            }, success: { (data) in
                print(data)
                guard let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate else { return }
                appDelegate.logOut()
            }, method: .POST, viewControl: self, pic: UIImage(), placeHolderImageName: "", headers: [:], showLoader: true, loaderColor: Colorss.DarkRed.toHex())
    }
    
    
    func runNotification(type:String , on:Bool){
        if on{
            let dictForBackend = API.ApiCreateDictionary.OnOffPushClient(status:"TRUE" , notificationType: type).formatParameters()
            apiHandlingMultipleActions(ApiCollection.apiClientPush, dictForBkend: dictForBackend)
            
        }else{
            let dictForBackend = API.ApiCreateDictionary.OnOffPushClient(status:"FALSE" , notificationType: type).formatParameters()
            apiHandlingMultipleActions(ApiCollection.apiClientPush, dictForBkend: dictForBackend)
            
        }
    }
    
    
    func sendNotificationType(type:String , boolOn: Bool){
        runNotification(type, on:  boolOn)
    }
    
    //MARK::- ACTIONS
    
    @IBAction func btnActionLogOut(sender: UIButton) {
        let alertController = UIAlertController(title: "", message: "Are you sure you want to logout?", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        alertController.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { [weak self] (action) in
            self?.handleLogOutAndDeleteAccount(ApiCollection.apiClientLogOut)
            }))
        self.presentViewController(alertController, animated: true, completion: nil)
        
        
        
        
    }
    
    
    
    @IBAction func btnActionDeleteAccount(sender: UIButton) {
        let alertController = UIAlertController(title: "", message: "Are you sure you want to delete your account? All your data will be erased.", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "CANCEL", style: UIAlertActionStyle.Default, handler: nil))
        alertController.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { [weak self] (action) in
            self?.handleLogOutAndDeleteAccount(ApiCollection.apiClientDeleteAccount)
            
            }))
        self.presentViewController(alertController, animated: true, completion: nil)
        
        
    }
    
    @IBAction func btnActionChangePassword(sender: UIButton) {
        guard let vc = changePasswordVC else {return}
        pushVC(vc)
    }
    
    
}
