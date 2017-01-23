//
//  ApiDetector.swift
//  NeverMynd
//
//  Created by cbl24 on 7/7/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit
import SwiftyJSON
import EZSwiftExtensions

typealias OptionalDictionary = [String : AnyObject]?

var unReadMessages = 0

class ApiDetector: NSObject {
    static var  val: AnyObject?
    class func getDataOfURL(url: String, dictForBackend: OptionalDictionary, failure: (AnyObject) ->(), success:(AnyObject)->(), method: ApiMethod, viewControl: UIViewController, pic: UIImage? , placeHolderImageName: String? ,headers:[String:String] , showLoader:Bool , loaderColor: UIColor){
        
        if isConnectedToNetwork(){
            
            let loader = Loader(frame: viewControl.view.frame)
            loader.indicator.color = loaderColor
            if showLoader{
                viewControl.view.addSubview(loader)
            }else{
                
            }
            
            guard let imgPlaceHoldername = placeHolderImageName else {return}
            
            
            ApiManager.callApiWithParameters(url, withParameters: dictForBackend ?? [:], success: { (data) in
                let jsonData = JSON(data)
                
                loader.removeFromSuperview()
                if jsonData["statusCode"].intValue == 200 || jsonData["statusCode"].intValue == 201 {
                    
                    
                    switch(url){
                    case ApiCollection.apiLogin:
                       
                        val =  User(withAttributes: jsonData["data"].dictionaryValue)
                        
                    case ApiCollection.apiClientListing:
                        print(jsonData)
                        val =  ClientListing.changeDictionaryToUserArray(jsonData["data"].arrayValue)
                        break
                        
                    case ApiCollection.apiAddClient:
                    
                        val = ClientAddedDetail(withAttributes: jsonData["data"].dictionaryValue)
                        
                    case ApiCollection.apiMessageBroadCastingList:
                        val = BroadCastMessagesListing.changeDictionaryToUserArray(jsonData["data"].arrayValue)
                        
                    case ApiCollection.apiClientDescription:
                        val = ClientInfo(withAttributes: jsonData["data"].dictionaryValue)
                        
                    case ApiCollection.apiClientProfile:
                       
                        val = ClientPersonalInfo(withAttributes: jsonData["data"].dictionaryValue)
                        
                    case ApiCollection.apiTrainerProfile:
                        val = TrainerProfile(withAttributes: jsonData["data"].dictionaryValue)
                        
                    case ApiCollection.apiLessonListing , ApiCollection.apiLessonListingOfClient:
                        print(jsonData)
                        val = Lesson.changeDictionaryToUserArray(jsonData["data"].arrayValue)
                        
                    case ApiCollection.apiMonthlyFoodPics , ApiCollection.apiMonthlyClientFoodPics:
                        print(jsonData["data"].arrayValue)
                        let foodPic = jsonData["data"].dictionaryValue
                        val = FoodPics.changeDictionaryToUserArray(foodPic["foodPics"]?.arrayValue ?? [])
                        
                    case ApiCollection.apiMonthlySelfies , ApiCollection.apiClientMonthlySelfie:
                        let selfiePic = jsonData["data"].dictionaryValue
                        val = Selfie.changeDictionaryToUserArray(selfiePic["selfies"]?.arrayValue ?? [])
                        
                    case ApiCollection.apiWeighIn , ApiCollection.apiWeeklyWeighInsOfClient:
                        //                        print(jsonData)
                        let weighIns = jsonData["data"].dictionaryValue
                        val = WeighIn.changeDictionaryToUserArray(weighIns["weighIns"]?.arrayValue ?? [])
                        
                    case ApiCollection.apiWeeklyFitnessAssessment , ApiCollection.apiWeeklyAssessmentOfClient:
                        //                        print(jsonData)
                        
                        val = FitnessAssesment(attributes: jsonData.dictionaryValue)
                        
                    case ApiCollection.apiWeeklyMeasurement , ApiCollection.apiWeeklyMeasurementOfClient:
                        //                        print(jsonData)
                        
                        val = FitnessAssesment1(attributes: jsonData.dictionaryValue)
                        
                        
                    case ApiCollection.apiLessonDescription , ApiCollection.apiClientLessonDescription:
                                                print(jsonData)
                        let arrayVal = jsonData["data"].arrayValue
                        let dictValue = arrayVal[0].dictionaryValue
                        val = LessonDescription(withAttributes: dictValue)
                        
                    case ApiCollection.apiChatMessages:
                        //                        print(jsonData)
                        val = MessageListing.changeDictionaryToUserArray(jsonData["data"].arrayValue ?? [])
                    //                        print(val)
                    case ApiCollection.apiClientChatMessages:
                        let jsonDat = jsonData["data"].dictionaryValue
                        let arrayOfMessages = jsonDat["message"]?.arrayValue
                        val = MessageListing.changeDictionaryToUserArray(jsonDat["message"]?.arrayValue ?? [])
                        let trainerInfoForChat = TrainerInfo(withAttributes: jsonDat["trainerInfo"]?.dictionaryValue ?? [:])
                        //                        print(trainerInfoForChat.trainerName)
                        NSUserDefaults.standardUserDefaults().rm_setCustomObject(trainerInfoForChat, forKey: "TrainerChatInfo")
                        
                    case ApiCollection.apiChatListing:
                        
                        //                        print(jsonData)
                        val = Message.changeDictionaryToUserArray(jsonData["data"].arrayValue ?? [])
                        
                    case ApiCollection.apiSingleBroadCastListing , ApiCollection.apiClientGetBroadCastMessage:
                        
                        let broadCastMessage = jsonData["data"].dictionaryValue
                        let messageCount = broadCastMessage["count"]?.intValue
                        print(messageCount)
                        unReadMessages = messageCount ?? 0
                        val = BroadCastMessage(withAttributes: broadCastMessage["messages"]?.dictionaryValue ?? [:])
                      
                    case ApiCollection.apiSaveEditting:
                        
                        print(jsonData)
                    case ApiCollection.apiFoodNutrition:
                        
                        val = Nutrition.changeDictionaryToUserArray(jsonData["data"].arrayValue ?? [])
                        
                        
                    default:
                        print("Api is not present in apiCollection")
                    }
                    success(val ?? "")
                }else if jsonData["statusCode"].intValue == 401{
                    print(jsonData["message"])
                    guard let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate else { return }
                    appDelegate.logOut()
                    
                }else if jsonData["statusCode"] == 500{
                    print(url)
                    let message = jsonData["message"].stringValue
                    AlertView.callAlertView("", msg: message, btnMsg: "OK", vc: viewControl)
                    print(jsonData["message"])
                }else{
                    let message = jsonData["message"].stringValue
                    AlertView.callAlertView("", msg: message, btnMsg: "OK", vc: viewControl)
                    print(jsonData["message"])
                }
                }, failure: { (error) in
                    print(url)
                    loader.removeFromSuperview()
                    let message = error.localizedDescription
                    AlertView.callAlertView("", msg: message, btnMsg: "OK", vc: viewControl)
                    failure(error)
                }, method: method , img: pic, imageParamater: imgPlaceHoldername ,headers:headers)
            
        }else{
            if url == ApiCollection.apiChatMessages || url == ApiCollection.apiUpdateDeviceToken || url == ApiCollection.apiClientUpdateDeviceToken{
                
            }else{
                AlertView.callAlertView("", msg: "Please check your internet connection", btnMsg: "OK", vc: viewControl)
            }
            
            
        }
        
        
        
        
    }
    
    
}



