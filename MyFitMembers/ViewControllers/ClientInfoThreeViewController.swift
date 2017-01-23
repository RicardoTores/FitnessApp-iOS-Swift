//
//  ClientInfoThreeViewController.swift
//  MyFitMembers
//
//  Created by cbl24 on 9/29/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit

class ClientInfoThreeViewController: UIViewController, DelegateAddClientMeasurementsField , DelegateAddClientTableViewCellTextFieldEditting{
    
    //MARK::- OUTLETS
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var btnNext: UIButton!
    
    //MARK::- VARIABLES
    var dataSourceTableView: DataSourceTableView?
    var item:[AnyObject]? = []
    var popUpAddClientMeasurementField: AddClientMeasurementsField?
    var weightInVc: AddWeighViewController?
    var boolSwitchOn = false
    var boolStandard = true
    var clientId: String?
    
    var objectMeasurement = [NSMutableDictionary()]
    
    //MARK::- OVERRIDE FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        item = ["Chest","Biceps","Waist","Thigh"]
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
        popUpAddClientMeasurementField?.labelHeader.text = "Add Custom Measurement"
        popUpAddClientMeasurementField?.textFieldAddField.placeholderText = "Measurement Name"
    }
    
    func configureTableView(){
        
        dataSourceTableView = DataSourceTableView(tableView: tableView, cell: CellIdentifiers.AddClientTableViewCell.rawValue , item: item, configureCellBlock: { [weak self] (cell, item, indexPath) in
            guard let cell = cell as? AddClientTableViewCell else {return}
            cell.delegate = self
            var measurement = ""
            guard let boolChk = self?.boolStandard else {return}
            if boolChk{
                measurement = "inches"
            }else{
                measurement = "CM"
            }
            cell.setValue(item?[indexPath.row] as? String ?? "", measurementType: measurement)
            }, configureDidSelect: { (indexPath) in
                
        })
        tableView.delegate = dataSourceTableView
        tableView.dataSource = dataSourceTableView
        dataSourceTableView?.item = item ?? []
        dataSourceTableView?.cellHeight = UITableViewAutomaticDimension
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
                
                guard let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0)) as? AddClientTableViewCell else {return}
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
                
                guard let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0)) as? AddClientTableViewCell else {return}
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
        popUpAddClientMeasurementField?.textFieldAddField.text = ""
        self.view.addSubview(popUpAddClientMeasurementField ?? UIView())
        showAnimate(popUpAddClientMeasurementField ?? UIView())
        popUpAddClientMeasurementField?.textFieldAddField.becomeFirstResponder()
    }
    
    
    @IBAction func btnActionNext(sender: UIButton) {
        if btnNext.titleLabel?.text == "NEXT"{
            gatherMeasurements()
        }else{
            let weightInVc = StoryboardScene.Main.instantiateAddWeighViewController()
            weightInVc.clientId = clientId
            self.pushVC(weightInVc)
        }
        
    }
    
    @IBAction func btnActionBack(sender: UIButton) {
        popVC()
    }
    
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
    
    
    
}

extension ClientInfoThreeViewController{
    
    //MARK::- API
    
    func gatherMeasurements(){
        objectMeasurement.removeAll()
        var run = false
        let totalItems = dataSourceTableView?.item ?? []
        for (index, rowItem)in totalItems.enumerate() {
            var measurements  = NSMutableDictionary()
            guard let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0)) as? AddClientTableViewCell else {return}
         
            if cell.textFieldValue.text?.characters.count > 0 && cell.textFieldValue.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) != ""{
                run = true
                guard let measuremntName = cell.labelType?.text else {return}
                measurements["key"] = measuremntName
                measurements["value"] = cell.textFieldValue.text
                measurements["unit"] = cell.labelType.text
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
        
        let dictForBackEnd = API.ApiCreateDictionary.AddClientMeasurement(clientId: clientId , measurements: objectMeasurement.toJson()).formatParameters()
        print(dictForBackEnd)
        
        ApiDetector.getDataOfURL(ApiCollection.apiAddClientMeasurement, dictForBackend: dictForBackEnd, failure: { (data) in
            print(data)
            }, success: { [unowned self] (data) in
                print(data)
                let weightInVc = StoryboardScene.Main.instantiateAddWeighViewController()
                weightInVc.clientId = clientId
                self.pushVC(weightInVc)
            }, method: .POST, viewControl: self, pic: UIImage(), placeHolderImageName: "", headers: [:] , showLoader: true, loaderColor: Colorss.DarkRed.toHex())
    }
    
    
    
    
    
    
}
