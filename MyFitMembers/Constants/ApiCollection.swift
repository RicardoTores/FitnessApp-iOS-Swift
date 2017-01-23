//
//  ApiCollection.swift
//  MyFitMembers
//
//  Created by cbl24 on 10/4/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit

struct ApiCollection{
    static let baseUrl = "http://192.241.216.240:8000"
    static let apiLogin = baseUrl + "/api/admin/login"
    static let apiTrainerLogOut = baseUrl + "/api/trainer/logout"
    
    static let apiClientListing = baseUrl + "/api/trainer/clientListing"
    static let apiAddClient = baseUrl + "/api/trainer/addClient"
    static let apiAddClientMeasurement = baseUrl + "/api/trainer/addmeasurements"
    static let apiAddClientAssessment = baseUrl + "/api/trainer/addfitnessAssessment"
    static let apiClientGoals = baseUrl + "/api/trainer/clientGoals"
    static let apiDeleteClient = baseUrl + "/api/trainer/deleteClient"
    static let apiLessonListing = baseUrl + "/api/trainer/lessonListing"
    static let apiMessageBroadCastingList = baseUrl + "/api/trainer/messageBroadCastingListing"
    static let apiMessageBroadCast = baseUrl + "/api/trainer/messageBroadCasting"
    static let apiImageBaseUrl = "http://192.241.216.240/mfm/uploads/"
    static let apiClientDescription = baseUrl + "/api/trainer/appClientDescription"
    static let apiChatMessages = baseUrl + "/api/trainer/messageListing"
    static let apiChatListing = baseUrl + "/api/trainer/messages"
    static let apiSendMessage = baseUrl + "/api/trainer/sendingMessage"
    
    static let apiDeleteChat = baseUrl + "/api/trainer/deleteMessages"
    
    
    static let apiMonthlyFoodPics = baseUrl + "/api/trainer/monthlyFoodPics"
    static let apiTrainerProfile = baseUrl + "/api/trainer/myProfie"
    static let apiMonthlySelfies = baseUrl + "/api/trainer/monthlySelfies"
    static let apiWeighIn = baseUrl + "/api/trainer/weeklyweighIns"
    static let apiWeeklyFitnessAssessment = baseUrl + "/api/trainer/weeklyFitnessAssessment"
    static let apiWeeklyMeasurement = baseUrl + "/api/trainer/weeklyMeasurement"
    static let apiLessonDescription = baseUrl + "/api/trainer/lessonDescription"
    static let apiSubmitMarks =  baseUrl + "/api/trainer/lessonComplete"
    static let apiAddWeight = baseUrl + "/api/trainer/addweighIns"
    static let apiTrainerPush = baseUrl + "/api/trainer/onOffPush"
    
    static let apiTrainerDeleteAccount = baseUrl + "/api/trainer/deleteAccount"
    
    static let apiSingleBroadCastListing = baseUrl + "/api/trainer/receiveBroadCastingListing"
    static let apiSingleBroadCastRead = baseUrl + "/api/trainer/readBroadcast"
    
    static let apiSaveEditting = baseUrl + "/api/trainer/editProfile"
    
    
    static let apiUpdateDeviceToken = baseUrl + "/api/trainer/updateDeviceToken"
    static let apiTrainerChangePassword = baseUrl + "/api/trainer/changePassword"
    
    //MARK::- Client Api
    
    static let apiClientChangePassword = baseUrl + "/api/client/changePassword"
    static let apiClientAddFoodPic = baseUrl + "/api/client/addFoodPic"
    static let apiClientAddSelfie = baseUrl + "/api/client/addSelfie"
    static let apiClientAddWeighIn = baseUrl + "/api/client/addweighIns"
    static let apiClientAddFitnessAssessment = baseUrl + "/api/client/addfitnessAssessment"
    static let apiClientAddMeasurement = baseUrl + "/api/client/addmeasurements"
    static let apiClientProfile = baseUrl + "/api/client/appMyProfie"
    static let apiMonthlyClientFoodPics = baseUrl + "/api/client/monthlyFoodPics"
    static let apiWeeklyWeighInsOfClient = baseUrl + "/api/client/weeklyweighIns"
    
