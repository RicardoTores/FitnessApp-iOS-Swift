//
//  OtherUserChatTableViewCell.swift
//  MyFitMembers
//
//  Created by cbl24 on 03/11/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit

class OtherUserChatTableViewCell: UITableViewCell {
    
    //MARK::- OUTLETS
    
    @IBOutlet weak var labelMessage: UILabel!
    
    @IBOutlet weak var imageUser: UIImageView!{
        didSet{
            imageUser.layer.cornerRadius = imageUser.frame.width/2
        }
    }

    @IBOutlet weak var labelTime: UILabel!
    
    //MARK::-  VARIABLES
    
    var imageOfUser: String?
    
    var message : MessageListing?{
        didSet{
            
            labelMessage.text = message?.message
            let messageDate = changeStringDateFormat1(message?.messageCreatedAt ?? "",fromFormat:"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'",toFormat:"MM/dd/yyyy")
            let messageDateFormatted = messageDate.toLocalTime()
            let messageTyme =  messageDateFormatted.changeFormatOnly("MM/dd/yyyy h:mm a", date: messageDateFormatted)
            
         
            labelTime.text = messageTyme
            
        }
    }
    
    
    //MARK::- OVERRIDE FUNCTIONS
    override func awakeFromNib() {
        super.awakeFromNib()
        print(imageOfUser)
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    //MARK::- FUNCTIONS
    
    func setData(image:String){
        print(image)
        let imgUrl = ApiCollection.apiImageBaseUrl + image
        guard let url = NSURL(string: imgUrl) else {return}
        
        imageUser.yy_setImageWithURL(url, placeholder: UIImage(named: "ic_placeholder"))
    }
    
}
