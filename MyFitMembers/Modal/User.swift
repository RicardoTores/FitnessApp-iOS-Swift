//
//  RegisterPhoneNumber.swift
//  NeverMynd
//
//  Created by cbl24 on 7/8/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit
import SwiftyJSON

typealias OptionalSwiftJSONParameters = [String : JSON]?


protocol StringType {
    var get: String { get }
}

protocol IntType {
    var get: Int { get }
}

protocol ArrayType {
    var get: NSArray { get }
}



extension String: StringType { var get: String { return self } }
extension Int: IntType{var get: Int { return self }}
extension NSArray :ArrayType {var get: NSArray { return self }}

extension Optional where Wrapped: StringType {
    func unwrapString()->String{
        return self?.get ?? ""
    }
}
extension Optional where Wrapped: IntType {
    func unwrapInt()->Int{
        return self?.get ?? 0
    }
}
extension Optional where Wrapped: ArrayType {
    func unwrapArray()->NSArray{
        return self?.get ?? []
    }
}

protocol JSONDecodable {
    init(withAttributes attributes : OptionalSwiftJSONParameters) throws
}

infix operator => {associativity left precedence 160}
infix operator =| {associativity left precedence 160}
infix operator =** {associativity left precedence 160}
infix operator =- {associativity left precedence 160}
infix operator =^ {associativity left precedence 160}
infix operator <= {associativity left precedence 160}
infix operator =&* {associativity left precedence 160}


func =>(key : UserKeys, json : OptionalSwiftJSONParameters) -> String?{
    return json?[key.rawValue]?.stringValue 
}
func =**(key : UserKeys, json : OptionalSwiftJSONParameters) -> Bool?{
    return json?[key.rawValue]?.boolValue
}
func =-(key : UserKeys, json : OptionalSwiftJSONParameters) -> Int?{
    return json?[key.rawValue]?.intValue
}
func <=(key : UserKeys, json : OptionalSwiftJSONParameters) -> [JSON]?{
    return json?[key.rawValue]?.arrayValue
}
func =&*(key : UserKeys, json : OptionalSwiftJSONParameters) -> OptionalSwiftJSONParameters?{
    return json?[key.rawValue]?.dictionaryValue ?? [:]
}




prefix operator ¿ {}
prefix operator ¿? {}
prefix operator ¿?¿? {}
prefix func ¿(value : String?) -> AnyObject {
    return value.unwrapString()
}
prefix func ¿?(value : Int?) -> AnyObject {
    return value.unwrapInt()
}
prefix func ¿?¿?(value : NSArray?) -> AnyObject {
    return value.unwrapArray() 
}

enum UserKeys : String {
    case trainerName = "trainerName"
    case trainer = "trainer"
    case to = "to"
    case from = "from"
    case accessToken = "accessToken"
    case id = "id"
    case count = "count"
    case name = "name"
    case time = "time"
    case is_delete = "is_delete"
    case original = "original"
    case thumbnail = "thumbnail"
    case logo = "logo"
    case belonger = "belonger"
    case clientId = "_id"
    case client = "client"
    case broadCastAt = "broadCastAt"
    case message = "message"
    case totalWeighIn = "totalWeighIn"
    case messageCount = "messageCount"
    case totalFoodPics = "totalFoodPics"
    case totalFitnessAssessments = "totalFitnessAssessments"
    case totalMeasurements = "totalMeasurements"
    case totalLessons = "totalLessons"
    case totalSelfies = "totalSelfies"
    case pincode = "pincode"
    case firstName = "firstName"
    case lastName = "lastName"
    case age = "age"
    case address_line1 = "address_line1"
    case address_line2 = "address_line2"
    case phoneNo = "phoneNo"
    case email = "email"
    case registrationDate = "registrationDate"
    case Gym = "Gym"
    case state = "state"
    case city = "city"
    case loginAttempts = "loginAttempts"
    case lastLogin = "lastLogin"
    case profilePic = "profilePic"
    case video = "video"
    case title = "title"
    case text = "text"
    case foodType = "foodType"
    case image = "image"
    case createdAt = "createdAt"
    case weight = "weight"
    case measurements = "measurements"
    case value = "value"
    case key = "key"
    case isComplete = "isComplete"
    case isOpen = "isOpen"
    case videoLength = "videoLength"
    case questionText = "questionText"
    case hint = "hint"
    case correctAnswer = "correctAnswer"
    case questions = "questions"
    case answers = "answers"
    case unit = "unit"
    case link = "link"
}

class User: NSObject,JSONDecodable {
    
    var userAccessToken : String?
    var userId: String?
    var belonger: String?
    var isClient = false
    var name: String?
    var userImageJSON: OptionalSwiftJSONParameters?
    var userImage: UserImage?
    var trainer: String?
    var lastLogin: String?
    
    required init(withAttributes attributes: OptionalSwiftJSONParameters) {
        super.init()
        self.userAccessToken = .accessToken => attributes
        self.userId = .id => attributes
        self.belonger = .belonger => attributes
        let name1 = .name => attributes
        self.name = name1?.uppercaseFirst
        self.trainer = .trainer => attributes
        self.lastLogin = .lastLogin => attributes
        if self.belonger == "TRAINER"{
            isClient = false
        }else{
            isClient = true
        }
        self.userImageJSON = .profilePic =&* attributes
        self.userImage = UserImage(withAttributes: self.userImageJSON ?? [:])
    }
    
    override init() {
        super.init()
    }
    
}

