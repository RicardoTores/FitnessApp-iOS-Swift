//
//  ClientAddMeasurementViewController.swift
//  MyFitMembers
//
//  Created by cbl24 on 10/18/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit

protocol BackPressed {
    func backPressed()
}
class ClientAddMeasurementViewController: UIViewController, DelegateAddClientMeasurementsField{
    
    //MARK::- OUTLETS
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var viewTableViewHeader: UIView!
    @IBOutlet weak var btnAddCustomField: UIButton!
    
    
    
    //MARK::- VARIABLES
    var dataSourceTableView: DataSourceTableView?
    var item:[AnyObject]? = []
    var popUpAddClientMeasurementField: AddClientMeasurementsField?
    var fitnessAssessmentVc: FitnessAssessmentViewController?
    var objectMeasurement = [NSMutableDictionary()]
    var boolSwitchOn = false
    var boolStandard: Bool?
    var delegate: BackPressed?
    var allowAddMeasurement:Bool?
    var measurementUnit: String?
    
    //MARK::- OVERRIDE FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        instantiateControllers()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        configureTableView()
        setUpSideBar(false,allowRighSwipe: false)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        popUpAddClientMeasurementField?.removeFromSuperview()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func viewDidLayoutSubviews() {
        handleCustomFieldButton()
    }
    
    //MARK::- FUCTIONS
    
    func showShadow(btn: UIView){
        btn.layer.shadowRadius = 2.0
        btn.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        btn.layer.shadowColor = UIColor.blackColor().CGColor
        btn.layer.shadowOpacity = 1.0
        btn.layer.masksToBounds = false
    }
    
    
    func instantiateControllers(){
        popUpAddClientMeasurementField = AddClientMeasurementsField(frame: self.view.frame)
        popUpAddClientMeasurementField?.delegate = self
        fitnessAssessmentVc = StoryboardScene.Main.instantiateFitnessAssessmentViewController()
        popUpAddClientMeasurementField?.labelHeader.text = "Add Custom Measurement"
        popUpAddClientMeasurementField?.textFieldAddField.placeholderText = "Measurement Name"
    }
    
    func configureTableView(){
        
        dataSourceTableView = DataSourceTableView(tableView: tableView, cell: CellIdentifiers.AddClientTableViewCell.rawValue , item: item, configureCellBlock: { [weak self] (cell, item, indexPath) in
            guard let cell = cell as? AddClientTableViewCell else {return}
            var measurement =  ""
            
            guard let allowAddMeasurement = self?.allowAddMeasurement else {return}
            if allowAddMeasurement{
                guard let boolChk = self?.boolStandard else {return}
                if boolChk{
                    measurement = "inches"
                }else{
                    measurement = "CM"
                }
            }else{
                measurement = self?.measurementUnit ?? ""
            }
            cell.setValue(item?[indexPath.row] as? String ?? "", measurementType: measurement)
            }, configureDidSelect: { (indexPath) in
                
        })
        tableView.delegate = dataSourceTableView
        tableView.dataSource = dataSourceTableView
        dataSourceTableView?.item = item ?? []
        dataSourceTableView?.cellHeight = UITableViewAutomaticDimension
    }
    
    func handleCustomFieldButton(){
        guard let allowAddMeasurement = allowAddMeasurement else {return}
        if allowAddMeasurement{
            btnAddCustomField.hidden = false
            viewTableViewHeader?.frame = CGRectMake(0, 0, DeviceDimensions.width,self.viewTableViewHeader.frame.height)
            tableView?.tableHeaderView = viewTableViewHeader
            
        }else{
            btnAddCustomField.hidden = true
            viewTableViewHeader?.frame = CGRectMake(0, 0, DeviceDimensions.width,0)
            tableView?.tableHeaderView = viewTableViewHeader
        }
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
    
    
    //MARK::- ACTIONS
    
    @IBAction func btnActionSwitch(sender: UISwitch) {
        
        
        if boolSwitchOn{
            boolStandard = true
            sender.setOn(false, animated: true)
            boolSwitchOn.toggle()
        }else{
            sender.setOn(true, animated: true)
            boolStandard = false
            boolSwitchOn.toggle()
        }
        tableView.reloadData()
        
    }
    
    @IBAction func btnActionAddCustomField(sender: UIButton) {
        guard let allowAddMeasurement = allowAddMeasurement else {return}
        if allowAddMeasurement{
            popUpAddClientMeasurementField?.textFieldAddField.becomeFirstResponder()
            popUpAddClientMeasurementField?.textFieldAddField.text = ""
            self.view.addSubview(popUpAddClientMeasurementField ?? UIView())
            showAnimate(popUpAddClientMeasurementField ?? UIView())
        }else{
            AlertView.callAlertView("", msg: "You are not allowed to add custom fields", btnMsg: "OK", vc: self)
        }
        
    }
    
    
    @IBAction func btnActionNext(sender: UIButton) {
        gatherMeasurements()
    }
    
    @IBAction func btnActionBack(sender: UIButton) {
        popVC()
    }
    
}

extension ClientAddMeasurementViewController{
    
