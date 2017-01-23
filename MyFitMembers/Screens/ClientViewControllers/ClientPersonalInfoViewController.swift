//
//  ClientPersonalInfoViewController.swift
//  MyFitMembers
//
//  Created by cbl24 on 9/27/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit

protocol DateOfBirthClicked{
    func showDatePicker()
}

class ClientPersonalInfoViewController: UIViewController, StatePressed{
    
    //MARK::- OUTLETS
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK::- VARIABLES
    var dataSource: DataSourceTableView?
    var item:[AnyObject]?
    var country: [String]? = [
        "Alabama",
        "Alaska",
        "American Samoa",
        "Arizona",
        "Arkansas",
        "California",
        "Colorado",
        "Connecticut",
        "Delaware",
        "District Of Columbia",
        "Federated States Of Micronesia",
        "Florida",
        "Georgia",
        "Guam",
        "Hawaii",
        "Idaho",
        "Illinois",
        "Indiana",
        "Iowa",
        "Kansas",
        "Kentucky",
        "Louisiana",
        "Maine",
        "Marshall Islands",
        "Maryland",
        "Massachusetts",
        "Michigan",
        "Minnesota",
        "Mississippi",
        "Missouri",
        "Montana",
        "Nebraska",
        "Nevada",
        "New Hampshire",
        "New Jersey",
        "New Mexico",
        "New York",
        "North Carolina",
        "North Dakota",
        "Northern Mariana Islands",
        "Ohio",
        "Oklahoma",
        "Oregon",
        "Palau",
        "Pennsylvania",
        "Puerto Rico",
        "Rhode Island",
        "South Carolina",
        "South Dakota",
        "Tennessee",
        "Texas",
        "Utah",
        "Vermont",
        "Virgin Islands",
        "Virginia",
        "Washington",
        "West Virginia",
        "Wisconsin",
        "Wyoming"
    ]
    var delegate: DateOfBirthClicked?
    
    //MARK::- OVVERIDE FUNCTIONS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getPersonalDetails(true)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        getPersonalDetails(false)
        setUpSideBar(false,allowRighSwipe: false)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    //MARK::- DELEGATES
    
    func showDatePicker(){
        
    }
    
    func dateClicked(){
        delegate?.showDatePicker()
    }
    
    
    func stateButtonPressed(){
        let alertcontroller =   UIAlertController.showActionSheetController(title: "State", buttons: country ?? [""], success: { [unowned self]
            (state) -> () in
            guard let cell = self.tableView?.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as? ClientPersonalInfoTableViewCell else {return}
            
            cell.btnState.setTitle(state, forState: .Normal)
            
            })
        presentViewController(alertcontroller, animated: true, completion: nil)
    }
    
    
    //MARK::- FUNCTIONS
    
    func configureTableView(){
        dataSource = DataSourceTableView(tableView: tableView, cell: CellIdentifiers.ClientPersonalInfoTableViewCell.rawValue, item: item, configureCellBlock: { (cell, item, indexPath) in
            guard let profileData = self.item as? [ClientPersonalInfo] else {return}
            guard let cell = cell as? ClientPersonalInfoTableViewCell else {return}
            cell.delegate = self
            cell.setValue(profileData[indexPath.row])
            }, configureDidSelect: { (indexPath) in
                
        })
        dataSource?.item = item ?? []
        dataSource?.cellHeight = UITableViewAutomaticDimension
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
        tableView.reloadData()
    }
    
    
    //MARK::- ACTIONS
    
    
    @IBAction func btnActionDatePicker(sender: UIDatePicker) {
    }
    
    
}


extension ClientPersonalInfoViewController{
    
    func getPersonalDetails(showLoader: Bool){
        let dictForBackEnd = API.ApiCreateDictionary.BroadCastListing().formatParameters()
        ApiDetector.getDataOfURL(ApiCollection.apiClientProfile, dictForBackend: dictForBackEnd, failure: { (data) in
            print(data)
            }, success: { (data) in
                print(data)
                guard let data = data as? ClientPersonalInfo else {return}
                var infoArray = [ClientPersonalInfo]()
                infoArray.append(data)
                self.item = infoArray
                self.configureTableView()
            }, method: .POST, viewControl: self, pic: UIImage(), placeHolderImageName: "", headers: [:] , showLoader: showLoader, loaderColor: Colorss.DarkRed.toHex())
    }
}