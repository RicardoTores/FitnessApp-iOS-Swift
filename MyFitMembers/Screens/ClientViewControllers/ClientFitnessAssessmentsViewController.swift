//
//  FitnessAssessmentsViewController.swift
//  MyFitMembers
//
//  Created by cbl24 on 10/10/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit
import XLPagerTabStrip



protocol InstantiateNewChart {
    func instantiateNewChartForAssessment()
}

class ClientFitnessAssessmentsViewController: UIViewController , LineChartDelegate , IndicatorInfoProvider , AddNewFitnessToExistingChart {
    
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
    var assessmentVc: ClientFitnessAssessmentViewController?
    var delegate:InstantiateNewChart?
    
    //MARK::- OVERRIDE FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        fromWeighIn = false
        instantiateViewControllers()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(animated: Bool) {
        setUpLineChart()
        fromWeighIn = false
        setUpSideBar(false,allowRighSwipe: false)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    //MARK::- FUNCTIONS
    
    func instantiateViewControllers(){
        //        assessmentVc = StoryboardScene.ClientStoryboard.instantiateClientFitnessAssessmentViewController()
    }
    
    func setUpLineChart(){
        viewLineChart.clear()
        viewLineChart.clearAll()
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
        dataSourceTableView = DataSourceTableView(tableView: tableView, cell: CellIdentifiers.ClientFitnessAssessmentTableViewCell.rawValue , item: item, configureCellBlock: { (cell, item, indexPath) in
            guard let cell = cell as? ClientFitnessAssessmentTableViewCell else {return}
            guard let fitnessData = UserDataSingleton.sharedInstance.fitnessAssesment else { return }
            guard let fitnessAssessments  = fitnessData as? FitnessAssesment else {return}
            guard let dates  = fitnessAssessments.fitnessDates else {return}
            
            let index = dates.indexOf { (date1) -> Bool in
                return date1 == date
            }
            let dateArrayIdGrestest = false
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
    
    func addFitness(){
        delegate?.instantiateNewChartForAssessment()
    }
    
    
    func didSelectDataPoint(x: CGFloat, yValues: Array<CGFloat>) {
        print( "x: \(x)     y: \(yValues)")
    }
    
    func selectedData(date: String){
        guard let fitnessData = UserDataSingleton.sharedInstance.fitnessAssesment else { return }
        guard let fitnessAssessments  = fitnessData as? FitnessAssesment else {return}
        guard let dates  = fitnessAssessments.fitnessDates else {return}
        if date == "0"{
        }else{
            configureTableView(date)
        }
        
    }
    
    func indicatorInfoForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "FitnessAssessments")
    }
    
    //MARK::- ACTIONS
    
    @IBAction func btnActionBack(sender: UIButton) {
        popVC()
    }
    
    @IBAction func btnActionAddFitnessAssessment(sender: UIButton) {
        print(self.item)
        var itemArray = [String]()
        var fitnessArray = item as? [WeeklyFitnessAssessmentsValue]
        itemArray.removeAll()
        for fitness in fitnessArray ?? []{
            print(fitness.key)
            if fitness.key != nil{
                itemArray.append(fitness.key ?? "")
            }
        }
        if item == nil{
            let assessmentVc = StoryboardScene.ClientStoryboard.instantiateClientFitnessAssessmentViewController()
            assessmentVc.delegate = self
            assessmentVc.allowAddAssess = true
            assessmentVc.item = ["Push-ups","Sit-ups","Pull-ups","Burpees"]
            pushVC(assessmentVc)
        }else{
            
            let assessmentVc = StoryboardScene.ClientStoryboard.instantiateClientFitnessAssessmentViewController()
            assessmentVc.delegate = self
            assessmentVc.allowAddAssess = false
            assessmentVc.item = itemArray
            pushVC(assessmentVc)
        }
        
    }
    
    
    
}