    //MARK::- API
    
    func gatherMeasurements(){
        var run = false
        objectMeasurement.removeAll()
        let totalItems = dataSourceTableView?.item ?? []
        for (index, _)in totalItems.enumerate() {
            
            var measurements  = NSMutableDictionary()
            guard let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0)) as? AddClientTableViewCell else {return}
            
            if cell.textFieldValue.text?.characters.count > 0 && cell.textFieldValue.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) != ""{
                run = true
                guard let measuremntName = cell.labelType?.text else {return}
                measurements["key"] = measuremntName
                measurements["value"] = cell.textFieldValue.text
                measurements["unit"] = cell.labelMeasurement.text
                objectMeasurement.append(measurements)
            }else{
                guard let allowAddMeasurement = allowAddMeasurement else {return}
                if allowAddMeasurement{
                    
                }else{
                    run = false
                    AlertView.callAlertView("Missing Info", msg: "Please enter value for all the fields", btnMsg: "OK", vc: self)
                }
            }
            
            //            let measurements  = NSMutableDictionary()
            //            guard let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0)) as? AddClientTableViewCell else {return}
            //            guard let allowAddMeasurement = allowAddMeasurement else {return}
            //            if allowAddMeasurement{
            //
            //            }else{
            //                guard let _ = cell.textFieldValue.text else {
            //                    AlertView.callAlertView("Missing Info", msg: "Please enter value for all the fields", btnMsg: "OK", vc: self)
            //                    return
            //                }
            //            }
            //
            //            guard let measuremntName = cell.labelType?.text else {return}
            //            measurements["key"] = measuremntName
            //            measurements["value"] = cell.textFieldValue.text
            //            measurements["unit"] = cell.labelMeasurement.text
            //            objectMeasurement.append(measurements)
        }
        print(objectMeasurement)
        if run{
            addCustomMeasurement()
        }else{
            
        }
        
    }
    
    func addCustomMeasurement(){
        guard let jsonArray = objectMeasurement.toJson() else {return}
        let dictForBackEnd = API.ApiCreateDictionary.ClientAddFitnessMeasurements(measurements: jsonArray).formatParameters()
        print(dictForBackEnd)
        ApiDetector.getDataOfURL(ApiCollection.apiClientAddMeasurementByClient, dictForBackend: dictForBackEnd, failure: { (data) in
            print(data)
            }, success: { [unowned self] (data) in
                print(data)
                self.getClientMeasurements()
            }, method: .POST, viewControl: self, pic: UIImage(), placeHolderImageName: "", headers: [:] , showLoader: true, loaderColor: Colorss.DarkRed.toHex())
    }
    
    
    func getClientMeasurements(){
        let dictForBackEnd = API.ApiCreateDictionary.ClientListing().formatParameters()
        ApiDetector.getDataOfURL(ApiCollection.apiWeeklyMeasurementOfClient, dictForBackend: dictForBackEnd, failure: { (data) in
            print(data)
            }, success: { [weak self] (data) in
                let fitnessAssessmentData1 = data as? FitnessAssesment1
                UserDataSingleton.sharedInstance.fitnessAssesment1 = fitnessAssessmentData1
                //                self?.popVC()
                self?.delegate?.backPressed()
            }, method: .POST, viewControl: self, pic: UIImage(), placeHolderImageName: "", headers: [:] , showLoader: true, loaderColor: Colorss.DarkRed.toHex())
    }
    
}
