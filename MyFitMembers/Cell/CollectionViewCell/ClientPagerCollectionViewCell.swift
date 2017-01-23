//
//  ClientPagerCollectionViewCell.swift
//  MyFitMembers
//
//  Created by cbl24 on 10/14/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit
var selectedRow:Int? = 0
class ClientPagerCollectionViewCell: UICollectionViewCell {
    
//MARK::- OUTLETS
    
    @IBOutlet weak var labelControllerName: UILabel!
    
    @IBOutlet weak var labelFloating: UILabel!
//MARK::- VARIABLES
    
//MARK::- FUNCTIONS
    
    func setValue(controllerName:AnyObject, row:Int){
        print(selectedRow)
        if row == selectedRow{
            labelFloating.hidden = false
        }else{
            labelFloating.hidden = true
        }
        labelControllerName.text = String(controllerName)
        self.tag = row
    }
    
}
