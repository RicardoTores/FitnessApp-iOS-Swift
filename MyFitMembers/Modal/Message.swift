//
//  Message.swift
//  MyFitMembers
//
//  Created by cbl24 on 03/11/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit
import SwiftyJSON

class Message: NSObject  , JSONDecodable{
    
    var count: Int?
    var message: String?
    var userId: String?
    var userName : String?
    var messageTime: String?
    var userImageJSON: OptionalSwiftJSONParameters?
    var userImage: UserImage?
    
    required init(withAttributes attributes: OptionalSwiftJSONParameters) {
        super.init()
        self.count = .count =- attributes
        self.message = .message => attributes
        self.userId = .id => attributes
        let userName1 = .name => attributes
        self.userName = userName1?.uppercaseFirst
        self.messageTime = .time => attributes
        self.userImageJSON = .profilePic =&* attributes
        self.userImage = UserImage(withAttributes: self.userImageJSON ?? [:])
    }
    
    override init() {
        super.init()
    }
    
    class func changeDictionaryToUserArray(array1 : [JSON])->[Message]{
        var tempArr : [Message] = []
        for dict in array1 {
            let placeValues1 = Message(withAttributes: dict.dictionaryValue)
            tempArr.append(placeValues1)
        }
        return tempArr
    }

    
}
