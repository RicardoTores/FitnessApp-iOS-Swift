//
//  FitnessAssessmentViewController.swift
//  MyFitMembers
//
//  Created by cbl24 on 9/28/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit
import EZSwiftExtensions


class FitnessAssessmentViewController: UIViewController,DelegateAddClientMeasurementsField  , DelegateAddClientTableViewCellTextFieldEditting{
    
    //MARK::- OUTLETS
    
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var labelSeconds: UILabel!
    @IBOutlet weak var labelMinutes: UILabel!
    @IBOutlet weak var progressViewStopWatch: KDCircularProgress!
    @IBOutlet weak var labelStopWatchStatus: UILabel!
    
    //MARK::- VARIABLES
    var currentCount = 0.0
    let maxCount = 6000.0
    var boolStart = 0
    var dataSourceTableView: DataSourceTableView?
    var item:[AnyObject]? = []
    var popUpAddCustomFitnessField: AddFitnessAssessmentFieldPopUp?
    var clientGoalsVc: ClientGoalsViewController?
    var startTime = NSTimeInterval()
    var timer = NSTimer()
    var timer2 = NSTimer()
    var secondCounter = 0
    var boolMinuteChk = false
    var minutess = 59
    var objectMeasurement = [NSMutableDictionary()]
    var clientId: String?
    
    
    
