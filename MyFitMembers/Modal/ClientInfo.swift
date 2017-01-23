//
//  ClientInfo.swift
//  MyFitMembers
//
//  Created by cbl24 on 10/25/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit

class ClientInfo: NSObject , JSONDecodable {
    
    var clientId : String?
    var totalWeighIn: Int?
    var messageCount: Int?
    var totalFoodPics: Int?
    var totalFitnesAssessments: Int?
    var totalMeasurements: Int?
    var totalLessons: Int?
    var totalSelfies: Int?
    
    
    required init(withAttributes attributes: OptionalSwiftJSONParameters) {
        super.init()
        self.clientId = .clientId => attributes
        self.totalWeighIn = .totalWeighIn =- attributes
        self.messageCount = .messageCount =- attributes
        self.totalFoodPics = .totalFoodPics =- attributes
        self.totalFitnesAssessments = .totalFitnessAssessments =- attributes
        self.totalMeasurements = .totalMeasurements =- attributes
        self.totalLessons = .totalLessons =- attributes
        self.totalSelfies = .totalSelfies =- attributes
    }
    
    override init() {
        super.init()
    }
    
}
