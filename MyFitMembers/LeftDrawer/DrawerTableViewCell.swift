
//
//  DrawerTableViewCell.swift
//  BarExchangeDemo
//
//  Created by cbl16 on 7/28/16.
//  Copyright © 2016 cbl16. All rights reserved.
//

import UIKit

class DrawerTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var imageViewOptions: UIImageView!
    @IBOutlet weak var labelOptions: UILabel!
    var objData: [String:String]?{
        didSet{
            
            updateUI(objData)
        }
    }
    
    func updateUI(obj:[String:String]?)  {
        
        labelOptions?.text = obj?["title"] ?? ""
        imageViewOptions?.image = UIImage(named: obj?["image"] ?? "")
        
    }

}
