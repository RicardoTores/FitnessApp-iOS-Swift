//
//  SignInViewController.swift
//  MyFitMembers
//
//  Created by cbl24 on 9/22/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//


import UIKit
import EZSwiftExtensions

var runOnce = true
class SignInViewController: UIViewController {
    
    //MARK::- OUTLETS
    @IBOutlet weak var textFieldEmailId: UITextField!{
        didSet{
            
            textFieldEmailId.attributedPlaceholder =  NSAttributedString(string: "Enter your email", attributes: [NSForegroundColorAttributeName: UIColor(red: 242/255, green: 47/255, blue:58/255, alpha: 1.0)])
            
        }
    }
    @IBOutlet weak var viewCollection: UIView!
    @IBOutlet weak var viewLogo: UIView!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var textFieldPassword: UITextField!{
        didSet{
            textFieldPassword.attributedPlaceholder =  NSAttributedString(string: "Enter your password", attributes: [NSForegroundColorAttributeName: UIColor(red: 242/255, green: 47/255, blue:58/255, alpha: 1.0)])
        }
    }
    @IBOutlet weak var btnLogIn: UIButton!
    
    @IBOutlet weak var viewCover: UIView!
    //MARK::- VARIABLES
    var dontHaveAccountPopUp: NoAccountPopUp?
    var clientDashVc: ClientDashBoardViewController?
    
    //MARK::- OVVERIDE FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.hidden = true
        print(UserDataSingleton.sharedInstance.loggedInUser?.userAccessToken)
        instantiateViewController()
        if UserDataSingleton.sharedInstance.loggedInUser?.userAccessToken != nil{
            guard let isClient = UserDataSingleton.sharedInstance.loggedInUser?.isClient else {return}
            if isClient{
                NSNotificationCenter.defaultCenter().postNotificationName("ConfigureLeftDrawer", object: nil)
                let clientDashVc = StoryboardScene.ClientStoryboard.instantiateClientDashBoardViewController()
                
                self.navigationController?.pushViewController(clientDashVc, animated: false)
            }else{
                NSNotificationCenter.defaultCenter().postNotificationName("ConfigureLeftDrawer", object: nil)
                let dashVc = StoryboardScene.Main.instantiateDashBoardViewController()
                self.navigationController?.pushViewController(dashVc, animated: false)
                
            }        }else{
            
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        setUpSideBar(false,allowRighSwipe: false)
    }
    
    override func viewDidAppear(animated: Bool) {
        self.view.hidden = false
        if runOnce{
            logo.center = CGPointMake(self.view.center.x,self.view.center.y)
            viewCollection.transform = CGAffineTransformMakeTranslation(0, UIScreen.mainScreen().bounds.size.height )
            animateView()
            runOnce = false
        }else{
            runOnce = false
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    //MARK::- FUNCTIONS
    
    func instantiateViewController(){
        dontHaveAccountPopUp = NoAccountPopUp(frame: self.view.frame)
    }
    
    func animateView(){
        UIView.animateWithDuration(0.35, delay: 0.2, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.logo.center = self.viewLogo.center
        }) { (completed) -> Void in
        }
        UIView.animateWithDuration(0.5) { () -> Void in
            self.viewCollection.transform = CGAffineTransformIdentity
        }
    }
    
    //MARK::- DELEGATES
    
    
    //MARK:- ACTIONS
    
    @IBAction func btnActionSignIn(sender: UIButton) {
        let check = User.validateLoginFields(textFieldEmailId.text, password: textFieldPassword.text)
        if check{
            let emailId = textFieldEmailId.text?.lowercaseString
            let dictForBackend = API.ApiCreateDictionary.Login(email: emailId , password: textFieldPassword.text).formatParameters()
            print(dictForBackend)
            ApiDetector.getDataOfURL(ApiCollection.apiLogin, dictForBackend: dictForBackend, failure: { (error) in
                print(error)
                }, success: { [weak self] (data) in
                    guard let userData = data as? User else {return}
                    UserDataSingleton.sharedInstance.loggedInUser = userData
                    guard let isClient = UserDataSingleton.sharedInstance.loggedInUser?.isClient else {return}
                    if isClient{
                        NSNotificationCenter.defaultCenter().postNotificationName("ConfigureLeftDrawer", object: nil)
                        let clientDashVc = StoryboardScene.ClientStoryboard.instantiateClientDashBoardViewController()
                        self?.pushVC(clientDashVc)
                    }else{
                        NSNotificationCenter.defaultCenter().postNotificationName("ConfigureLeftDrawer", object: nil)
                        let dashVc = StoryboardScene.Main.instantiateDashBoardViewController()
                        self?.pushVC(dashVc)
                    }
                    AppDelegate.registerNotifications()
                }, method: .PostWithImage, viewControl: self, pic: UIImage(), placeHolderImageName: "", headers: [:] , showLoader: true, loaderColor: UIColor.whiteColor())
            
        }else{
            AlertView.callAlertView("", msg: "Please enter valid email id and password", btnMsg: "OK", vc: self)
        }
    }
    
    @IBAction func btnActionDontHaveAccount(sender: UIButton) {
        self.view.addSubview(dontHaveAccountPopUp ?? UIView())
        showAnimate(dontHaveAccountPopUp ?? UIView())
    }
    
}


func setUpSideBar(allowPan:Bool, allowRighSwipe: Bool){
    guard let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate else { return }
    guard let navigationController = appDelegate.window?.rootViewController as? LeftNavigationViewController else {return}
    navigationController.sideMenu?.hideSideMenu()
    navigationController.sideMenu?.allowPanGesture = allowPan
    navigationController.sideMenu?.allowRightSwipe = allowRighSwipe
}