    //MARK::- OVERRIDE FUNCTIONS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressViewStopWatch.angle = 0
        item = ["Push-ups","Sit-ups","Pull-ups","Burpees"]
        instantiateControllers()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        configureTableView()
        setUpSideBar(false,allowRighSwipe: false)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        popUpAddCustomFitnessField?.removeFromSuperview()
    }
    
    //MARK::- FUNCTIONS
    
    func instantiateControllers(){
        popUpAddCustomFitnessField = AddFitnessAssessmentFieldPopUp(frame: self.view.frame)
        
        popUpAddCustomFitnessField?.delegate = self
        popUpAddCustomFitnessField?.labelHeader.text = "Add Custom Fitness Test"
        
//        popUpAddCustomFitnessField?.textFieldAddField.placeholderText = ""
        //        clientGoalsVc = StoryboardScene.Main.instantiateClientGoalsViewController()
    }
    
    func newAngle() -> Float {
        return Float(360 * (currentCount / maxCount))
    }
    
    func updateTime() {
        ez.runThisInBackground {
            
            self.currentCount += 1
            let newAngleValue = self.newAngle()
            let currentTime = NSDate.timeIntervalSinceReferenceDate()
            
            var elapsedTime: NSTimeInterval = currentTime - self.startTime
            
            let minutes = UInt8(elapsedTime / 60.0)
            elapsedTime -= (NSTimeInterval(minutes) * 60)
            
            let seconds = UInt8(elapsedTime)
            elapsedTime -= NSTimeInterval(seconds)
            
            let fraction = UInt8(elapsedTime * 100)
            let strFraction = String(format: "%02d", fraction)
            ez.runThisInMainThread {
                
                
                if self.minutess > 60 && self.boolMinuteChk{
                    self.labelSeconds.text = ".00"
                    self.progressViewStopWatch.animateToAngle(newAngleValue, duration: 0.0, completion: nil)
                }else{
                    print(strFraction)
                    
                    self.labelSeconds.text = ".\(strFraction)"
                    self.progressViewStopWatch.animateToAngle(newAngleValue, duration: 0.0, completion: nil)
                }

            }
            
        }
    }
    
    func updateClock(){
        
        self.minutess = self.minutess - 1
        self.boolMinuteChk = true
        ez.runThisInMainThread { [unowned self ] in
            if self.minutess < 10{
                self.labelMinutes.text = "00:0\(self.minutess)"
            }else{
                self.labelMinutes.text = "00:\(self.minutess)"
            }
            
            
            if self.minutess == -1{
                self.minutess = 60
                self.timer2.invalidate()
                self.timer.invalidate()
                self.timer.invalidate()
                self.progressViewStopWatch.animateToAngle(0, duration: 0.0, completion: nil)
                self.labelMinutes.text = "01:00"
                self.labelSeconds.text = ".00"
                self.labelStopWatchStatus.text = "RESET"
                self.boolStart = 2
                self.currentCount = 0
            }else{}
        }
    }
    
    func configureTableView(){
        dataSourceTableView = DataSourceTableView(tableView: tableView, cell: CellIdentifiers.FitnessAssessmentFieldTableViewCell.rawValue , item: item, configureCellBlock: { (cell, item, indexPath) in
            guard let cell = cell as? FitnessAssessmentFieldTableViewCell else {return}
            cell.delegate = self
            cell.setValue(item?[indexPath.row] as? String ?? "", measurementType: "Inch")
            }, configureDidSelect: { (indexPath) in
        })
        tableView.delegate = dataSourceTableView
        tableView.dataSource = dataSourceTableView
        dataSourceTableView?.item = item ?? []
        dataSourceTableView?.cellHeight = UITableViewAutomaticDimension
        tableView.reloadData()
    }
    
    //MARK::- DELEGATE
    
    func delegateAddClientMeasurementsField(fieldName:String){
        tableView.beginUpdates()
        self.item?.append(fieldName)
        dataSourceTableView?.item = self.item ?? []
        guard let row = self.item?.count  else {return}
        tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: row - 1, inSection: 0)], withRowAnimation: .Automatic)
        tableView.endUpdates()
    }
    
    func delegateAddClientTableViewCellTextFieldEditting(showSkip: Bool){
        let totalItems = dataSourceTableView?.item ?? []
        if showSkip{
            for (index, rowItem)in totalItems.enumerate() {
                
                guard let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0)) as? FitnessAssessmentFieldTableViewCell else {return}
                let value = cell.textFieldValue.text
                if value?.characters.count > 0 && value?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) != ""{
                    btnNext.setTitle("NEXT", forState: .Normal)
                    break
                }else{
                    btnNext.setTitle("SKIP", forState: .Normal)
                }
            }
            if totalItems.count == 0{
                btnNext.setTitle("SKIP", forState: .Normal)
            }
            
        }else{
            for (index, rowItem)in totalItems.enumerate() {
                
                guard let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0)) as? FitnessAssessmentFieldTableViewCell else {return}
                let value = cell.textFieldValue.text
                if value?.characters.count > 0 && value?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) != ""{
                    btnNext.setTitle("NEXT", forState: .Normal)
                    break
                }else{
                    btnNext.setTitle("SKIP", forState: .Normal)
                }
            }
            if totalItems.count == 0{
                btnNext.setTitle("NEXT", forState: .Normal)
            }
        }
    }
    
    //MARK::- ACTIONS
    
    @IBAction func btnActionAddCustomField(sender: UIButton) {
        popUpAddCustomFitnessField?.textFieldAddField.becomeFirstResponder()
        popUpAddCustomFitnessField?.textFieldAddField.text = ""
        self.view.addSubview(popUpAddCustomFitnessField ?? UIView())
        
        showAnimate(popUpAddCustomFitnessField ?? UIView())
    }
    
    //MARK::- ACTIONS
    @IBAction func btnActionStartStopWatch(sender: UIButton) {
        if boolStart == 0{
            labelMinutes.text = "00:59"
            let aSelector : Selector = #selector(FitnessAssessmentViewController.updateTime)
            
            self.timer2 = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(FitnessAssessmentViewController.updateClock), userInfo: nil, repeats: true)
            self.timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: aSelector, userInfo: nil, repeats: true)
            NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
            NSRunLoop.mainRunLoop().addTimer(timer2, forMode: NSRunLoopCommonModes)
            self.startTime = NSDate.timeIntervalSinceReferenceDate()
            boolStart = 1
            labelStopWatchStatus.text = "STOP"
        }else if boolStart == 1{
            //            progressViewStopWatch.animateToAngle(0, duration: 0.0, completion: nil)
            timer.invalidate()
            timer2.invalidate()
            boolStart = 2
            labelStopWatchStatus.text = "RESET"
            currentCount = 0
            
        }else{
            boolMinuteChk = false
            timer.invalidate()
            timer2.invalidate()
            progressViewStopWatch.animateToAngle(0, duration: 0.0, completion: nil)
            labelMinutes.text = "01:00"
            labelSeconds.text = ".00"
            labelStopWatchStatus.text = "START"
            boolStart = 0
            self.minutess = 60
        }
    }
    
    @IBAction func btnActionNext(sender: UIButton) {
        if btnNext.titleLabel?.text == "NEXT"{
            gatherMeasurements()
        }else{
            let clientGoalsVc = StoryboardScene.Main.instantiateClientGoalsViewController()
            guard let clientId = clientId else {return}
            clientGoalsVc.clientId = clientId
            self.pushVC(clientGoalsVc)
        }
    }
    
    
    @IBAction func btnActionBack(sender: UIButton) {
        popVC()
    }
    
    
}


