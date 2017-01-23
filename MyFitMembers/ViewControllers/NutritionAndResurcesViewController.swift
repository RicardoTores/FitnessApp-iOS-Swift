//
//  NutritionAndResurcesViewController.swift
//  MyFitMembers
//
//  Created by cbl24 on 01/12/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit

class NutritionAndResurcesViewController: UIViewController {

//MARK::- OUTLETS
    
    
    @IBOutlet weak var tableView: UITableView!
//MARK::- VARIABLES
    
    var dataSourceTableView:DataSourceTableView?
    var item:[AnyObject] = []
    
//MARK::- OVERRIDE FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    override func viewWillAppear(animated: Bool) {
        getNutritionLinks()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
//MARK::- FUNCTIONS

    func configureTableView(){
        dataSourceTableView = DataSourceTableView(tableView: tableView, cell: CellIdentifiers.NutritionAndResourcesTableViewCell.rawValue, item: item, configureCellBlock: { (cell, item, indexPath) in
            guard let cell = cell as? NutritionAndResourcesTableViewCell else {return}
            guard let val = item?[indexPath.row] as? Nutrition else {return}
            cell.setValues(val)
            }, configureDidSelect: { [unowned self] (indexPath) in
                guard let nutritionItems = self.item as? [Nutrition] else {return}
                guard let link = NSURL(string: nutritionItems[indexPath.row].link ?? "") else {return}
                UIApplication.sharedApplication().openURL(link)
        })
        tableView.delegate = dataSourceTableView
        tableView.dataSource = dataSourceTableView
        tableView.reloadData()
    }
    
   
//MARK::- ACTIONS
    
    @IBAction func btnActionBack(sender: UIButton) {
        popVC()
    }

}

extension NutritionAndResurcesViewController{
    
    //MARK::- API
    
    func getNutritionLinks(){
        var type  = ""
        guard let isClient = UserDataSingleton.sharedInstance.loggedInUser?.isClient else {return}
        if isClient{
            type = "CLIENT"
        }else{
            type = "TRAINER"
        }
        let dictForBackEnd = API.ApiCreateDictionary.FoodNutrition(type: type).formatParameters()
        ApiDetector.getDataOfURL(ApiCollection.apiFoodNutrition, dictForBackend: dictForBackEnd, failure: { (data) in
            print(data)
            }, success: { [unowned self] (data) in
                print(data)
                guard let nutritionData = data as? [Nutrition] else {return}
                self.item = nutritionData
                self.configureTableView()
            }, method: .POST, viewControl: self, pic: UIImage(), placeHolderImageName: "", headers: [:], showLoader: true, loaderColor: Colorss.DarkRed.toHex())
    }
    
    
}