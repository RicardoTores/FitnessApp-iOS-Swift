//
//  LessonCollectionViewController.swift
//  MyFitMembers
//
//  Created by cbl24 on 10/7/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit

class ClientLessonsCollectionViewController: UIViewController {
    
    //MARK::- OUTLETS
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var labelNoDataFound: UILabel!
    
    //MARK::- VARIABLES
    var dataSourceTableView: LessonCollectionTableViewDataSource?
    var item:[AnyObject]? = []
    var selectedIndexPath:Int? = 0987654
    var delegate:DelegateClientCollectionViewController?
    var lessonVc: LessonsViewController?
    
    //MARK::- OVVERIDE FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        instantiateViewController()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        getLessonData()
        setUpSideBar(false,allowRighSwipe: false)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    
    //MARK::- FUNCTIONS
    
    func instantiateViewController(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LessonCollectionViewController.showVideo), name: "ShowVideoPressed", object: nil)
        lessonVc = StoryboardScene.Main.instantiateLessonsViewController()
    }
    
    func configureTableView(){
        dataSourceTableView = LessonCollectionTableViewDataSource(tableView: tableView, cell: CellIdentifiers.LessonCollectionCollapsedTableViewCell.rawValue , item: item, configureCellBlock: { [weak self] (cell, item, indexPath) in
           
            }, configureDidSelect: { [weak self] (indexPath) in
                self?.selectedIndexPath = indexPath.row
                
                self?.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: indexPath.row, inSection: 0)], withRowAnimation: .Automatic )
            })
        tableView.delegate = dataSourceTableView
        tableView.dataSource = dataSourceTableView
        dataSourceTableView?.headerHight = 0.0
        dataSourceTableView?.footerHeight = 0.0
        dataSourceTableView?.cellHeight = UITableViewAutomaticDimension
        dataSourceTableView?.cellName1 = CellIdentifiers.LessonCollectionCollapsedTableViewCell.rawValue
        dataSourceTableView?.cellName2 = CellIdentifiers.LessonCollectionTableViewCell.rawValue
        dataSourceTableView?.cellName3 = CellIdentifiers.LessonCollectionRecentTableViewCell.rawValue
//        dataSourceTableView?.delegate = self
        tableView.reloadData()
    }
    
    
    //MARK::- DELEGATES
    
    func showVideo(){
        guard let lessonVc = lessonVc else {return}
        pushVC(lessonVc)
    }
    
    
    //MARK::- ACTIONS
    
    @IBAction func btnActionBack(sender: UIButton) {
        popVC()
    }
    
}


extension ClientLessonsCollectionViewController{
    
    func getLessonData(){
        let dictForBackEnd = API.ApiCreateDictionary.ClientListing().formatParameters()
        
        ApiDetector.getDataOfURL(ApiCollection.apiLessonListingOfClient, dictForBackend: dictForBackEnd, failure: { (data) in
            print(data)
            }, success: { [unowned self] (data) in
                print(data)
                guard let lessonDat = data as? [Lesson] else {return}
                if lessonDat.count == 0{
                    self.labelNoDataFound.hidden = false
                }else{
                    self.labelNoDataFound.hidden = true
                }
                self.item = lessonDat
                self.configureTableView()
            }, method: .POST, viewControl: self, pic: UIImage(), placeHolderImageName: "", headers: [:] , showLoader: true, loaderColor: Colorss.DarkRed.toHex())
    }
    
}
