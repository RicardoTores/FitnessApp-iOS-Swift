//
//  ClientInfoTableViewCell.swift
//  MyFitMembers
//
//  Created by cbl24 on 10/5/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit

class ClientInfoTableViewCell: UITableViewCell {

//MARK::- OUTLETS
    
    @IBOutlet weak var labelInfoType: UILabel!
    
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
    
    func setValue(infoType:String?){
        guard let infoType = infoType else {return}
        labelInfoType.text = infoType
    }
    
}
