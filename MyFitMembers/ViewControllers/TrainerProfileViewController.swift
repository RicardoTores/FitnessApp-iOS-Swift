//
//  TrainerProfileViewController.swift
//  MyFitMembers
//
//  Created by cbl24 on 10/5/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit
import SABlurImageView

class TrainerProfileViewController: UIViewController , DatePressed{
    
    //MARK::- OUTLETS
    
    @IBOutlet weak var tableView: UITableView!
//    @IBOutlet weak var imageBackGround: SABlurImageView!
//    @IBOutlet weak var imageTrainer: UIImageView!{
//        didSet{
//            imageTrainer.layer.cornerRadius = imageTrainer.frame.width/2
//        }
//    }
//    
//    @IBOutlet weak var btnEdit: UIButton!
//    @IBOutlet weak var labelName: UILabel!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    
    //MARK::- VARIABLES
    var dataSourceTableView: DataSourceTableView?
    var item:[AnyObject]? = []
    var delegate:DelegateClientCollectionViewController?
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
    var date: String?
    
    //MARK::- OVVERIDE FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        getTrainerProfile(true)
//        imageBackGround.addBlurEffect(30, times: 1)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        getTrainerProfile(false)
        setUpSideBar(false,allowRighSwipe: false)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    //MARK::- FUNCTIONS
    func configureTableView(){
        dataSourceTableView = DataSourceTableView(tableView: tableView, cell: CellIdentifiers.TrainerProfileTableViewCell.rawValue , item: item, configureCellBlock: { (cell, item, indexPath) in
            guard let cell = cell as? TrainerProfileTableViewCell else {return}
            cell.delegate = self
            guard let itemVal = item?[indexPath.row] else {return}
            cell.setValue(itemVal)
            }, configureDidSelect: {  (indexPath) in
                
        })
        tableView.delegate = dataSourceTableView
        tableView.dataSource = dataSourceTableView
        dataSourceTableView?.headerHight = 0.0
        dataSourceTableView?.footerHeight = 0.0
        dataSourceTableView?.cellHeight = UITableViewAutomaticDimension
        tableView.reloadData()
        
    }
    
    
    //MARK::- DELEGATES
    
    
    func stateButtonPressed(){
        let alertcontroller =   UIAlertController.showActionSheetController(title: "State", buttons: country ?? [""], success: { [unowned self]
            (state) -> () in
            guard let cell = self.tableView?.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as? TrainerProfileTableViewCell else {return}
            
            cell.btnState.setTitle(state, forState: .Normal)
            
            })
        presentViewController(alertcontroller, animated: true, completion: nil)
    }
    
    
    //MARK::- ACTIONS
    

    
}

extension TrainerProfileViewController{
    
    func getTrainerProfile(showLoader: Bool){
        let  dictForBackEnd = API.ApiCreateDictionary.BroadCastListing().formatParameters()
        ApiDetector.getDataOfURL(ApiCollection.apiTrainerProfile, dictForBackend: dictForBackEnd, failure: { (data) in
            print(data)
            }, success: { [unowned self] (data) in
                guard let personalData = data as? TrainerProfile else {return}
                var items = [TrainerProfile]()
                items.removeAll()
                items.append(personalData)
                self.item = items
                self.configureTableView()
                
            }, method: .POST, viewControl: self, pic: UIImage(), placeHolderImageName: "", headers: [:] , showLoader: showLoader, loaderColor: Colorss.DarkRed.toHex())
    }

    

    
    
    @IBAction func btnActionDatePicker(sender: UIDatePicker) {
        var datee = sender.date
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.timeZone =  NSTimeZone.localTimeZone()
        date = formatter.stringFromDate(datee)
        guard let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as? TrainerProfileTableViewCell else {return}
        
        let registerationDate = changeStringDateFormat(date ?? "",fromFormat:"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'",toFormat:"MM/dd/yyyy")
        cell.labelRegisterationDate.text = registerationDate
    }
}


extension TrainerProfileViewController{
    
        
}