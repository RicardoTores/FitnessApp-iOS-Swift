//
//  MessageTableViewDataSource.swift
//  MyFitMembers
//
//  Created by cbl24 on 12/12/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit

protocol DelegateDeleteChat {
    func deleteChat(row:Int)
}

class MessageTableViewDataSource: DataSourceTableView {
    
    var delegate: DelegateDeleteChat?
    
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let more = UITableViewRowAction(style: .Normal, title: "Delete") { [unowned self] action, index in
            tableView.beginUpdates()
            self.item.removeAtIndex(index.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            tableView.endUpdates()
            self.deleteChat(index.row)
        }
        more.backgroundColor = Colorss.DarkRed.toHex()
        return [more]
    }
    
    
    //MARK::- API
    
    func deleteChat(row:Int){
        delegate?.deleteChat(row)
    }
    
}
