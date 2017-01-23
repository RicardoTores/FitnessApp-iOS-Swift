//
//  WeeklyFitnessAssessment.swift
//  MyFitMembers
//
//  Created by cbl24 on 28/10/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit
import SwiftyJSON

class FitnessAssesment1 : NSObject {
    
    var fitnessAssesment1 : [WeeklyFitnessAssessment1]?
    var feedData1 : Array<Array<String>>?
    var fitnessDates1 : [String]?
    
    override init() {
        super.init()
    }
    
    init(attributes : OptionalSwiftJSONParameters){
        
        super.init()
        fitnessAssesment1 = []
        self.fitnessDates1 = []
        attributes?["data"]?["measurements"].arrayValue.forEach({ (index,element) in
            self.fitnessAssesment1?.append(WeeklyFitnessAssessment1(withAttributes: element.dictionaryValue))
        })
        
        fitnessAssesment1?.forEach({ (index, element) in
            if index == 0{
                self.feedData1 = Array(count: element.fitnessAssessments1.count, repeatedValue: [])
                self.feedData1?[index] = []
            }else{}
            
            element.fitnessAssessments1.forEach({ (i, feed) in
                
                self.feedData1?[i].append(feed.value ?? "")
                print(self.feedData1)
            })
            
        })
        
        print(feedData1)
        
//        self.feedData1?.forEach({ (index, feed) in
//            if self.feedData1?[index].count == 1{
//                self.feedData1?[index].insertAsFirst("0")
//            }
//        })
        
        
        self.fitnessDates1 = Array(count: fitnessAssesment1?.count ?? 0, repeatedValue: "")
        self.fitnessDates1 = (fitnessAssesment1 ?? []).map({ (assesment) -> String in
            return assesment.fitnessAssessmentDate1 ?? ""
        })
//        if fitnessDates1?.count == 1{
//            self.fitnessDates1?.insertAsFirst("0")
//        }
    }
}

class WeeklyFitnessAssessment1: NSObject , JSONDecodable {
    
    var fitnessAssess1:[JSON]?
    var fitnessAssessments1 = [WeeklyFitnessAssessmentsValue1]()
    var fitnessAssessmentDate1: String?
    
    required init(withAttributes attributes: OptionalSwiftJSONParameters) {
        super.init()
        
        self.fitnessAssessmentDate1 = .createdAt => attributes
        self.fitnessAssess1 = .measurements <= attributes
        
        fitnessAssess1?.forEach({ [unowned self] (index, fitness) in
            let fitnessAssessmnt1 = WeeklyFitnessAssessmentsValue1(withAttributes: fitness.dictionaryValue)
            self.fitnessAssessments1.append(fitnessAssessmnt1)
            })
    }
    
    override init() {
        super.init()
    }
    
    class func changeDictionaryToUserArray(array1 : [JSON])->[WeeklyFitnessAssessment1]{
        var tempArr : [WeeklyFitnessAssessment1] = []
        for dict in array1 {
            let placeValues1 = WeeklyFitnessAssessment1(withAttributes: dict.dictionaryValue)
            tempArr.append(placeValues1)
        }
        return tempArr
        
    }
    
}


class WeeklyFitnessAssessmentsValue1: NSObject , JSONDecodable {
    
    var key: String?
    var value: String?
    var unit:String?
    
    required init(withAttributes attributes: OptionalSwiftJSONParameters) {
        super.init()
        
        self.key = .key => attributes
        self.value = .value => attributes
        self.unit = .unit => attributes
        
    }
    
    override init() {
        super.init()
    }
    
    
    
}
