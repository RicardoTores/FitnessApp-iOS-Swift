//
//  ApiManager.swift
//  NeverMynd
//
//  Created by cbl24 on 7/7/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


enum ApiMethod {
    case GET
    case POST
    case PostWithImage
    case PUT
}


class ApiManager: NSObject {
    
    
    class func callApiWithParameters(url: String , withParameters parameters:[String:AnyObject], success:(AnyObject)->(), failure: (NSError)->(), method: ApiMethod, img: UIImage? , imageParamater: String, headers: [String:String]){
        
        
        switch method {
        case .GET:
            Alamofire.request(.GET, url, headers: headers).responseJSON { response
                in switch response.result{
                case .Success(let data):
                    success(data)
                case .Failure(let error):
                    print(error)
                    failure(error)
                }
            }
        case .POST:
            Alamofire.request(.POST, url , parameters:parameters , encoding: ParameterEncoding.URL, headers: headers).responseJSON {
                response in switch response.result{
                case .Success(let data):
                    print(data)
                    success(data)
                    
                case .Failure(let error):
                    print(error)
                    failure(error)
                    
                }
            }
            
        case .PostWithImage:
            
            Alamofire.upload(.POST, url, headers: nil, multipartFormData: { (formData) in
                print(img)
                if let ppic = img,data = UIImageJPEGRepresentation(ppic, 0.2){
                    print(ppic)
                    formData.appendBodyPart(data: data, name: imageParamater , fileName:"temp.jpeg" , mimeType: "image/jpeg")
                    
                }
                
                for (key, value) in parameters ?? [:] {
                    
                    formData.appendBodyPart(data: value.dataUsingEncoding(NSUTF8StringEncoding)!, name: key)
                    
                }
                
            }, encodingMemoryThreshold: Manager.MultipartFormDataEncodingMemoryThreshold) { (result) in
                
                switch result {
                    
                case .Success(request:let req, streamingFromDisk: _, streamFileURL: _):
                    
                    req.responseJSON(completionHandler: { (response) in
                        
                        switch response.result {
                            
                        case .Success(let data):
                            
                            success(data)
                            
                        case .Failure(let error):
                            
                            failure(error)
                            
                        }
                        
                    })
                    
                case .Failure(let encodingError):
                    print(encodingError)
                }
                
            }
            
            
        case .PUT:
            Alamofire.request(.PUT, url, parameters: parameters, encoding: ParameterEncoding.JSON, headers: headers).responseJSON {
                response in switch response.result{
                case .Success(let data):
                    print(headers)
                    print(data)
                    success(data)
                    
                case .Failure(let error):
                    print(error)
                    failure(error)
                    
                }
            }
            
        default:
            break
        }
    }
}
