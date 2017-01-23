//
//  FoodPics.swift
//  MyFitMembers
//
//  Created by cbl24 on 10/26/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit
import SwiftyJSON

class Selfie: NSObject , JSONDecodable {
    
    
    var userImageJson: OptionalSwiftJSONParameters?
    var userImage: UserImage?
    var selfiePicDate: String?
    
    required init(withAttributes attributes: OptionalSwiftJSONParameters) {
        super.init()
        
        self.userImageJson = .image =&* attributes
        self.userImage = UserImage(withAttributes: self.userImageJson ?? [:])
        self.selfiePicDate = .createdAt => attributes
    }
    
    override init() {
        super.init()
    }
    
    class func changeDictionaryToUserArray(array1 : [JSON])->[Selfie]{
        var tempArr : [Selfie] = []
        for dict in array1 {
            let placeValues = Selfie(withAttributes: dict.dictionaryValue)
            tempArr.append(placeValues)
        }
        return tempArr
        
    }
    
}
