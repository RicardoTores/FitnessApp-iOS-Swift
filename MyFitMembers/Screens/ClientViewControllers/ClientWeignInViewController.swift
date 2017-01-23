//
//  ClientWeignInViewController.swift
//  MyFitMembers
//
//  Created by cbl24 on 10/18/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit
import XLPagerTabStrip
class ClientWeignInViewController: UIViewController , LineChartDelegate , DelegateAddWeighIn{
    
    //MARK::- OUTLETS
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewLineChart: LineChart!{
        didSet{
            viewLineChart.backgroundColor = Colorss.lineChartBackgroundColor.toHex()
        }
    }
    
    @IBOutlet weak var labelNoData: UILabel!
    
    //MARK::- VARIABLES
    var dataSourceTableView: DataSourceTableView?
    var item:[AnyObject]?
    var weighInPopUp: WeighInPopUpView?
    var popUpPresent = false
    var boolConfigure = false
    var unitDefined = ""
    
    //MARK::- OVERRIDE FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        fromWeighIn = true
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        setUpLineChart()
        fromWeighIn = true
        setUpSideBar(false,allowRighSwipe: false)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if popUpPresent{
            popUpPresent.toggle()
            removeAnimate(weighInPopUp ?? UIView())
        }else{
            
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    
    //MARK::- FUNCTIONS
    
    func setUpLineChart(){
        
        viewLineChart.clearAll()
        weighInPopUp = WeighInPopUpView(frame: self.view.frame)
        
        var data: [CGFloat] = []
        var xLabels: [String] = []
        
        var points = NSUserDefaults.standardUserDefaults().valueForKey("GraphPointsClient") as? [CGFloat]
        var xString = NSUserDefaults.standardUserDefaults().valueForKey("GraphDatesClient") as? [String]
        
        
        if points == nil || points?.count == 0{
            points = [5]
            xString = ["1"]
            data = points!
            xLabels = xString!
            labelNoData.hidden = false
            viewLineChart.hidden = true
            boolConfigure = false
        }else{
            print(points)
            print(xString)
            labelNoData.hidden = true
            viewLineChart.hidden = false
            guard let points = points , xString = xString else {return}
            data = points
            xLabels = xString
            boolConfigure = true
        }
        
        // simple line with custom x axis labels
        
        viewLineChart.animation.enabled = true
        viewLineChart.area = true
        viewLineChart.x1.labels.visible = true
        viewLineChart.x1.labels.values = xLabels
        viewLineChart.y1.labels.visible = false
        print(data)
        viewLineChart.addLine(data)
        self.item = xLabels
        viewLineChart.delegate = self
        if boolConfigure{
            configureTableView()
        }
    }
    
    func configureTableView(){
        dataSourceTableView = DataSourceTableView(tableView: tableView, cell: CellIdentifiers.ClientsWeighInTableViewCell.rawValue , item: item, configureCellBlock: { [unowned self] (cell, item, indexPath) in
            guard let cell = cell as? ClientsWeighInTableViewCell else {return}
            guard var points = NSUserDefaults.standardUserDefaults().valueForKey("GraphPointsClient") as? [CGFloat] else {return}
            guard var xString = NSUserDefaults.standardUserDefaults().valueForKey("GraphDatesClient") as? [String] else {return}
            guard var units = NSUserDefaults.standardUserDefaults().valueForKey("GraphUnitsClient") as? [String] else {return}
            self.unitDefined = units[0]
            cell.setValue(xString[indexPath.row], weight: points[indexPath.row] , unit: units[indexPath.row])
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
        print( "x: \(x)     y: \(yValues)")
    }
    
    func selectedData(date: String){
        
    }
    
    func delegateAddWeighIn(weigh:String , unit:String){
        sendWeigh(weigh , unit: unit)
    }
    
    //MARK::- ACTIONS
    
    @IBAction func btnActionBack(sender: UIButton) {
        popVC()
    }
    
    @IBAction func btnActionWeighIn(sender: UIButton) {
        if boolConfigure{
            popUpPresent = true
            weighInPopUp?.constraintHeightViewCustomisation.constant = 0
            weighInPopUp?.viewCustomisation.hidden = true
            weighInPopUp?.delegate = self
            weighInPopUp?.labelUnit.text = unitDefined ?? "lbs"
            
            showAnimate(weighInPopUp ?? UIView())
            self.view.addSubview(weighInPopUp ?? UIView())
        }else{
            popUpPresent = true
            weighInPopUp?.delegate = self
            weighInPopUp?.constraintHeightViewCustomisation.constant = 75
            weighInPopUp?.viewCustomisation.hidden = false
            weighInPopUp?.labelUnit.text = "lbs"
            showAnimate(weighInPopUp ?? UIView())
            self.view.addSubview(weighInPopUp ?? UIView())
        }
        
    }
}

extension ClientWeignInViewController{
    
    func sendWeigh(weigh: String , unit:String){
        let dictForBackEnd = API.ApiCreateDictionary.ClientAddWeighIn(weight: weigh , unit: unit).formatParameters()
        print(dictForBackEnd)
        
        ApiDetector.getDataOfURL(ApiCollection.apiClientAddWeighIn, dictForBackend: dictForBackEnd, failure: { (data) in
            print(data)
            }, success: { [weak self] (data) in
                self?.getWeighIn()
            }, method: .POST, viewControl: self, pic: UIImage(), placeHolderImageName: "", headers: [:] , showLoader: true, loaderColor: Colorss.DarkRed.toHex())
    }
    
    func getWeighIn(){
        let dictForBackEnd = API.ApiCreateDictionary.ClientListing().formatParameters()
        ApiDetector.getDataOfURL(ApiCollection.apiWeeklyWeighInsOfClient, dictForBackend: dictForBackEnd, failure: { (data) in
            print(data)
            }, success: { [weak self] (data) in
                
                guard let weighInData = data as? [WeighIn] else {return}
                var dateArray = [String]()
                var pointData = [CGFloat]()
                var unitArray = [String]()
                for values in weighInData{
                    let pt = values.weigh?.toInt()?.toCGFloat
                    let date = values.weighPicDate
                    pointData.append(pt ?? 0.0)
                    let time = changeStringDateFormat(date ?? "",fromFormat:"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'",toFormat:"MM/dd")
                    dateArray.append(time ?? "")
                    let unitVal = values.weighUnit ?? ""
                    unitArray.append(unitVal)
                }
                NSUserDefaults.standardUserDefaults().setValue(pointData, forKey: "GraphPointsClient")
                NSUserDefaults.standardUserDefaults().setValue(dateArray, forKey: "GraphDatesClient")
                NSUserDefaults.standardUserDefaults().setValue(unitArray, forKey: "GraphUnitsClient")
                self?.setUpLineChart()
            }, method: .POST, viewControl: self, pic: UIImage(), placeHolderImageName: "", headers: [:] , showLoader: true, loaderColor: Colorss.DarkRed.toHex())
    }
    
}





