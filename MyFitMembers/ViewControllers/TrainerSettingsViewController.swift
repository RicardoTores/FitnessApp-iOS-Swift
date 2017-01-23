//
//  TrainerSettingsViewController.swift
//  MyFitMembers
//
//  Created by cbl24 on 10/11/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit

class TrainerSettingsViewController: UIViewController {
    
    
    //MARK::- OUTLETS
    
    @IBOutlet weak var labelVersionNumber: UILabel!
    
    
    //MARK::- VARIABLES
    
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
        setUpSideBar(false,allowRighSwipe: false)
        let versionNumber = NSBundle.applicationVersionNumber
        print(versionNumber)
        labelVersionNumber.text = "version " + versionNumber
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    //MARK::- FUNCTIONS
    
    
    func apiHandlingMultipleActions(api: String , dictForBkend: OptionalDictionary){
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
    
    //MARK::- ACTIONS
    
    @IBAction func btnActionLogOut(sender: UIButton) {
        let alertController = UIAlertController(title: "", message: "Are you sure you want to log out?", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        alertController.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { [weak self] (action) in
            self?.handleLogOutAndDeleteAccount(ApiCollection.apiTrainerLogOut)
            }))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBAction func btnActionSwitch(sender: UISwitch) {
        
        if sender.on{
            let dictForBackend = API.ApiCreateDictionary.OnOffPush(status:"TRUE").formatParameters()
            apiHandlingMultipleActions(ApiCollection.apiTrainerPush, dictForBkend: dictForBackend)
            
        }else{
            let dictForBackend = API.ApiCreateDictionary.OnOffPush(status:"FALSE").formatParameters()
            apiHandlingMultipleActions(ApiCollection.apiTrainerPush, dictForBkend: dictForBackend)
            
        }
    }
    
    
    @IBAction func btnActionDeleteAccount(sender: UIButton) {
        let alertController = UIAlertController(title: "", message: "Are you sure you want to delete your account? All your data will be erased.", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        alertController.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { [weak self] (action) in
            self?.handleLogOutAndDeleteAccount(ApiCollection.apiTrainerDeleteAccount)
            }))
        self.presentViewController(alertController, animated: true, completion: nil)
        
        
    }
    
    @IBAction func btnActionChangePassword(sender: UIButton) {
        guard let vc = changePasswordVC else {return}
        pushVC(vc)
    }
    
    
}
