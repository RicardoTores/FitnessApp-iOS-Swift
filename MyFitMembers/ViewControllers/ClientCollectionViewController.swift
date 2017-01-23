//
//  ClientCollectionViewController.swift
//  MyFitMembers
//
//  Created by cbl24 on 9/23/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit

protocol DelegateClientCollectionViewController {
    func delegateClientCollectionViewController()
}

class ClientCollectionViewController: UIViewController , DelegateAddClientPopUp , DelegateClientInfoViewControllerDelete {
    
    //MARK::- OUTLETS
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var labelNoDataFound: UILabel!
    
    //MARK::- VARIABLES
    
    var collectionViewDataSource: DataSourceCollectionView?
    var items:[AnyObject]? = []
    var addClientInfoVc: ClientInfoStepOneViewController?
    var delegate:DelegateClientCollectionViewController?
    var popUpAddClient:AddClientPopUp?
    var boolClientFinallyAdded = false
    
    //MARK::- OVERRIDE FUNCTIONS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        instantiateViewControllers()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        labelNoDataFound.hidden = true
        clientAdded()
        configureCollectionView()
        getClientsInformation()
        setUpSideBar(false,allowRighSwipe: false)
        updateClientsStatus()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    //MARK::- FUNCTIONS
   
    func updateClientsStatus(){
        if clientDeleted{
            clientDeleted = false
            
            AlertView.callAlertView("", msg: "Client was successfully deleted. ", btnMsg: "OK", vc: self)
        }else{
            
        }
    }
    
    
    func clientAdded(){
        if boolClientFinallyAdded{
            boolClientFinallyAdded.toggle()
            showAnimate(popUpAddClient ?? UIView())
            self.view.addSubview(popUpAddClient ?? UIView())
        }else{
            
        }
    }
    
    
    func instantiateViewControllers(){
        addClientInfoVc = StoryboardScene.Main.instantiateClientInfoStepOneViewController()
        popUpAddClient = AddClientPopUp(frame: self.view.frame)
        popUpAddClient?.delegate = self
    }
    
   
    
    func configureCollectionView(){
        collectionViewDataSource = DataSourceCollectionView(collectionView: collectionView, configureCellBlock: { (cell, item, indexPath) in
            guard let cell = cell as? ClientCollectionCollectionViewCell else {return}
            guard let collectionItem = item as? [ClientListing] else {return}
            var newName = ""
            let names = collectionItem[indexPath.row].userName?.split(" ")
            if names?.count == 2{
                newName = names?[0] ?? ""
                newName = newName + " "
                let lastName = names?[1].first ?? ""
                newName = newName.uppercaseFirst + lastName.uppercaseFirst + "."
            }else{
                newName = collectionItem[indexPath.row].userName?.uppercaseFirst ?? ""
            }
            cell.setValue(collectionItem[indexPath.row].userImage?.userOriginalImage,userName: newName,row:indexPath.row)
            let cellWidth = DeviceDimensions.width - 112
            let cellWidths = cellWidth/3
            cell.imageUser.layer.cornerRadius = (cellWidths-10)/2
            
            }, configureDidSelectBlock: { [weak self] (cell, item, indexPath) in
                let vc  = StoryboardScene.Main.instantiateClientInfoViewController()
                guard let collectionItem = item as? [ClientListing] else {return}
                vc.clientId = collectionItem[indexPath.row].userId
                var newName = ""
                let names = collectionItem[indexPath.row].userName?.split(" ")
                if names?.count == 2{
                    newName = names?[0] ?? ""
                    newName = newName + " "
                    let lastName = names?[1] ?? ""
                    newName = newName.uppercaseFirst + lastName.uppercaseFirst
                }else{
                    newName = collectionItem[indexPath.row].userName?.uppercaseFirst ?? ""
                }
                
                vc.clientName = newName
                vc.clientImageUrl = collectionItem[indexPath.row].userImage?.userOriginalImage
                vc.delegate = self
                self?.pushVC(vc)
            }, cellIdentifier: CellIdentifiers.ClientCollectionCollectionViewCell.rawValue)
        collectionView.delegate = collectionViewDataSource
        collectionView.dataSource = collectionViewDataSource
        collectionViewDataSource?.item = items ?? []
        let cellWidth = DeviceDimensions.width - 112
        let cellWidths = cellWidth/3
        collectionViewDataSource?.cellSize = CGSizeMake(cellWidths, cellWidths*1.5)
        collectionViewDataSource?.cellInterItemSpacing = 26.0
        collectionViewDataSource?.cellSpacing = 18.0
        collectionViewDataSource?.boolFromClientPager = false
        collectionView.reloadData()
    }
    
    
    //MARK::- DELEGATE
    
    func delegateAddClientPopUp(){
        self.popUpAddClient?.removeFromSuperview()
        
    }
    
    func delegateClientInfoViewControllerDelete(){
        AlertView.callAlertView("", msg: "Client is deleted successfully", btnMsg: "OK", vc: self)
    }
    
    //MARK::- ACTIONS
    
    @IBAction func btnActionBack(sender: UIButton) {
        guard let controllers = self.navigationController?.viewControllers else {return}
        for cntrlr in controllers{
            if cntrlr is DashBoardViewController{
                self.navigationController?.popToViewController(cntrlr, animated: true)
                break
            }else{}
        }
        
    }
    
    
    @IBAction func btnActionAddClient(sender: UIButton) {
        let addClientInfoVc = StoryboardScene.Main.instantiateClientInfoStepOneViewController()
        pushVC(addClientInfoVc)
    }
    
    
}

extension ClientCollectionViewController{
    
    //MARK::- API
    
    func getClientsInformation(){
        let dictForBackend = API.ApiCreateDictionary.ClientListing().formatParameters()
        
        ApiDetector.getDataOfURL(ApiCollection.apiClientListing, dictForBackend: dictForBackend, failure: { (data) in
            print(data)
            }, success: { [weak self] (data) in
                print(data)
                guard let clientCollectionArray = data as? [ClientListing] else {return}
              
                let orderedCollectionArray = clientCollectionArray.sort { $0.userName?.lowercaseString < $1.userName?.lowercaseString }
                self?.items = orderedCollectionArray
                if clientCollectionArray.count == 0{
                    self?.labelNoDataFound.hidden = false
                }else{
                    self?.labelNoDataFound.hidden = true
                }
                self?.configureCollectionView()
            }, method: .POST, viewControl: self, pic: UIImage(), placeHolderImageName: "", headers: [:] , showLoader: true, loaderColor: Colorss.DarkRed.toHex())
    }
}