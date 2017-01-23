//
//  TableViewDataSource.swift
//  Realm
//
//  Created by Night Reaper on 29/09/15.
//  Copyright (c) 2015 Gagan. All rights reserved.
//


import UIKit

typealias  ListCellConfigureBlock = (cell : AnyObject , item : AnyObject , indexpath: AnyObject?) -> ()
typealias  DidSelectedRow = (indexPath : NSIndexPath) -> ()
typealias ViewForHeaderInSection = (section : Int) -> UIView?


class TableViewDataSource: NSObject  {
    
    var items : Array<AnyObject>?
    var cellIdentifier : String?
    var tableView  : UITableView?
    var tableViewRowHeight : CGFloat = 55.0
    
    var configureCellBlock : ListCellConfigureBlock?
    var aRowSelectedListener : DidSelectedRow?
    var viewforHeaderInSection : ViewForHeaderInSection?
    var headerHeight : CGFloat?
    
    init (items : Array<AnyObject>? , height : CGFloat , tableView : UITableView? , cellIdentifier : String?  , configureCellBlock : ListCellConfigureBlock? , aRowSelectedListener : DidSelectedRow) {
        
        self.tableView = tableView
        self.items = items
        self.cellIdentifier = cellIdentifier
        self.tableViewRowHeight = height
        self.configureCellBlock = configureCellBlock
        self.aRowSelectedListener = aRowSelectedListener
        
    }
    
    override init() {
        super.init()
    }
}

extension TableViewDataSource : UITableViewDelegate , UITableViewDataSource{
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        guard let identifier = cellIdentifier else{
            fatalError("Cell identifier not provided")
        }
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(identifier , forIndexPath: indexPath) as UITableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        if let block = self.configureCellBlock , item: AnyObject = self.items?[indexPath.row]{
            block(cell: cell , item: item , indexpath: indexPath)
        }
        return cell
    }
    
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let block = self.aRowSelectedListener{
            block(indexPath: indexPath)
        }
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items?.count ?? 0
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.tableViewRowHeight
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let block = viewforHeaderInSection else { return nil }
        return block(section: section)
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

        return headerHeight ?? 0.0
    }
    
}
