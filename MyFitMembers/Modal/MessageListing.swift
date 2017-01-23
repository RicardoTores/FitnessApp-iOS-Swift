//
//  MessageListing.swift
//  MyFitMembers
//
//  Created by cbl24 on 03/11/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit
import SwiftyJSON

class MessageListing: NSObject , JSONDecodable {
    
    var message: String?
    var messageFrom: String?
    var messageTo: String?
    var messageCreatedAt : String?
//    var messageId: String?
    
    required init(withAttributes attributes: OptionalSwiftJSONParameters) {
        super.init()
        self.message = .message => attributes
        self.messageFrom = .from => attributes
        self.messageTo = .to => attributes
        self.messageCreatedAt = .createdAt => attributes
//        self.messageId = .belonger => attributes
        
    }
    
    override init() {
        super.init()
    }
    
    class func changeDictionaryToUserArray(array1 : [JSON])->[MessageListing]{
        var tempArr : [MessageListing] = []
        for dict in array1 {
            let placeValues1 = MessageListing(withAttributes: dict.dictionaryValue)
            tempArr.append(placeValues1)
        }
        return tempArr
    }
}
