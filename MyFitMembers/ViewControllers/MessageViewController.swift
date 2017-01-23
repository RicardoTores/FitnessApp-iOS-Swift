//
//  MessageViewController.swift
//  MyFitMembers
//
//  Created by cbl24 on 9/23/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController , DelegateDeleteChat {
    
    //MARK::- OUTLETS
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var labelNODataFound: UILabel!
    
    //MARK::- VARIABLES
    
    var dataSourceTableView: MessageTableViewDataSource?
    var item:[AnyObject]? = []
    var fromPush = false
    var clientId: String?
    var clientName:String?
    var image:String?
    
    
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
        if fromPush{
            guard let id = clientId , name = clientName , clientImage = image else {return}
            moveToChatScreen(id , image: clientImage, name: name)
            fromPush = false
        }else{
            fromPush = false
            getRecentChats()
            setUpSideBar(false,allowRighSwipe: false)
        }
        
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    //MARK::- FUNCTIONS
    
    func moveToChatScreen(id:String , image:String , name:String){
        let chatVc = StoryboardScene.Main.instantiateChatViewController()
        chatVc.clientId = id
        chatVc.userName = name
        chatVc.otherUserImage = image
        self.navigationController?.pushViewController(chatVc, animated: false)
    }
    
    
    func configureTableView(){
        dataSourceTableView = MessageTableViewDataSource(tableView: tableView, cell: CellIdentifiers.MessageTableViewCell.rawValue , item: item, configureCellBlock: { (cell, item, indexPath) in
            guard let cell = cell as? MessageTableViewCell else {return}
            guard let item = item as? [Message] else {return}
            cell.setData(item[indexPath.row])
            }, configureDidSelect: { [weak self] (indexPath) in
                guard let item = self?.item as? [Message] else {return}
                let chatVc = StoryboardScene.Main.instantiateChatViewController()
                chatVc.clientId = item[indexPath.row].userId
                chatVc.otherUserImage = item[indexPath.row].userImage?.userOriginalImage
                chatVc.userName = item[indexPath.row].userName
                self?.pushVC(chatVc)
            })
        tableView.delegate = dataSourceTableView
        tableView.dataSource = dataSourceTableView
        dataSourceTableView?.headerHight = 0.0
        dataSourceTableView?.footerHeight = 0.0
        dataSourceTableView?.cellHeight = UITableViewAutomaticDimension
        dataSourceTableView?.delegate = self
        tableView.reloadData()
    }
    
    //MARK::- DELEGATE
    
    func deleteChat(row:Int){
        guard let item = item as? [Message] else {return}
        let dicrForBackEnd = API.ApiCreateDictionary.DeleteChat(clientId: item[row].userId ?? "").formatParameters()
        ApiDetector.getDataOfURL(ApiCollection.apiDeleteChat, dictForBackend: dicrForBackEnd, failure: { (data) in
            print(data)
            }, success: { (data) in
                print(data)
            }, method: .POST, viewControl: self, pic: UIImage(), placeHolderImageName: "", headers: [:], showLoader: false, loaderColor: Colorss.DarkRed.toHex())
    }
    
    
    //MARK::- ACTIONS
    
    
    @IBAction func btnActionBack(sender: UIButton) {
        popVC()
    }
}

extension MessageViewController{
    
    //MARK::- API
    
    func getRecentChats(){
        
        let dictForBackEnd = API.ApiCreateDictionary.ClientListing().formatParameters()
        ApiDetector.getDataOfURL(ApiCollection.apiChatListing, dictForBackend: dictForBackEnd, failure: { (data) in
            print(data)
            }, success: { [weak self] (data) in
                guard let messageArray = data as? [Message] else {return}
                self?.item = messageArray
                if messageArray.count == 0{
                    self?.labelNODataFound.hidden = false
                }else{
                    self?.labelNODataFound.hidden = true
                }
                self?.configureTableView()
            }, method: .POST, viewControl: self, pic: UIImage(), placeHolderImageName: "", headers: [:] , showLoader: true, loaderColor: Colorss.DarkRed.toHex())
    }
    
}
