//
//  ParameterKeys.swift
//  MyFitMembers
//
//  Created by cbl24 on 10/4/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit

enum ParameterKeys: String {
    case email = "email"
    case accountType = "accountType"
    case password = "password"
    case oldPassword = "oldPassword"
    case deviceType = "deviceType"
    case deviceToken = "deviceToken"
    case accessToken = "accessToken"
    case firstName = "firstName"
    case lastName = "lastName"
    case info = "info"
    case countryCode = "countryCode"
    case phoneNo = "phoneNo"
    case city = "city"
    case address_line1 = "address_line1"
    case address_line2 = "address_line2"
    case state = "state"
    case age = "age"
    case pincode = "pincode"
    case profilePic = "profilePic"
    case clientId = "clientId"
    case measurements = "measurements"
    case fitnessAssessment = "fitnessAssessment"
    case goal = "goal"
    case reward = "reward"
    case punishment = "punishment"
    case message = "message"
    case sendTo = "sendTo"
    case image = "image"
    case pictype = "foodType"
    case weight = "weight"
    case userId = "userId"
    case month = "month"
    case lessonId = "lessonId"
    case marks = "marks"
    case messageTime = "messageTime"
    case trainerId = "trainerId"
    case status = "Status"
    case messageId = "messageId"
    case registrationDate = "registrationDate"
    case notificationType = "notificationType"
    case unit = "unit"
}

enum AlertMessagesKeys:String {
    case invalidEmail = "Please enter valid email id"
    case invalidPassword = "Please enter valid password"
}