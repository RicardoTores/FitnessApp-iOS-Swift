//
//  Lesson.swift
//  MyFitMembers
//
//  Created by cbl24 on 10/22/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit
import SwiftyJSON

class Lesson: NSObject, JSONDecodable {
    
    var lessonId: String?
    var lessonName: String?
    var lessonDescription: String?
    var lessonLength: String?
    var isExpanded = false
    var videoImageJson: OptionalSwiftJSONParameters?
    var videoImg: UserImage?
    var isComplete: Int?
    var isOpen: Int?
    var videoLength: String?
    var state : Bool?
    var video: Video?
    var userImageJSON: OptionalSwiftJSONParameters?
    var clientsJSON: [JSON]?
    var client:[LessonDone]?
    
    
    required init(withAttributes attributes: OptionalSwiftJSONParameters) {
        super.init()
        self.lessonId = .id => attributes
        self.isComplete = .isComplete =- attributes
        self.isOpen = .isOpen =- attributes
        self.lessonName = .title => attributes
        self.lessonDescription = .text => attributes
        self.videoImageJson = .video =&* attributes
        self.videoImg = UserImage(withAttributes: self.videoImageJson ?? [:])
        self.videoLength = .videoLength => attributes
        self.userImageJSON = .video =&* attributes
        self.video = Video(withAttributes: self.userImageJSON ?? [:])
        self.clientsJSON = .client <= attributes
        self.client = LessonDone.changeDictionaryToArray(self.clientsJSON ?? [])
        self.state = false
    }
    
    override init() {
        super.init()
    }
    
    class func changeDictionaryToUserArray(array1 : [JSON])->[Lesson]{
        var tempArr : [Lesson] = []
        for dict in array1 {
            let placeValues = Lesson(withAttributes: dict.dictionaryValue)
            tempArr.append(placeValues)
        }
        return tempArr
        
    }
}


class LessonDone: NSObject , JSONDecodable {
    
    var userImageJson: OptionalSwiftJSONParameters?
    var userImage: UserImage?
    var id : String?
    
    
    required init(withAttributes attributes: OptionalSwiftJSONParameters) {
        super.init()
        self.userImageJson = .profilePic =&* attributes
        self.userImage = UserImage(withAttributes: self.userImageJson ?? [:])
        self.id = .clientId => attributes
    }
    
    override init() {
        super.init()
    }
    
    class func changeDictionaryToArray(array1 : [JSON])->[LessonDone]{
        var tempArr : [LessonDone] = []
        for dict in array1 {
            let placeValues = LessonDone(withAttributes: dict.dictionaryValue)
            tempArr.append(placeValues)
        }
        return tempArr
        
    }


    
}

