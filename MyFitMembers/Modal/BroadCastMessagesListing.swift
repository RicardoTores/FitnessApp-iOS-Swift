//
//  BroadCastMessagesListing.swift
//  MyFitMembers
//
//  Created by cbl24 on 10/22/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit
import SwiftyJSON

class BroadCastMessagesListing: NSObject , JSONDecodable {
    
    var messageId: String?
    var messageTyme: String?
    var message:String?
    
    required init(withAttributes attributes: OptionalSwiftJSONParameters) {
        super.init()
        self.messageId = .clientId => attributes
        self.messageTyme = .broadCastAt => attributes
        self.message = .message => attributes
    }
    
    override init() {
        super.init()
    }
    
    class func changeDictionaryToUserArray(array1 : [JSON])->[BroadCastMessagesListing]{
        var tempArr : [BroadCastMessagesListing] = []
        for dict in array1 {
            let placeValues = BroadCastMessagesListing(withAttributes: dict.dictionaryValue)
            tempArr.append(placeValues)
        }
        return tempArr
        
    }
}