    static let apiWeeklyAssessmentOfClient = baseUrl + "/api/client/weeklyFitnessAssessment"
    static let apiWeeklyMeasurementOfClient = baseUrl + "/api/client/weeklyMeasurement"
    
    static let apiClientMonthlySelfie = baseUrl + "/api/client/monthlySelfies"
    static let apiClientAddMeasurementByClient = baseUrl + "/api/client/addmeasurements"
    static let apiClientAddAssessmentByClient = baseUrl + "/api/client/addfitnessAssessment"
    static let apiLessonListingOfClient = baseUrl + "/api/client/lessonListing"
    static let apiClientLessonDescription = baseUrl + "/api/client/lessonDescription"
    static let apiClientSubmitMarks = baseUrl + "/api/client/lessonComplete"
    static let apiClientChatMessages = baseUrl + "/api/client/messageListing"
    static let apiClientSendMessage = baseUrl + "/api/client/sendingMessage"
    static let apiClientLogOut = baseUrl + "/api/client/logout"
    static let apiClientPush = baseUrl + "/api/client/onOffPush"
    static let apiClientDeleteAccount = baseUrl + "/api/client/deleteAccount"
    static let apiClientGetBroadCastMessage = baseUrl + "/api/client/receiveBroadCastingListing"
    static let apiClientRemoveBanner = baseUrl + "/api/client/readBroadcast"
    static let apiClientSaveEditting = baseUrl + "/api/client/editAppProfile"
    static let apiClientUpdateDeviceToken = baseUrl + "/api/client/updateDeviceToken"
    
    
    
    static let apiFoodNutrition = baseUrl + "/api/client/getNutrition"
}

internal struct ApiParameters {
    
    struct ApisPar {
        
        static let login =
            [
                ParameterKeys.email.rawValue,
                ParameterKeys.password.rawValue,
                ParameterKeys.deviceType.rawValue,
                //                ParameterKeys.deviceToken.rawValue,
        ]
        
        static let apiClientListing = [
            ParameterKeys.accessToken.rawValue
        ]
        
        static let apiAddClient = [
            ParameterKeys.accessToken.rawValue,
            ParameterKeys.firstName.rawValue,
            ParameterKeys.lastName.rawValue,
            ParameterKeys.info.rawValue,
            ParameterKeys.countryCode.rawValue,
            ParameterKeys.phoneNo.rawValue,
            ParameterKeys.email.rawValue,
            ParameterKeys.address_line1.rawValue,
            ParameterKeys.city.rawValue,
            ParameterKeys.state.rawValue,
            ParameterKeys.pincode.rawValue,
            ParameterKeys.age.rawValue
        ]
        
        static let apiAddClientMeasurement = [
            ParameterKeys.accessToken.rawValue,
            ParameterKeys.clientId.rawValue,
            ParameterKeys.measurements.rawValue
        ]
        
        static let apiAddClientFitnessAssessment = [
            ParameterKeys.accessToken.rawValue,
            ParameterKeys.clientId.rawValue,
            ParameterKeys.fitnessAssessment.rawValue
        ]
        
        static let apilientGoals = [
            ParameterKeys.accessToken.rawValue,
            ParameterKeys.clientId.rawValue,
            ParameterKeys.goal.rawValue,
            ParameterKeys.reward.rawValue,
            ParameterKeys.punishment.rawValue
        ]
        
        static let apiDeleteClient = [
            ParameterKeys.accessToken.rawValue,
            ParameterKeys.clientId.rawValue
        ]
        
        static let apiLessonListing = [
            ParameterKeys.accessToken.rawValue
        ]
        
        static let apiBroadCastMessage = [
            ParameterKeys.accessToken.rawValue,
            ParameterKeys.message.rawValue,
            ParameterKeys.sendTo.rawValue
        ]
        
        static let apiClientAddFoodPic = [
            ParameterKeys.accessToken.rawValue,
            ParameterKeys.pictype.rawValue
        ]
        