var deviceToken: String?
enum API {
    
    static func mapKeysAndValues(keys : [String]?,values : [AnyObject]?) -> [String : AnyObject]?{
        guard let tempValues = values,tempKeys = keys else { return nil}
        var dictForBackEnd = [String : AnyObject]()
        for (key,value) in zip(tempKeys,tempValues) {
            if value is String{
                guard let stringValue = value as? String else {return [:]}
                dictForBackEnd[key] = ¿stringValue ?? ""
            }else if value is Int{
                guard let intValue = value as? Int else {return [:]}
                dictForBackEnd[key] = ¿?intValue ?? 0
            }else if value is NSArray{
                guard let dictValue = value as? NSArray else {return [:]}
                dictForBackEnd[key] = ¿?¿?dictValue ?? 0
            }else{
                
            }
            
        }
        return dictForBackEnd
    }
    
    
    
    enum ApiCreateDictionary{
        case Login(email : String? , password : String?)
        case ClientListing()
        case ClientInfo(firstName:String?, lastName:String?,info:String? , countryCode: String? , phoneNumber:String? , email: String? , addressLine:String? , city:String? , state:String , pinCode:String? , age: String? )
        case AddClientMeasurement(clientId:String , measurements: String?)
        case AddClientFitnessAssessment(clientId:String , measurements: String?)
        case ClientGoals(clientId:String, goal:String , reward:String , punishment:String)
        case DeleteClient(clientId:String)
        case LessonListing()
        case BroadCastListing()
        case BroadCastMessage(message:String)
        case AddFoodPicByClient(picType:String)
        case ClientDescription(clientId:String)
        case TrainerMessagesListing(userId:String)
        case MonthlyFoodPics(clientId: String, month: String)
        case GetQuiz(lessonId: String)
        case SubmitMarks(lessonId: String  , marks: String)
        case SendMessage(otherUserId:String , message: String)
        case PollMessages(otherUserId: String , messageTime: String)
        case AddWeight(clientId: String , weight: String , unit: String)
        case OnOffPush(status: String)
        case OnOffPushClient(status: String , notificationType:String)
        case ReadBroadCast(messageId:String)
        case EditDetails(firstName:String , lastName:String , phoneNumber: String , countryCode: String , address: String  , email: String , pinCode: String ,  state: String ,  city: String)
        case UpdateDeviceToken(deviceToken:String)
        case DeleteChat(clientId:String)
        
        
        case ChangePassword(password : String , oldPassword: String)
        case ClientAddSelfie()
        case ClientAddWeighIn(weight:String , unit: String)
        case ClientMonthlyFoodPics(month: String)
        case ClientAddFitnessAssessment(assessments: String)
        case ClientAddFitnessMeasurements(measurements: String)
        case ClientMessagesListing(userId:String)
        case CliemtSendMessage(otherUserId:String , message: String)
        case ClientPollMessages(otherUserId: String , messageTime: String)
        
