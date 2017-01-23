//
//  LessonDescription.swift
//  MyFitMembers
//
//  Created by cbl24 on 02/11/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit
import SwiftyJSON

class LessonDescription: NSObject , JSONDecodable {
    
    var lessonId : String?
    var lessonVideoLength: String?
    var lessonDescription: String?
    var lessonName: String?
    var userImageJSON: OptionalSwiftJSONParameters?
    var video: Video?
    var lessonQuestions: [JSON]?
    var lessonQuest:[QuizQuestions]?
//    var lessonVideo : String?
    
    required init(withAttributes attributes: OptionalSwiftJSONParameters) {
        super.init()
        self.lessonId  = .clientId => attributes
//        self.lessonVideo  = .video => attributes
        self.lessonVideoLength = .videoLength => attributes
        self.lessonDescription = .text => attributes
        self.lessonName = .title => attributes
        self.userImageJSON = .video =&* attributes
        self.video = Video(withAttributes: self.userImageJSON ?? [:])
        self.lessonQuestions = .questions <= attributes
        self.lessonQuest = QuizQuestions.changeDictionaryToUserArray(self.lessonQuestions ?? [])
    }
    
    override init() {
        super.init()
    }
    
}

class Video: NSObject , JSONDecodable{
    
    var videoLink: String?
    
    
    required init(withAttributes attributes: OptionalSwiftJSONParameters) {
        super.init()
        self.videoLink = .original => attributes
    }
    
    override init() {
        super.init()
    }
    
}

class QuizQuestions: NSObject , JSONDecodable{
    
    var questionId: String?
    var questionText: String?
    var hint: String?
    var lessonAnswers: [JSON]?
    var lessonAns:[QuizAnswers]?
    var optionSelected: Int?
    
    required init(withAttributes attributes: OptionalSwiftJSONParameters) {
        super.init()
        
        self.questionId = .clientId => attributes
        self.questionText = .questionText => attributes
        self.hint = .hint => attributes
        self.lessonAnswers = .answers <= attributes
        self.optionSelected = 0
        self.lessonAns = QuizAnswers.changeDictionaryToUserArray(self.lessonAnswers ?? [])
    }
    
    override init() {
        super.init()
    }
    
    class func changeDictionaryToUserArray(array1 : [JSON])->[QuizQuestions]{
        var tempArr : [QuizQuestions] = []
        for dict in array1 {
            let placeValues1 = QuizQuestions(withAttributes: dict.dictionaryValue)
            tempArr.append(placeValues1)
        }
        return tempArr
    }
}

class QuizAnswers: NSObject , JSONDecodable{
    
    var answer: String?
    var isCorrect: String?
    
    required init(withAttributes attributes: OptionalSwiftJSONParameters) {
        super.init()
        self.isCorrect = .correctAnswer => attributes
        self.answer = .text => attributes
        
    }
    
    override init() {
        super.init()
    }
    
    class func changeDictionaryToUserArray(array1 : [JSON])->[QuizAnswers]{
        var tempArr : [QuizAnswers] = []
        for dict in array1 {
            let placeValues1 = QuizAnswers(withAttributes: dict.dictionaryValue)
            tempArr.append(placeValues1)
        }
        return tempArr
    }
}

