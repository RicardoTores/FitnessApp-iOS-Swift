//
//  BroadCastMessage.swift
//  MyFitMembers
//
//  Created by cbl24 on 11/11/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit

class BroadCastMessage: NSObject , JSONDecodable {
    
    var message : String?
    var messageId: String?
    
    required init(withAttributes attributes: OptionalSwiftJSONParameters) {
        super.init()
        self.message = .message => attributes
       self.messageId = .clientId => attributes
    }
    
    override init() {
        super.init()
    }
    
}
