//
//  LessonCollectionTableViewDataSource.swift
//  MyFitMembers
//
//  Created by cbl24 on 10/7/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit
import EZSwiftExtensions
import AVKit
import MediaPlayer

protocol DelegateGoToQuizScreen{
    func delegateGoToQuizScreen(lessonId:String)
    func delegateShowVideo(index:Int)
}

class LessonCollectionTableViewDataSource: NSObject , UITableViewDelegate, UITableViewDataSource , DelegateGoToQuiz , DelegateShowVideo{

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
    var cellName1: String?
    var cellHeight: CGFloat?
    var cellName2:String?
    var cellName3:String?
    var selectedIndexPath = 0987654
    var collapsed = true
    var delegate:DelegateGoToQuizScreen?
    var vc: LessonCollectionViewController?
    
    init(tableView: UITableView, cell: String, item: [AnyObject]?, configureCellBlock: ConfigureCellBlock, configureDidSelect: ConfigureDidSelectBlock){
        self.tableView = tableView
        self.cellName1 = cell
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
        if selectedIndexPath == 0987654{
            let cell = tableView.dequeueReusableCellWithIdentifier(cellName1 ?? "") as? LessonCollectionCollapsedTableViewCell
            cell?.setValue(item[indexPath.row], row: indexPath.row)
            return cell ?? UITableViewCell()
        }else{
            if indexPath.row == selectedIndexPath{
                guard let item = item as? [Lesson] else {return UITableViewCell()}
                guard let stateChk = item[indexPath.row].state else {return UITableViewCell()}
                if stateChk{
                if item[indexPath.row].isOpen == 1 &&  item[indexPath.row].isComplete == 1{
                    guard let cell = tableView.dequeueReusableCellWithIdentifier(cellName2 ?? "") as? LessonCollectionTableViewCell else { return UITableViewCell() }
                    cell.delegate = self
                    cell.setValue(item[indexPath.row], row: indexPath.row)
                    return cell ?? UITableViewCell()
                }else if item[indexPath.row].isOpen == 1 &&  item[indexPath.row].isComplete == 0{
                    guard let cell = tableView.dequeueReusableCellWithIdentifier(cellName3 ?? "") as? LessonCollectionRecentTableViewCell else { return UITableViewCell() }
                    cell.delegate = self
                    cell.setValue(item[indexPath.row], row: indexPath.row)
                    return cell ?? UITableViewCell()
                }else{
                    let cell = tableView.dequeueReusableCellWithIdentifier(cellName1 ?? "") as? LessonCollectionCollapsedTableViewCell
                    cell?.setValue(item[indexPath.row], row: indexPath.row)
                    return cell ?? UITableViewCell()
                }
             
                }else{
                    let cell = tableView.dequeueReusableCellWithIdentifier(cellName1 ?? "") as? LessonCollectionCollapsedTableViewCell
                    cell?.setValue(item[indexPath.row], row: indexPath.row)
                    return cell ?? UITableViewCell()
                }
            
                
            }else{
                let cell = tableView.dequeueReusableCellWithIdentifier(cellName1 ?? "")
                block(cell: cell,item : item, indexPath: indexPath)
                return cell ?? UITableViewCell()
            }
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedIndexPath = indexPath.row
        guard let item = item as? [Lesson] else {return}
        item[indexPath.row].state?.toggle()
        if item[indexPath.row].isOpen == 0 {
            AlertView.callAlertView("", msg: "This lesson is locked until previous lessons are completed.", btnMsg: "OK", vc: vc ?? UIViewController())
        }else{}
        tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: indexPath.row, inSection: 0)], withRowAnimation: .Automatic )
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
    
    
//MARK::- Delegates
    
    func quizClicked(lessonId: String){
        delegate?.delegateGoToQuizScreen(lessonId)
    }
    
    func delegatePlayVideo(index:Int){
        delegate?.delegateShowVideo(index)
    }
}
