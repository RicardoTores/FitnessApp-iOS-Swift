//
//  ClientAddedDetail.swift
//  MyFitMembers
//
//  Created by cbl24 on 10/21/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit

class ClientAddedDetail: NSObject , JSONDecodable {
    
    var clientId : String?
    
    required init(withAttributes attributes: OptionalSwiftJSONParameters) {
        super.init()
        self.clientId = .id => attributes
    }
    
    override init() {
        super.init()
    }
    
}
