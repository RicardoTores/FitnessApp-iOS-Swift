//
//  ClientListing.swift
//  MyFitMembers
//
//  Created by cbl24 on 10/4/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit
import SwiftyJSON

class ClientListing: NSObject, JSONDecodable {
    
    var userId: String?
    var userName: String?
    var userImageJSON: OptionalSwiftJSONParameters?
//    var userIsDelete: Bool?
    var userImage: UserImage?
    
    
    required init(withAttributes attributes: OptionalSwiftJSONParameters) {
        super.init()
        self.userId = .id => attributes
        self.userName = .name => attributes
//        self.userIsDelete = .is_delete =** attributes
        self.userImageJSON = .logo =&* attributes
        self.userImage = UserImage(withAttributes: self.userImageJSON ?? [:])
    }
    
    override init() {
        super.init()
    }
    
    class func changeDictionaryToUserArray(array1 : [JSON])->[ClientListing]{
        var tempArr : [ClientListing] = []
        for dict in array1 {
            let placeValues = ClientListing(withAttributes: dict.dictionaryValue)
            tempArr.append(placeValues)
        }
        return tempArr
        
    }
}

class UserImage: NSObject, JSONDecodable{
    
    var userThumbnailImage : String?
    var userOriginalImage: String?
    
    
    required init(withAttributes attributes: OptionalSwiftJSONParameters) {
        super.init()
        self.userThumbnailImage = .thumbnail => attributes
        self.userOriginalImage = .original => attributes
    }
    
    override init() {
        super.init()
    }
    
}
