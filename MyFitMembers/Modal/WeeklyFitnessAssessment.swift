//
//  WeeklyFitnessAssessment.swift
//  MyFitMembers
//
//  Created by cbl24 on 28/10/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit
import SwiftyJSON

class FitnessAssesment : NSObject {
    
    var fitnessAssesment : [WeeklyFitnessAssessment]?
    var feedData : Array<Array<String>>?
    var fitnessDates : [String]?
    
    override init() {
        super.init()
    }
    
    init(attributes : OptionalSwiftJSONParameters){
        
        super.init()
        fitnessAssesment = []
        self.fitnessDates = []
        attributes?["data"]?["fitnessAssessment"].arrayValue.forEach({ (index,element) in
            self.fitnessAssesment?.append(WeeklyFitnessAssessment(withAttributes: element.dictionaryValue))
        })
        
        fitnessAssesment?.forEach({ (index, element) in
            if index == 0{
                self.feedData = Array(count: element.fitnessAssessments.count, repeatedValue: [])
                self.feedData?[index] = []
            }else{}
            element.fitnessAssessments.forEach({ (i, feed) in
                self.feedData?[i].append(feed.value ?? "")
            })
        })
        
//        self.feedData?.forEach({ (index, feed) in
//            if feed.count == 1{
//                self.feedData?[index].insertAsFirst("0")
//            }
//        })
        self.fitnessDates = Array(count: fitnessAssesment?.count ?? 0, repeatedValue: "")
        self.fitnessDates = (fitnessAssesment ?? []).map({ (assesment) -> String in
            return assesment.fitnessAssessmentDate ?? ""
        })
//        if fitnessDates?.count == 1{
//            self.fitnessDates?.insertAsFirst("0")
//        }
    }
}

class WeeklyFitnessAssessment: NSObject , JSONDecodable {
    
    var fitnessAssess:[JSON]?
    var fitnessAssessments = [WeeklyFitnessAssessmentsValue]()
    var fitnessAssessmentDate: String?
    
    required init(withAttributes attributes: OptionalSwiftJSONParameters) {
        super.init()
        
        self.fitnessAssessmentDate = .createdAt => attributes
        self.fitnessAssess = .measurements <= attributes
        
        fitnessAssess?.forEach({ [unowned self] (index, fitness) in
            let fitnessAssessmnt = WeeklyFitnessAssessmentsValue(withAttributes: fitness.dictionaryValue)
            self.fitnessAssessments.append(fitnessAssessmnt)
            })
    }
    
    override init() {
        super.init()
    }
    
    class func changeDictionaryToUserArray(array1 : [JSON])->[WeeklyFitnessAssessment]{
        var tempArr : [WeeklyFitnessAssessment] = []
        for dict in array1 {
            let placeValues = WeeklyFitnessAssessment(withAttributes: dict.dictionaryValue)
            tempArr.append(placeValues)
        }
        return tempArr
        
    }
    
}


class WeeklyFitnessAssessmentsValue: NSObject , JSONDecodable {
    
    var key: String?
    var value: String?
    
    required init(withAttributes attributes: OptionalSwiftJSONParameters) {
        super.init()
        self.key = .key => attributes
        self.value = .value => attributes
        
    }
    
    override init() {
        super.init()
    }
    
    
    
}
