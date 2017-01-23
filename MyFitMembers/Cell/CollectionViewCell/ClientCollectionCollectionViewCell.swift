//
//  ClientCollectionCollectionViewCell.swift
//  MyFitMembers
//
//  Created by cbl24 on 9/23/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit

class ClientCollectionCollectionViewCell: UICollectionViewCell {
    
    //MARK::- OUTLETS
    
    @IBOutlet weak var labelUserName: UILabel!
    @IBOutlet weak var imageUser: UIImageView!
    
    //MARK::- VARIABLES
    
    
    //MARK::- FUNCTIONS
    func setValue(userImage:String?, userName:String? , row:Int){
        guard let userImage = userImage else {return}
        let userImageUrl = ApiCollection.apiImageBaseUrl + userImage
        guard let imageUrl = NSURL(string: userImageUrl) else {return}
        imageUser.yy_setImageWithURL(imageUrl, placeholder: UIImage(named: "ic_placeholder"))
//        imageUser.yy_setImageWithURL(imageUrl, options: .ProgressiveBlur)
        labelUserName.text = userName?.uppercaseFirst
        
    }
    
    //MARK::- ACTIONS
    
    
    
}
