//
//  ClientChatViewController.swift
//  MyFitMembers
//
//  Created by cbl24 on 10/19/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit

class ClientChatViewController: UIViewController {
    
    //MARK::- OUTLETS
    
    @IBOutlet weak var viewBottom: UIView!{
        didSet{
            viewBottom.layer.shadowRadius = 2.0
            viewBottom.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
            viewBottom.layer.shadowColor = UIColor.blackColor().CGColor
            viewBottom.layer.shadowOpacity = 1.0
            viewBottom.layer.masksToBounds = false
        }
    }
    
    @IBOutlet weak var constraintHeightViewBottom: NSLayoutConstraint!
    
    //MARK::- VARIABLES
    
    
    //MARK::- OVVERIDE FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        setUpSideBar(false,allowRighSwipe: false)
    }
    
    //MARK::- FUNCTIONS
    
    
    //MARK::- ACTIONS
    
    @IBAction func btnActionBack(sender: UIButton) {
        popVC()
    }
    
    
    
}