        case FoodNutrition(type:String)
        
        func formatParameters() -> OptionalDictionary {
            
            switch self {
                
            case .Login(let email , let password):
                let arrayAnyObj:[AnyObject]? = [¿email , ¿password , "IOS"]
                return API.mapKeysAndValues(ApiParameters.ApisPar.login , values: arrayAnyObj )
                
            case .ClientListing():
                guard let accessToken = UserDataSingleton.sharedInstance.loggedInUser?.userAccessToken else {return [:]}
                let arrayAnyObj:
                    [AnyObject]? = [accessToken]
                return API.mapKeysAndValues(ApiParameters.ApisPar.apiClientListing , values: arrayAnyObj )
                
            case .ClientInfo(let firstName,let  lastName,let info , let  countryCode , let phoneNumber , let  email,let  addressLine, let city ,let  state , let pinCode , let age):
                
                guard let accessToken = UserDataSingleton.sharedInstance.loggedInUser?.userAccessToken else {return [:]}
                let arrayAnyObj:[AnyObject]? = [accessToken , ¿firstName , ¿lastName , ¿info, ¿countryCode, ¿phoneNumber ,¿email ,¿addressLine   ,¿city ,¿state ,¿pinCode , ¿age]
                return API.mapKeysAndValues(ApiParameters.ApisPar.apiAddClient, values: arrayAnyObj)
                
            case .AddClientMeasurement(let clientId , let measurements):
                guard let accessToken = UserDataSingleton.sharedInstance.loggedInUser?.userAccessToken else {return [:]}
                let arrayAnyObj:[AnyObject]? = [accessToken, ¿clientId , ¿measurements ]
                return API.mapKeysAndValues(ApiParameters.ApisPar.apiAddClientMeasurement , values: arrayAnyObj )
                
            case .AddClientFitnessAssessment(let clientId , let measurements):
                guard let accessToken = UserDataSingleton.sharedInstance.loggedInUser?.userAccessToken else {return [:]}
                let arrayAnyObj:[AnyObject]? = [accessToken, ¿clientId , ¿measurements ]
                return API.mapKeysAndValues(ApiParameters.ApisPar.apiAddClientFitnessAssessment , values: arrayAnyObj )
                
            case .ClientGoals( let clientId, let goal , let reward , let punishment):
                guard let accessToken = UserDataSingleton.sharedInstance.loggedInUser?.userAccessToken else {return [:]}
                let arrayAnyObj:[AnyObject]? = [accessToken, ¿clientId , ¿goal, ¿reward, ¿punishment ]
                return API.mapKeysAndValues(ApiParameters.ApisPar.apilientGoals , values: arrayAnyObj )
                
            case .DeleteClient(let clientId):
                guard let accessToken = UserDataSingleton.sharedInstance.loggedInUser?.userAccessToken else {return [:]}
                let arrayAnyObj:[AnyObject]? = [accessToken, ¿clientId ]
                return API.mapKeysAndValues(ApiParameters.ApisPar.apiDeleteClient , values: arrayAnyObj )
                
            case .LessonListing():
                guard let accessToken = UserDataSingleton.sharedInstance.loggedInUser?.userAccessToken else {return [:]}
                let arrayAnyObj:[AnyObject]? = [accessToken ]
                return API.mapKeysAndValues(ApiParameters.ApisPar.apiLessonListing , values: arrayAnyObj )
                
            case .BroadCastListing():
                guard let accessToken = UserDataSingleton.sharedInstance.loggedInUser?.userAccessToken else {return [:]}
                let arrayAnyObj:[AnyObject]? = [accessToken ]
                return API.mapKeysAndValues(ApiParameters.ApisPar.apiLessonListing , values: arrayAnyObj )
                
            case .BroadCastMessage(let message):
                guard let accessToken = UserDataSingleton.sharedInstance.loggedInUser?.userAccessToken else {return [:]}
                let arrayAnyObj:[AnyObject]? = [accessToken , ¿message , "CLIENTS" ]
                return API.mapKeysAndValues(ApiParameters.ApisPar.apiBroadCastMessage , values: arrayAnyObj )
                
            case .AddFoodPicByClient(let picType):
                guard let accessToken = UserDataSingleton.sharedInstance.loggedInUser?.userAccessToken else {return [:]}
                let arrayAnyObj:[AnyObject]? = [accessToken , ¿picType ]
                return API.mapKeysAndValues(ApiParameters.ApisPar.apiClientAddFoodPic , values: arrayAnyObj )

            case .ChangePassword(let password , let oldPassword):
                guard let accessToken = UserDataSingleton.sharedInstance.loggedInUser?.userAccessToken else {return [:]}
                let arrayAnyObj:[AnyObject]? = [accessToken , ¿password  , ¿oldPassword]
                return API.mapKeysAndValues(ApiParameters.ApisPar.apiClientChangePassword , values: arrayAnyObj )
                
                
            case .ClientAddSelfie():
                guard let accessToken = UserDataSingleton.sharedInstance.loggedInUser?.userAccessToken else {return [:]}
                let arrayAnyObj:[AnyObject]? = [accessToken  ]
                return API.mapKeysAndValues(ApiParameters.ApisPar.apiClientListing , values: arrayAnyObj )
                
            case .ClientAddWeighIn(let weight , let unit):
                guard let accessToken = UserDataSingleton.sharedInstance.loggedInUser?.userAccessToken else {return [:]}
                let arrayAnyObj:[AnyObject]? = [accessToken , ¿weight , ¿unit  ]
                return API.mapKeysAndValues(ApiParameters.ApisPar.AddClientWeighIn , values: arrayAnyObj )
                
            case .TrainerMessagesListing(let userId):
                guard let accessToken = UserDataSingleton.sharedInstance.loggedInUser?.userAccessToken else {return [:]}
                let arrayAnyObj:[AnyObject]? = [accessToken , ¿userId  ]
                return API.mapKeysAndValues(ApiParameters.ApisPar.TrainerMessagesListing , values: arrayAnyObj )
                
            case .MonthlyFoodPics(let clientId, let month):
                guard let accessToken = UserDataSingleton.sharedInstance.loggedInUser?.userAccessToken else {return [:]}
                let arrayAnyObj:[AnyObject]? = [accessToken , ¿clientId ,  ¿month ]
                return API.mapKeysAndValues(ApiParameters.ApisPar.MonthlyFoodPics , values: arrayAnyObj )
                
            case .GetQuiz(let lessonId):
                
                guard let accessToken = UserDataSingleton.sharedInstance.loggedInUser?.userAccessToken else {return [:]}
                let arrayAnyObj:[AnyObject]? = [accessToken , ¿lessonId ]
                return API.mapKeysAndValues(ApiParameters.ApisPar.Quiz , values: arrayAnyObj )
                
            case .SubmitMarks(let lessonId  , let marks):
                
                guard let accessToken = UserDataSingleton.sharedInstance.loggedInUser?.userAccessToken else {return [:]}
                let arrayAnyObj:[AnyObject]? = [accessToken , ¿lessonId  ,  ¿marks ]
                return API.mapKeysAndValues(ApiParameters.ApisPar.SubmitMarks , values: arrayAnyObj )
                
            case .SendMessage(let otherUserId , let message):
                
                guard let accessToken = UserDataSingleton.sharedInstance.loggedInUser?.userAccessToken else {return [:]}
                let arrayAnyObj:[AnyObject]? = [accessToken , ¿otherUserId  ,  ¿message ]
                return API.mapKeysAndValues(ApiParameters.ApisPar.SendMessage , values: arrayAnyObj )
                
                
            case .PollMessages(let otherUserId , let messageTime):
                
                guard let accessToken = UserDataSingleton.sharedInstance.loggedInUser?.userAccessToken else {return [:]}
                let arrayAnyObj:[AnyObject]? = [accessToken , ¿otherUserId  ,  ¿messageTime ]
                return API.mapKeysAndValues(ApiParameters.ApisPar.PollMessages , values: arrayAnyObj )
                
            case .AddWeight(let clientId, let weight , let unit):
                guard let accessToken = UserDataSingleton.sharedInstance.loggedInUser?.userAccessToken else {return [:]}
                let arrayAnyObj:[AnyObject]? = [accessToken , ¿clientId  ,  ¿weight , ¿unit]
                return API.mapKeysAndValues(ApiParameters.ApisPar.AddWeight , values: arrayAnyObj )
                
                
                
                
                
            case .ClientMonthlyFoodPics(let month):
                guard let accessToken = UserDataSingleton.sharedInstance.loggedInUser?.userAccessToken else {return [:]}
                let arrayAnyObj:[AnyObject]? = [accessToken , ¿month ]
                return API.mapKeysAndValues(ApiParameters.ApisPar.ClientMonthlyFoodPics , values: arrayAnyObj )
                
                
            case .ClientAddFitnessAssessment(let assessments):
                guard let accessToken = UserDataSingleton.sharedInstance.loggedInUser?.userAccessToken else {return [:]}
                let arrayAnyObj:[AnyObject]? = [accessToken, ¿assessments ]
                return API.mapKeysAndValues(ApiParameters.ApisPar.AddClientFitnessAssessmentByClient , values: arrayAnyObj )
                
            case .ClientAddFitnessMeasurements(let measurements):
                guard let accessToken = UserDataSingleton.sharedInstance.loggedInUser?.userAccessToken else {return [:]}
                let arrayAnyObj:[AnyObject]? = [accessToken, ¿measurements ]
                return API.mapKeysAndValues(ApiParameters.ApisPar.AddClientMeasurementByClient , values: arrayAnyObj )
                
                
            case .ClientMessagesListing(let userId):
                guard let accessToken = UserDataSingleton.sharedInstance.loggedInUser?.userAccessToken else {return [:]}
                let arrayAnyObj:[AnyObject]? = [accessToken , ¿userId  ]
                return API.mapKeysAndValues(ApiParameters.ApisPar.ClientMessagesListing , values: arrayAnyObj )
                
            case .CliemtSendMessage(let otherUserId , let message):
                
                guard let accessToken = UserDataSingleton.sharedInstance.loggedInUser?.userAccessToken else {return [:]}
                let arrayAnyObj:[AnyObject]? = [accessToken , ¿otherUserId  ,  ¿message ]
                return API.mapKeysAndValues(ApiParameters.ApisPar.ClientSendMessage , values: arrayAnyObj )
                
            case .ClientPollMessages(let otherUserId , let messageTime):
                
                guard let accessToken = UserDataSingleton.sharedInstance.loggedInUser?.userAccessToken else {return [:]}
                let arrayAnyObj:[AnyObject]? = [accessToken , ¿otherUserId  ,  ¿messageTime ]
                return API.mapKeysAndValues(ApiParameters.ApisPar.ClientPollMessages , values: arrayAnyObj )
                
            case .OnOffPush(let status):
                
                guard let accessToken = UserDataSingleton.sharedInstance.loggedInUser?.userAccessToken else {return [:]}
                let arrayAnyObj:[AnyObject]? = [accessToken ,  ¿status ]
                
                return API.mapKeysAndValues(ApiParameters.ApisPar.push , values: arrayAnyObj )
                
                
            case .OnOffPushClient(let status , let notificationType):
                
                guard let accessToken = UserDataSingleton.sharedInstance.loggedInUser?.userAccessToken else {return [:]}
                let arrayAnyObj:[AnyObject]? = [accessToken ,  ¿status  , ¿notificationType]
                
                return API.mapKeysAndValues(ApiParameters.ApisPar.ClientPush , values: arrayAnyObj )
                
                
            case .ReadBroadCast(let message):
                
                guard let accessToken = UserDataSingleton.sharedInstance.loggedInUser?.userAccessToken else {return [:]}
                let arrayAnyObj:[AnyObject]? = [accessToken ,  ¿message ]
                
                return API.mapKeysAndValues(ApiParameters.ApisPar.BroadCastRead , values: arrayAnyObj )
                
            case .EditDetails(let firstName , let  lastName ,let  phoneNumber , let countryCode , let address , let email  , let pinCode , let state , let city):
                
                guard let accessToken = UserDataSingleton.sharedInstance.loggedInUser?.userAccessToken else {return [:]}
                let arrayAnyObj:[AnyObject]? = [accessToken ,  ¿firstName , ¿lastName , ¿phoneNumber, ¿countryCode  ,  ¿address , ¿email , ¿pinCode , ¿state , ¿city ]
                
                return API.mapKeysAndValues(ApiParameters.ApisPar.editClient , values: arrayAnyObj )
                
                
            case .UpdateDeviceToken(let deviceToken):
                
                guard let accessToken = UserDataSingleton.sharedInstance.loggedInUser?.userAccessToken else {return [:]}
                let arrayAnyObj:[AnyObject]? = [accessToken ,  "IOS" , ¿deviceToken ]
                
                return API.mapKeysAndValues(ApiParameters.ApisPar.UpdateDeviceToken , values: arrayAnyObj )
                
                
                
                
                
            case FoodNutrition(let type):
                
                guard let accessToken = UserDataSingleton.sharedInstance.loggedInUser?.userAccessToken else {return [:]}
                let arrayAnyObj:[AnyObject]? = [accessToken , ¿type ]
                
                return API.mapKeysAndValues(ApiParameters.ApisPar.FoodNutrition , values: arrayAnyObj )
                
            case DeleteChat(let clientId):
                
                guard let accessToken = UserDataSingleton.sharedInstance.loggedInUser?.userAccessToken else {return [:]}
                let arrayAnyObj:[AnyObject]? = [accessToken , ¿clientId ]
                
                return API.mapKeysAndValues(ApiParameters.ApisPar.DeleteChat , values: arrayAnyObj )
                
                
                
                
            default : return ["":""]
                
            }
        }
    }
    
}