extension FitnessAssessmentViewController{
    
    //MARK::- API
    
    func gatherMeasurements(){
        objectMeasurement.removeAll()
        var run = false
        let totalItems = dataSourceTableView?.item ?? []
        for (index, rowItem)in totalItems.enumerate() {
            var measurements  = NSMutableDictionary()
            guard let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0)) as? FitnessAssessmentFieldTableViewCell else {return}
            
            if cell.textFieldValue.text?.characters.count > 0 && cell.textFieldValue.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) != ""{
                run = true
                guard let measuremntName = cell.labelType?.text else {return}
                measurements["key"] = measuremntName
                measurements["value"] = cell.textFieldValue.text
                objectMeasurement.append(measurements)
            }
//            else{
//                run = false
//                AlertView.callAlertView("Missing Info", msg: "Please enter value for all the fields", btnMsg: "OK", vc: self)
//                break
//            }
        }
        print(objectMeasurement)
        if run{
            addCustomMeasurement()
        }else{
            
        }
        
        
    }
    
    func addCustomMeasurement(){
        guard let clientId = clientId else {return}
        
        let dictForBackEnd = API.ApiCreateDictionary.AddClientFitnessAssessment(clientId: clientId , measurements: objectMeasurement.toJson()).formatParameters()
        print(dictForBackEnd)
        print(dictForBackEnd)
        
        ApiDetector.getDataOfURL(ApiCollection.apiAddClientAssessment, dictForBackend: dictForBackEnd, failure: { (data) in
            print(data)
            }, success: { [unowned self] (data) in
                print(data)
                let clientGoalsVc = StoryboardScene.Main.instantiateClientGoalsViewController()
                clientGoalsVc.clientId = clientId
                self.pushVC(clientGoalsVc)
            }, method: .POST, viewControl: self, pic: UIImage(), placeHolderImageName: "", headers: [:] , showLoader: true, loaderColor: Colorss.DarkRed.toHex())
    }
    
}


extension Array where Element : AnyObject{
    
    func toJson() -> String? {
        do {
            let data = self
            let jsonData = try NSJSONSerialization.dataWithJSONObject(data, options: NSJSONWritingOptions.PrettyPrinted)
            var string = NSString(data: jsonData, encoding: NSUTF8StringEncoding) ?? ""
            string = string.stringByReplacingOccurrencesOfString("\n", withString: "")
            string = string.stringByReplacingOccurrencesOfString("\\", withString: "") // removes \
//            string = string.stringByReplacingOccurrencesOfString(" ", withString: "")
            return string as String
        }
        catch let error as NSError{
            print(error.description)
            return ""
        }
        
    }
}



