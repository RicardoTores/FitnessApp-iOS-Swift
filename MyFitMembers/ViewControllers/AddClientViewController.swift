//
//  AddClientViewController.swift
//  MyFitMembers
//
//  Created by cbl24 on 9/24/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit

class AddClientViewController: UIViewController, DelegateAddClientMeasurementsField {

//MARK::- OUTLETS
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnSendInvite: UIButton!
    @IBOutlet weak var textViewAddress: PlaceholderTextView!
    
//MARK::- VARIABLES
    var dataSourceTableView: DataSourceTableView?
    var item:[AnyObject]? = []
    var popUpAddClientMeasurementField: AddClientMeasurementsField?
    
//MARK::- OVERRIDE FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        item = ["Chest","Biceps","Waist","Thigh"]
        instantiateControllers()
        showShadow(btnSendInvite)
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
    }
    
    func configureTableView(){
        
        dataSourceTableView = DataSourceTableView(tableView: tableView, cell: CellIdentifiers.AddClientTableViewCell.rawValue , item: item, configureCellBlock: { (cell, item, indexPath) in
            guard let cell = cell as? AddClientTableViewCell else {return}
            cell.setValue(item?[indexPath.row] as? String ?? "", measurementType: "Inch")
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
    
    
//MARK::- ACTIONS
    
    @IBAction func btnActionAddCustomField(sender: UIButton) {
         popUpAddClientMeasurementField?.textFieldAddField.text = ""
        self.view.addSubview(popUpAddClientMeasurementField ?? UIView())
        showAnimate(popUpAddClientMeasurementField ?? UIView())
    }
    
    
    @IBAction func btnActionBack(sender: UIButton) {
        self.dismissVC(completion: nil)
    }

}
