//
//  DataSourceTableViewMoreCells.swift
//  NeverMynd
//
//  Created by cbl24 on 7/20/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit

typealias  TableViewCellConfigureBlock = (cell : AnyObject , item : AnyObject,indexPath : NSIndexPath) -> ()

class DataSourceTableViewMoreCells:NSObject,UITableViewDelegate, UITableViewDataSource {
    
    
    var tableView: UITableView?
    var sections = [AnyObject]()
    var configureCellBlock : TableViewCellConfigureBlock?
    var configureDidSelect : ConfigureDidSelectBlock?
    var configureViewForHeader: ConfigureViewForHeaderBlock?
    var configureViewForFooter: ConfigureViewForFooterBlock?
    var headerTitle = [AnyObject]()
    var footerTitle = [AnyObject]()
    var headerHight: CGFloat?
    var footerHeight: CGFloat?
    var cellName: String?
    var messages = [MessageListing]()
    var myID = UserDataSingleton.sharedInstance.loggedInUser?.userId
    var otherUserImage: String?
    var userImg: String?
    
    var currentMessage : Message?{
        didSet{
            //            updateUI()
        }
    }
    
    init(tableView: UITableView, cell: String, item: [MessageListing], configureCellBlock: TableViewCellConfigureBlock, configureDidSelect: ConfigureDidSelectBlock){
        self.tableView = tableView
        self.cellName = cell
        self.messages = item
        self.configureCellBlock = configureCellBlock
        self.configureDidSelect = configureDidSelect
    }
    
    override init() {
        super.init()
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)->UITableViewCell{
        
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(self.getIdentifier(indexPath: indexPath) , forIndexPath: indexPath) as UITableViewCell
        cell.exclusiveTouch = true
        
        print(userImg)
        print(otherUserImage)
        (cell as? UserChatTableViewCell)?.setData(userImg ?? "")
        (cell as? OtherUserChatTableViewCell)?.setData(otherUserImage ?? "") 
        
        (cell as? UserChatTableViewCell)?.message = messages[indexPath.row]
        (cell as? OtherUserChatTableViewCell)?.message = messages[indexPath.row]
        
        if let block = self.configureCellBlock , item: AnyObject = self.messages[indexPath.row] {
            block(cell: cell,item: item,indexPath: indexPath)
        }
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let block = configureDidSelect {
            block(indexPath)
        }
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let tempMessage = self.messages[indexPath.row]
        let identifier = self.getIdentifier(indexPath: indexPath)
        if identifier == CellIdentifiers.UserChatTableViewCell.rawValue || identifier == CellIdentifiers.OtherUserChatTableViewCell.rawValue{
            
            struct Static {
                static var sizingCell: UserChatTableViewCell?
            }
            if Static.sizingCell == nil {
                Static.sizingCell = self.tableView?.dequeueReusableCellWithIdentifier(identifier) as? UserChatTableViewCell
            }
            Static.sizingCell?.message = messages[indexPath.row]
            print(messages[indexPath.row].message)
            
            self.getIdentifier(indexPath: indexPath)
            let size = Static.sizingCell?.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
            return (size?.height) ?? 50.0 + 1.0
        }
        else{
            return 200
        }
    }
    
    
    
    private func getIdentifier (indexPath indexPath:NSIndexPath) -> String{
        let identifier = CellIdentifiers.UserChatTableViewCell.rawValue
        guard  let userID = messages[indexPath.row].messageFrom  else { return identifier }
        return userID == myID ? CellIdentifiers.UserChatTableViewCell.rawValue : CellIdentifiers.OtherUserChatTableViewCell.rawValue
    }
    
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.tableView?.superview?.endEditing(true)
    }
    
    
}
