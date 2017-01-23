//
//  AddWeighViewController.swift
//  MyFitMembers
//
//  Created by cbl24 on 07/11/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit

class AddWeighViewController: UIViewController {
    
    //MARK::- OUTLETS
    @IBOutlet weak var textFieldWeight: UITextField!
    
    @IBOutlet weak var labelUnit: UILabel!
    @IBOutlet weak var btnNext: UIButton!
    //MARK::- VARIABLES
    
    var fitnessAssessmentVc: FitnessAssessmentViewController?
    var clientId: String?
    
    //MARK::- OVERRIDE FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    //MARK::- ACTIONS
    
    @IBAction func btnActionSwitch(sender: UISwitch) {
        if sender.on{
            labelUnit.text = "kg"
        }else{
            labelUnit.text = "lbs"
        }
        
    }
    
    @IBAction func btnActionNext(sender: UIButton) {
        if btnNext.titleLabel?.text == "NEXT"{
            gatherData()
        }else{
            let fitnessAssessmentVc = StoryboardScene.Main.instantiateFitnessAssessmentViewController()
            fitnessAssessmentVc.clientId = clientId
            self.pushVC(fitnessAssessmentVc)
        }
        
    }
    
    @IBAction func btnActionTextField(sender: UITextField) {
        if sender.text?.characters.count > 0 && sender.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) != ""{
            btnNext.setTitle("NEXT", forState: .Normal)
        }else{
            btnNext.setTitle("SKIP", forState: .Normal)
        }
    }
    
    @IBAction func btnActionBack(sender: UIButton) {
        popVC()
    }
}


extension AddWeighViewController{
    
    //MARK::- API
    
    func gatherData(){
        if textFieldWeight.text?.characters.count > 0 && textFieldWeight.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) != ""{
            addCustomMeasurement(textFieldWeight.text ?? "")
        }else{
            AlertView.callAlertView("", msg: "Missing info", btnMsg: "OK", vc: self)
        }
    }
    
    
    func addCustomMeasurement(weight: String){
        guard let clientId = clientId , unit = labelUnit.text else {return}
        let dictForBackEnd = API.ApiCreateDictionary.AddWeight(clientId: clientId, weight: weight , unit: unit).formatParameters()
        print(dictForBackEnd)
        ApiDetector.getDataOfURL(ApiCollection.apiAddWeight, dictForBackend: dictForBackEnd, failure: { (data) in
            print(data)
            }, success: { [unowned self] (data) in
                print(data)
                let fitnessAssessmentVc = StoryboardScene.Main.instantiateFitnessAssessmentViewController()
                fitnessAssessmentVc.clientId = clientId
                self.pushVC(fitnessAssessmentVc)
            }, method: .POST, viewControl: self, pic: UIImage(), placeHolderImageName: "", headers: [:] , showLoader: true, loaderColor: Colorss.DarkRed.toHex())
    }
    
    
    
}