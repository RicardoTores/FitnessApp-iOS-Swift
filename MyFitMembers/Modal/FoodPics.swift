//
//  FoodPics.swift
//  MyFitMembers
//
//  Created by cbl24 on 10/26/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit
import SwiftyJSON

class FoodPics: NSObject , JSONDecodable {
    
    var foodType : String?
    var userImageJson: OptionalSwiftJSONParameters?
    var userImage: UserImage?
    var foodPicDate: String?
    
    required init(withAttributes attributes: OptionalSwiftJSONParameters) {
        super.init()
        self.foodType = .foodType => attributes
        self.userImageJson = .image =&* attributes
        self.userImage = UserImage(withAttributes: self.userImageJson ?? [:])
        self.foodPicDate = .createdAt => attributes
    }
    
    override init() {
        super.init()
    }
    
    class func changeDictionaryToUserArray(array1 : [JSON])->[FoodPics]{
        var tempArr : [FoodPics] = []
        for dict in array1 {
            let placeValues = FoodPics(withAttributes: dict.dictionaryValue)
            tempArr.append(placeValues)
        }
        return tempArr
        
    }
    
}
