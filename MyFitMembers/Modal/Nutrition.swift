//
//  Nutrition.swift
//  MyFitMembers
//
//  Created by cbl24 on 01/12/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit
import SwiftyJSON

class Nutrition: NSObject  , JSONDecodable {
    
    var name: String?
    var link: String?
    
    required init(withAttributes attributes: OptionalSwiftJSONParameters) {
        super.init()
        self.name = .name => attributes
        self.link = .link => attributes
    }
    
    override init() {
        super.init()
    }
    
    class func changeDictionaryToUserArray(array1 : [JSON])->[Nutrition]{
        var tempArr : [Nutrition] = []
        for dict in array1 {
            let nutrition = Nutrition(withAttributes: dict.dictionaryValue)
            tempArr.append(nutrition)
        }
        return tempArr
    }
}
