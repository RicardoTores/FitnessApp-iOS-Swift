//
//  MeasurementViewController.swift
//  MyFitMembers
//
//  Created by cbl24 on 10/14/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class MeasurementViewController: UIViewController, LineChartDelegate , IndicatorInfoProvider {
    
    //MARK::- OUTLETS
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var viewLineChart: LineChart!{
        didSet{
            viewLineChart.backgroundColor = Colorss.lineChartBackgroundColor.toHex()
        }
    }
    
    @IBOutlet weak var labelNoDataFound: UILabel!
    
    //MARK::- VARIABLES
    var dataSourceTableView: DataSourceTableView?
    var item:[AnyObject]?
    
    //MARK::- OVERRIDE FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        fromWeighIn = false
        
        setUpLineChart()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        fromWeighIn = false
        setUpSideBar(false,allowRighSwipe: false)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    //MARK::- FUNCTIONS
    
    func setUpLineChart(){
        
        guard let fitnessData = UserDataSingleton.sharedInstance.fitnessAssesment1 else { return }
        
        if fitnessData.fitnessDates1?.count == 0{
            viewLineChart.animation.enabled = true
            viewLineChart.area = true
            viewLineChart.x1.labels.visible = true
            viewLineChart.x1.labels.values = ["1"]
            viewLineChart.addLine([0])
            viewLineChart.y1.labels.visible = false
            viewLineChart.hidden = true
            labelNoDataFound.hidden = false
        }else{
            labelNoDataFound.hidden = true
            viewLineChart.hidden = false
            viewLineChart.animation.enabled = true
            viewLineChart.area = true
            viewLineChart.x1.labels.visible = true
            viewLineChart.x1.labels.values = fitnessData.fitnessDates1 ?? []
            viewLineChart.y1.labels.visible = false
            guard let fitnessLineArray = fitnessData.feedData1 else { return }
            for data in fitnessLineArray{
                viewLineChart.addLine(data.map({ $0.toInt()?.toCGFloat ?? 0 }))
            }
            viewLineChart.delegate = self
            guard let date = fitnessData.fitnessDates1 else {return}
            
            configureTableView(date[0])
        }
        
        
    }
    
    func configureTableView(date: String){
        
        guard let fitnessData = UserDataSingleton.sharedInstance.fitnessAssesment1 else { return }
        
        var assessments = fitnessData.fitnessAssesment1?[0].fitnessAssessments1
        assessments?.insertAsFirst(WeeklyFitnessAssessmentsValue1())
        self.item = assessments
        
        dataSourceTableView = DataSourceTableView(tableView: tableView, cell: CellIdentifiers.FitnessAssessmentTableViewCell.rawValue , item: item, configureCellBlock: { (cell, item, indexPath) in
            guard let cell = cell as? MeasurementTableViewCell else {return}
            guard let fitnessData = UserDataSingleton.sharedInstance.fitnessAssesment1 else { return }
            guard let fitnessAssessments  = fitnessData as? FitnessAssesment1 else {return}
            guard let dates  = fitnessAssessments.fitnessDates1 else {return}
            
            let index = dates.indexOf { (date1) -> Bool in
                return date1 == date
            }
            guard let indexVal = index else { return }
            if indexVal == 0 || indexVal == (dates.count - 1){
                var dateArray = [String]()
                dateArray.append("")
                dateArray.append(dates[indexVal] ?? "")
                dateArray.append("")
                cell.setValue(fitnessData, assessmentDate: date , row: indexPath.row , index: 0 , dateArray: dateArray)
            }else{
                if indexVal > 0{
                    if dates.count == 2{
                        var dateArray = [String]()
                        dateArray.append(dates[indexVal - 1] ?? "")
                        dateArray.append(dates[indexVal] ?? "")
                        dateArray.append("")
                        guard let index1 = index else {return}
                        cell.setValue(fitnessData, assessmentDate: date , row: indexPath.row , index: index1 , dateArray: dateArray)
                    }else if dates.count == 1{
                        var dateArray = [String]()
                        dateArray.append("")
                        dateArray.append(dates[indexVal] ?? "")
                        dateArray.append("")
                        guard let index1 = index else {return}
                        cell.setValue(fitnessData, assessmentDate: date , row: indexPath.row , index: index1 , dateArray: dateArray)
                    }else{
                        var dateArray = [String]()
                        dateArray.append(dates[indexVal - 1] ?? "")
                        dateArray.append(dates[indexVal] ?? "")
                        dateArray.append(dates[indexVal + 1] ?? "")
                        guard let index1 = index else {return}
                        cell.setValue(fitnessData, assessmentDate: date , row: indexPath.row , index: index1 , dateArray: dateArray)
                    }}
            }
            
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
    func didSelectDataPoint(x: CGFloat, yValues: Array<CGFloat>) {
        print( "x: \(x) y: \(yValues)")
    }
    
    
    func selectedData(date:String){
        guard let fitnessData = UserDataSingleton.sharedInstance.fitnessAssesment1 else { return }
        guard let fitnessAssessments  = fitnessData as? FitnessAssesment1 else {return}
        guard let dates  = fitnessAssessments.fitnessDates1 else {return}
        if dates.count > 0{
            configureTableView(date)
        }else{
            
        }
        
    }
    
    
    func indicatorInfoForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Measurements")
    }
    
    //MARK::- ACTIONS
    
    
    
}
