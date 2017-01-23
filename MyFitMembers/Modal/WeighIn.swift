//
//  WeighIn.swift
//  MyFitMembers
//
//  Created by cbl24 on 27/10/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit
import SwiftyJSON

class WeighIn: NSObject , JSONDecodable {
    
    var weigh: String?
    var weighPicDate: String?
    var weighUnit:String?
    
    required init(withAttributes attributes: OptionalSwiftJSONParameters) {
        super.init()
        
        self.weigh = .weight => attributes
        self.weighPicDate = .createdAt => attributes
        self.weighUnit = .unit => attributes
    }
    
    override init() {
        super.init()
    }
    
    class func changeDictionaryToUserArray(array1 : [JSON])->[WeighIn]{
        var tempArr : [WeighIn] = []
        for dict in array1 {
            let placeValues = WeighIn(withAttributes: dict.dictionaryValue)
            tempArr.append(placeValues)
        }
        return tempArr
        
    }
    
}
