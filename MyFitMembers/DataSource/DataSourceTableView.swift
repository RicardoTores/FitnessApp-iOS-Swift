//
//  DataSourceTableView.swift
//  NeverMynd
//
//  Created by cbl24 on 7/4/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//



import UIKit

typealias ConfigureCellBlock = (cell : AnyObject?, item : [AnyObject]?, indexPath : NSIndexPath) -> ()
typealias ConfigureDidSelectBlock = (NSIndexPath) -> ()
typealias ConfigureViewForHeaderBlock = (cell : AnyObject?, item : AnyObject?, section : Int) -> ()
typealias ConfigureViewForFooterBlock = (cell : AnyObject?, item : AnyObject?, section : Int) -> ()

class DataSourceTableView: NSObject , UITableViewDelegate, UITableViewDataSource {
    
    var tableView: UITableView?
    var sections = [AnyObject]()
    var item = [AnyObject]()
    var configureCellBlock : ConfigureCellBlock?
    var configureDidSelect : ConfigureDidSelectBlock?
    var configureViewForHeader: ConfigureViewForHeaderBlock?
    var configureViewForFooter: ConfigureViewForFooterBlock?
    var headerTitle = [AnyObject]()
    var footerTitle = [AnyObject]()
    var headerHight: CGFloat?
    var footerHeight: CGFloat?
    var cellName: String?
    var cellHeight: CGFloat?
    
    init(tableView: UITableView, cell: String, item: [AnyObject]?, configureCellBlock: ConfigureCellBlock, configureDidSelect: ConfigureDidSelectBlock){
        self.tableView = tableView
        self.cellName = cell
        self.item = item ?? []
        self.configureCellBlock = configureCellBlock
        self.configureDidSelect = configureDidSelect
    }
    
    override init() {
        super.init()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return item.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)->UITableViewCell{
        guard let block = configureCellBlock else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCellWithIdentifier(cellName ?? "")
        block(cell: cell,item : item, indexPath: indexPath)
        return cell ?? UITableViewCell()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let block = configureDidSelect {
            block(indexPath)
        }
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let block = configureViewForFooter else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCellWithIdentifier("TableViewCellInfo")
        cell?.exclusiveTouch = true
        block(cell: cell,item : item, section: section)
        return cell ?? UITableViewCell()
        
    }
    
//    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        guard let block = configureViewForHeader else { return UITableViewCell() }
//        let cell = tableView.dequeueReusableCellWithIdentifier("TableViewCellInfo")
//        cell?.exclusiveTouch = true
//        block(cell: cell,item : item, section: section)
//        return cell ?? UITableViewCell()
//        
//    }
//    
//    
//    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return headerTitle[section] as? String ?? ""
//    }
//    
//    func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
//        return footerTitle[section] as? String ?? ""
//    }
//    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return footerHeight ?? 0.0
    }

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHight ?? 0.0
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return cellHeight ?? UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return cellHeight ?? UITableViewAutomaticDimension
    }
    
    
}