        static let apiClientChangePassword = [
            ParameterKeys.accessToken.rawValue,
            ParameterKeys.password.rawValue,
            ParameterKeys.oldPassword.rawValue,
            
            ]
        
        
        static let AddClientWeighIn = [
            ParameterKeys.accessToken.rawValue,
            ParameterKeys.weight.rawValue ,
            ParameterKeys.unit.rawValue
        ]
        
        static let TrainerMessagesListing = [
            ParameterKeys.accessToken.rawValue,
            ParameterKeys.userId.rawValue
        ]
        
        static let ClientMessagesListing = [
            ParameterKeys.accessToken.rawValue,
            ParameterKeys.trainerId.rawValue
        ]
        
        
        static let MonthlyFoodPics = [
            ParameterKeys.accessToken.rawValue,
            ParameterKeys.clientId.rawValue,
            ParameterKeys.month.rawValue
        ]
        
        
        static let Quiz = [
            ParameterKeys.accessToken.rawValue,
            ParameterKeys.lessonId.rawValue
        ]
        
        static let SubmitMarks = [
            ParameterKeys.accessToken.rawValue,
            ParameterKeys.lessonId.rawValue ,
            ParameterKeys.marks.rawValue
        ]
        
        static let SendMessage = [
            ParameterKeys.accessToken.rawValue,
            ParameterKeys.userId.rawValue ,
            ParameterKeys.message.rawValue
        ]
        
        static let PollMessages = [
            ParameterKeys.accessToken.rawValue,
            ParameterKeys.userId.rawValue ,
            ParameterKeys.messageTime.rawValue
        ]
        
        static let AddWeight = [
            ParameterKeys.accessToken.rawValue,
            ParameterKeys.clientId.rawValue ,
            ParameterKeys.weight.rawValue ,
            ParameterKeys.unit.rawValue
        ]
        
        
        static let ClientMonthlyFoodPics = [
            ParameterKeys.accessToken.rawValue,
            ParameterKeys.month.rawValue
        ]
        
        static let AddClientFitnessAssessmentByClient = [
            ParameterKeys.accessToken.rawValue,
            ParameterKeys.fitnessAssessment.rawValue
        ]
        
        static let AddClientMeasurementByClient = [
            ParameterKeys.accessToken.rawValue,
            ParameterKeys.measurements.rawValue
        ]
        
        static let ClientSendMessage = [
            ParameterKeys.accessToken.rawValue,
            ParameterKeys.trainerId.rawValue ,
            ParameterKeys.message.rawValue
        ]
        
        static let ClientPollMessages = [
            ParameterKeys.accessToken.rawValue,
            ParameterKeys.trainerId.rawValue ,
            ParameterKeys.messageTime.rawValue
        ]
        
        static let push = [
            ParameterKeys.accessToken.rawValue,
            ParameterKeys.status.rawValue ,
            
            ]
        
        static let ClientPush = [
            ParameterKeys.accessToken.rawValue,
            ParameterKeys.status.rawValue ,
            ParameterKeys.notificationType.rawValue
        ]
        
        static let BroadCastRead = [
            ParameterKeys.accessToken.rawValue,
            ParameterKeys.messageId.rawValue
        ]
        
        
        static let editClient = [
            ParameterKeys.accessToken.rawValue,
            ParameterKeys.firstName.rawValue,
            ParameterKeys.lastName.rawValue,
            ParameterKeys.phoneNo.rawValue,
            ParameterKeys.countryCode.rawValue,
            ParameterKeys.address_line1.rawValue,
            ParameterKeys.email.rawValue,
            ParameterKeys.pincode.rawValue,
            ParameterKeys.state.rawValue,
            ParameterKeys.city.rawValue,
            ]
        
        
        static let UpdateDeviceToken = [
            ParameterKeys.accessToken.rawValue,
            ParameterKeys.deviceType.rawValue,
            ParameterKeys.deviceToken.rawValue
        ]
        
        
        static let FoodNutrition = [
            ParameterKeys.accessToken.rawValue,
            ParameterKeys.accountType.rawValue,
            
            ]
        
        static let DeleteChat = [
            ParameterKeys.accessToken.rawValue,
            ParameterKeys.clientId.rawValue,
            
            ]
        
    }
    
    
}