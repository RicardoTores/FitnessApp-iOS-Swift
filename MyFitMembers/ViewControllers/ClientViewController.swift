
//
//  ClientViewController.swift
//  MyFitMembers
//
//  Created by cbl24 on 9/22/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit

class ClientViewController: UIViewController ,UIPageViewControllerDataSource ,UIPageViewControllerDelegate{

//MARK::- OUTLETS
    
    @IBOutlet weak var imageUser: UIImageView!{
        didSet{
            imageUser.layer.borderColor = UIColor.whiteColor().CGColor
            imageUser.layer.cornerRadius = imageUser.frame.height/2
        }
    }
    
    @IBOutlet weak var dataContentView: UIView!
    
    
    
//MARK::- VARIABLES
    var pageController : UIPageViewController?
    var pageScrollView:UIScrollView!
    var currentPageIndex:NSInteger = 0
    var clientCollection: ClientCollectionViewController?
    var messageCollectionVc: MessageViewController?
    var broadcastVc : BroadCastViewController?
    var viewControllerArray:NSArray? = []

    
    
//MARK::- OVERRIDE FUNCTIOSN
    
    override func viewDidLoad() {
        super.viewDidLoad()
        instantiateViewControllers()
        guard let clientCollection = clientCollection else {return}
        setUp(clientCollection)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func viewWillAppear(animated: Bool) {
        setUpSideBar(false,allowRighSwipe: false)
    }
    
//MARK::- FUNCTIONS
    func instantiateViewControllers(){
        clientCollection = StoryboardScene.Main.instantiateClientCollectionViewController()
        messageCollectionVc = StoryboardScene.Main.instantiateMessageViewController()
        broadcastVc = StoryboardScene.Main.instantiateBroadCastViewController()
    }
    
    func setUp(firstViewControl: UIViewController){
        guard let clientCollection = clientCollection , messageCollectionVc = messageCollectionVc , broadcastVc = broadcastVc else {return}
        viewControllerArray = [clientCollection,messageCollectionVc,broadcastVc]
        pageController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
        self.pageController?.setViewControllers([firstViewControl], direction: .Forward, animated: true, completion: nil)
        pageController?.view.frame = CGRectMake(0, 0, dataContentView.bounds.width, dataContentView.bounds.height)
        pageController?.delegate = self
        pageController?.dataSource = self
        guard let pageController = pageController else{return}
        self.addChildViewController(pageController)
        self.dataContentView.addSubview(pageController.view)
        self.pageController?.didMoveToParentViewController(self)
    }
    
    
//MARK::- PAGEVIEWCONTROLLER DELEGATE
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        var index : NSInteger = viewControllerArray?.indexOfObject(viewController) ?? 0
        if index == NSNotFound{ return nil }
        index = index + 1
        if index == viewControllerArray?.count{ return nil }
        return viewControllerArray?.objectAtIndex(index) as? UIViewController
    }
    
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        var index : NSInteger = viewControllerArray?.indexOfObject(viewController) ?? 0
        if index == NSNotFound || index == 0{ return nil }
        index = index - 1
        return viewControllerArray?.objectAtIndex(index) as? UIViewController
    }
    
    
//MARK::- ACTIONS
    

   

}
