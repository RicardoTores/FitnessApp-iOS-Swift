//
//  DashBoardCollectionViewCell.swift
//  MyFitMembers
//
//  Created by cbl24 on 9/22/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit

class DashBoardCollectionViewCell: UICollectionViewCell {
    
//MARK::- OUTLETS
    
    @IBOutlet weak var imageChoice: UIImageView!
    
    
//MARK::- FUNCTIONS
    
    func setImage(image:String){
        imageChoice?.image = UIImage(named: image)
    }
    
//MARK::- ACTIONS
    

    
}
