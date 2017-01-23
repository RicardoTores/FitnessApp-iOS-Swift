//
//  WeighInTableViewCell.swift
//  MyFitMembers
//
//  Created by cbl24 on 10/10/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit

class WeighInTableViewCell: UITableViewCell {

//MARK::- OUTLETS
    
    @IBOutlet weak var labelDate: UILabel!
    
    @IBOutlet weak var labelWeight: UILabel!
//MARK::- VARIABLES
    
    
    
//MARK::- OVERRIDE FUNCTIONS
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//MARK::- FUNCTIONS

    func setValue(date: String , weight: CGFloat , unit:String){
        labelDate.text = date
        //        guard let weigh = weight as? String else {return}
        labelWeight.text = "\(weight)" + " " + unit
    }
}
