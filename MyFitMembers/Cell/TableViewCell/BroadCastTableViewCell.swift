//
//  BroadCastTableViewCell.swift
//  MyFitMembers
//
//  Created by cbl24 on 9/24/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit

class BroadCastTableViewCell: UITableViewCell {
    
    //MARK::- OUTLETS
    
    @IBOutlet weak var labelMessage: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    
    
    var date: NSDate?
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
    
    func setData(data:AnyObject){
        guard let data = data as? BroadCastMessagesListing else {return}
      
        
        let messageDate = changeStringDateFormat1(data.messageTyme ?? "",fromFormat:"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'",toFormat:"MM/dd/yyyy")
        let messageDateFormatted = messageDate.toLocalTime()
        let date = messageDateFormatted.changeFormatOnly("MM/dd/yyyy", date: messageDateFormatted)

        
        
        let messageTyme =  messageDateFormatted.changeFormatOnly("h:mm a", date: messageDateFormatted)
      
        labelMessage.text = data.message
        labelTime.text = messageTyme
        labelDate.text = date
    }
    
    //MARK::- ACTIONS
    
}
