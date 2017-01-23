//
//  TrainerInfo.swift
//  MyFitMembers
//
//  Created by cbl24 on 16/11/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit

class TrainerInfo: NSObject , JSONDecodable {
    
    var trainerName : String?
    var userImageJSON: OptionalSwiftJSONParameters?
    var userImage: UserImage?
   
    
    required init(withAttributes attributes: OptionalSwiftJSONParameters) {
        super.init()
        let trainerName = .trainerName => attributes
        self.trainerName = trainerName?.uppercaseFirst
        
        self.userImageJSON = .profilePic =&* attributes
        self.userImage = UserImage(withAttributes: self.userImageJSON ?? [:])
    }
    
    override init() {
        super.init()
    }
    
}
