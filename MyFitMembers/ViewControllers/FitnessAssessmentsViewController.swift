//
//  FitnessAssessmentsViewController.swift
//  MyFitMembers
//
//  Created by cbl24 on 10/10/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class FitnessAssessmentsViewController: UIViewController , LineChartDelegate , IndicatorInfoProvider {
    
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
    var item:[AnyObject]? = []
    var colors: [UIColor] = [
        UIColor(red: 238/255, green: 40/255, blue: 62/255, alpha: 1),
        UIColor(red: 238/255, green: 207/255, blue: 40/255, alpha: 1),
        UIColor(red: 40/255, green: 157/255, blue: 238/255, alpha: 1),
        UIColor(red: 88/255, green: 238/255, blue: 40/255, alpha: 1),
        UIColor(red: 0.580392, green: 0.403922, blue: 0.741176, alpha: 1),
        UIColor(red: 0.54902, green: 0.337255, blue: 0.294118, alpha: 1),
        UIColor(red: 0.890196, green: 0.466667, blue: 0.760784, alpha: 1),
        UIColor(red: 0.498039, green: 0.498039, blue: 0.498039, alpha: 1),
        UIColor(red: 0.737255, green: 0.741176, blue: 0.133333, alpha: 1),
        UIColor(red: 0.0901961, green: 0.745098, blue: 0.811765, alpha: 1)
    ]
    
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
        
        guard let fitnessData = UserDataSingleton.sharedInstance.fitnessAssesment else { return }
        print(fitnessData.feedData)
        print(fitnessData.fitnessDates)
        viewLineChart.animation.enabled = true
        viewLineChart.area = true
        viewLineChart.x1.labels.visible = true
        viewLineChart.x1.grid.count = 5
        viewLineChart.y1.grid.count = 5
        viewLineChart.y1.labels.visible = false
        guard let fitnessLineArray = fitnessData.feedData else {
            
            viewLineChart.addLine([1])
            viewLineChart.x1.labels.values = ["1"]
            labelNoDataFound.hidden = false
            viewLineChart.hidden = true
            return
        }
        if fitnessLineArray.count == 0{
            viewLineChart.addLine([1])
            viewLineChart.x1.labels.values = ["1"]
            labelNoDataFound.hidden = false
            viewLineChart.hidden = true
        }else{
            viewLineChart.hidden = false
            labelNoDataFound.hidden = true
            viewLineChart.x1.labels.values = fitnessData.fitnessDates ?? []
            for data in fitnessLineArray{
                print(data)
                viewLineChart.addLine(data.map({ $0.toInt()?.toCGFloat ?? 0 }))
                viewLineChart.delegate = self
                guard let date = fitnessData.fitnessDates else {return}
                if date.count > 0{
                    configureTableView(date[0])
                }else{
                    
                }
                
            }
        }
    }
    
    func configureTableView(date: String){
        guard let fitnessData = UserDataSingleton.sharedInstance.fitnessAssesment else { return }
        var assessments = fitnessData.fitnessAssesment?[0].fitnessAssessments
        assessments?.insertAsFirst(WeeklyFitnessAssessmentsValue())
        self.item = assessments
        dataSourceTableView = DataSourceTableView(tableView: tableView, cell: CellIdentifiers.FitnessAssessmentTableViewCell.rawValue , item: item, configureCellBlock: { (cell, item, indexPath) in
            guard let cell = cell as? FitnessAssessmentTableViewCell else {return}
            guard let fitnessData = UserDataSingleton.sharedInstance.fitnessAssesment else { return }
            guard let fitnessAssessments  = fitnessData as? FitnessAssesment else {return}
            guard let dates  = fitnessAssessments.fitnessDates else {return}
            
            let index = dates.indexOf { (date1) -> Bool in
                return date1 == date
            }
            guard let indexVal = index else { return }
            if indexVal == 0 || indexVal == (dates.count - 1){
                var dateArray = [String]()
                dateArray.append("")
                dateArray.append(dates[indexVal] ?? "")
                dateArray.append("")
                cell.setValue(fitnessData, assessmentDate: date , row: indexPath.row , index: 0 , dateArray: dateArray , colors:self.colors)
            }else{
                if indexVal > 0{
                    if dates.count == 2{
                        var dateArray = [String]()
                        dateArray.append(dates[indexVal - 1] ?? "")
                        dateArray.append(dates[indexVal] ?? "")
                        dateArray.append("")
                        guard let index1 = index else {return}
                        cell.setValue(fitnessData, assessmentDate: date , row: indexPath.row , index: index1 , dateArray: dateArray , colors:self.colors)
                    }else if dates.count == 1{
                        var dateArray = [String]()
                        dateArray.append("")
                        dateArray.append(dates[indexVal] ?? "")
                        dateArray.append("")
                        guard let index1 = index else {return}
                        cell.setValue(fitnessData, assessmentDate: date , row: indexPath.row , index: index1 , dateArray: dateArray , colors:self.colors)
                    }else{
                        var dateArray = [String]()
                        dateArray.append(dates[indexVal - 1] ?? "")
                        dateArray.append(dates[indexVal] ?? "")
                        dateArray.append(dates[indexVal + 1] ?? "")
                        guard let index1 = index else {return}
                        cell.setValue(fitnessData, assessmentDate: date , row: indexPath.row , index: index1 , dateArray: dateArray , colors:self.colors)
                    }}
            }            }, configureDidSelect: {  (indexPath) in
                
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
        guard let fitnessData = UserDataSingleton.sharedInstance.fitnessAssesment else { return }
        guard let fitnessAssessments  = fitnessData as? FitnessAssesment else {return}
        guard let dates  = fitnessAssessments.fitnessDates else {return}
        if date == "0"{
        }else{
            configureTableView(date)
        }
    }
    
    
    func indicatorInfoForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Fitness Assessments")
    }
    
    //MARK::- ACTIONS
    
    
}
