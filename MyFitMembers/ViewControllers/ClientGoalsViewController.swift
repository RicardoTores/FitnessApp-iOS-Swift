//
//  ClientGoalsViewController.swift
//  MyFitMembers
//
//  Created by cbl24 on 9/29/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit

class ClientGoalsViewController: UIViewController , UITextViewDelegate{
    
    //MARK::- OUTLETS
    
    @IBOutlet weak var textViewGoal: PlaceholderTextView!
    
    @IBOutlet weak var textViewReward: PlaceholderTextView!
    
    @IBOutlet weak var btnComplete: UIButton!
    @IBOutlet weak var textViewPunishment: PlaceholderTextView!
    
    //MARK::- VARIABLES
    
    var clientId: String?
    var clientCollection = StoryboardScene.Main.instantiateClientCollectionViewController()
    
    //MARK::- OVVERIDE FUNCTIONS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textViewGoal.delegate = self
        textViewReward.delegate = self
        textViewPunishment.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func viewWillAppear(animated: Bool) {
        setUpSideBar(false,allowRighSwipe: false)
    }
    
    //MARK::- FUNCTIONS
    
    
    
    //MARK::- DELEGATE
    
    
    
    //MARK::- ACTIONS
    
    
    @IBAction func btnActionComplete(sender: UIButton) {
        if btnComplete.titleLabel?.text == "SKIP"{
            self.clientCollection.boolClientFinallyAdded = true
            self.pushVC(self.clientCollection)
        }else{
            getData()
        }
        
    }
    
    @IBAction func btnActionBack(sender: UIButton) {
        popVC()
    }
    
}
extension ClientGoalsViewController{
    
    //MARK::- API
    func sendGoals(){
        guard let clientId = clientId else {return}
        let dictForBackEnd = API.ApiCreateDictionary.ClientGoals(clientId: clientId, goal: textViewGoal.text, reward: textViewReward.text, punishment: textViewPunishment.text).formatParameters()
        print(dictForBackEnd)
        
        ApiDetector.getDataOfURL(ApiCollection.apiClientGoals, dictForBackend: dictForBackEnd, failure: { (data) in
            print(data)
            }, success: { [unowned self] (data) in
                print(data)
                self.clientCollection.boolClientFinallyAdded = true
                self.pushVC(self.clientCollection)
            }, method: .POST, viewControl: self, pic: UIImage(), placeHolderImageName: "", headers: [:] , showLoader: true, loaderColor: Colorss.DarkRed.toHex())
        
    }
    
    func getData(){
        if checkValue(textViewGoal) && checkValue(textViewReward) && checkValue(textViewPunishment){
            sendGoals()
        }else{
            AlertView.callAlertView("", msg: "Missing Info", btnMsg: "OK", vc: self)
        }
    }
    
    func checkValue(textView: PlaceholderTextView)->Bool{
        if textView.text?.characters.count > 0{
            if textView.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) != ""{
                return true
            }else {return false}
        }else {return false}
    }
    
    
    //MARK::- TEXTVIEW DELEGATE
    func textViewShouldEndEditing(textView: UITextView) -> Bool{
        var bool1 = false
        var bool2 = false
        var bool3 = false
        if textViewGoal.text.characters.count > 0 && textView.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) != ""{
            bool1 = true
        }else{
            bool1 = false
        }
        
        if textViewPunishment.text.characters.count > 0 && textView.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) != ""{
            bool2 = true
        }else{
            bool2 = false
        }
        
        if textViewReward.text.characters.count > 0 && textView.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) != ""{
            bool3 = true
        }else{
            bool2 = false
        }
        
        if bool1 || bool2 || bool3 {
            btnComplete.setTitle("COMPLETE", forState: .Normal)
        }else{
            btnComplete.setTitle("SKIP", forState: .Normal)
        }
        return true
    }
    
}