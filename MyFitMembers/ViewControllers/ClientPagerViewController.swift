//
//  ClientPagerViewController.swift
//  MyFitMembers
//
//  Created by cbl24 on 10/14/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import EZSwiftExtensions



class ClientPagerViewController: ButtonBarPagerTabStripViewController  {

//MARK::- OUTLETS
    
    @IBOutlet weak var labelName: UILabel!
    
    

//MARK::- VARIABLES
    var collectionViewDataSource: DataSourceCollectionView?
    var name:String?
    
    var pageController : UIPageViewController?
    var viewControllerArray:[UIViewController] = []
    var foodPicsVc: FoodPicsViewController = StoryboardScene.Main.instantiateFoodPicsViewController()
    var weighInVc: WeighInViewController = StoryboardScene.Main.instantiateWeighInViewController()
    var fitnessAsseessmentVc: FitnessAssessmentsViewController = StoryboardScene.Main.instantiateFitnessAssessmentsViewController()
    var measurementVc: MeasurementViewController = StoryboardScene.Main.instantiateMeasurementViewController()
    var selfieVc: SelfieViewController = StoryboardScene.Main.instantiateSelfieViewController()
    var currentPageIndex = 0
    var collectionViewRow = 0
    var selectedViewControllerIndex = 0
    
//MARK::- OVERRIDE FUNCTIONS
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllerArray = [foodPicsVc , weighInVc, fitnessAsseessmentVc , measurementVc, selfieVc  ]
    }

    override func viewWillAppear(animated: Bool) {
        labelName.text = name ?? ""
        setParticularVc()
        setUpSideBar(false,allowRighSwipe: false)
    }
    
    override func viewControllersForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        buttonSetUpOfPager()
        return [foodPicsVc , weighInVc, fitnessAsseessmentVc , measurementVc, selfieVc  ]
        
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
//MARK::- FUNCTIONS
    
    func setParticularVc(){
        self.moveToViewController(viewControllerArray[selectedViewControllerIndex])
    }
    
    func buttonSetUpOfPager(){
        settings.style.buttonBarBackgroundColor = UIColor.whiteColor()
        settings.style.buttonBarItemBackgroundColor = UIColor.whiteColor()
        settings.style.buttonBarItemFont = UIFont(name: "AvenirNext-Regular", size: 14.0)!
        settings.style.buttonBarItemTitleColor = Colorss.LightRed.toHex()
        settings.style.selectedBarBackgroundColor = Colorss.DarkRed.toHex()
        settings.style.selectedBarHeight = 2.0
        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            
            oldCell?.label.textColor = UIColor(colorLiteralRed: 0.0, green: 0.0, blue: 0.0, alpha: 0.44)
            newCell?.label.textColor = UIColor(colorLiteralRed: 0.0, green: 0.0, blue: 0.0, alpha: 0.88)
            

        }

    }
    
    
//MARK::- ACTIONS
    @IBAction func btnActionBack(sender: UIButton) {
        
        boolPopSelf = false
        popVC()
    }
    
}






