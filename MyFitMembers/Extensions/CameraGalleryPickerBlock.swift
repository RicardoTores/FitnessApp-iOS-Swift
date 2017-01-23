//
//  CameraGalleryPickerBlock.swift
//  StyleBlink
//
//  Created by Aseem 18 on 29/06/16.
//  Copyright © 2016 Aseem 19. All rights reserved.
//

import UIKit
import Photos

var allowRev = false
class CameraGalleryPickerBlock: NSObject , UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    
    typealias onPicked = (UIImage,String) -> ()
    typealias onCanceled = () -> ()
    
    
    var pickedListner : onPicked?
    var canceledListner : onCanceled?
    
    
    
    class var sharedInstance: CameraGalleryPickerBlock {
        struct Static {
            static var instance: CameraGalleryPickerBlock?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = CameraGalleryPickerBlock()
        }
        
        return Static.instance!
    }
    
    override init(){
        super.init()
        
    }
    
    deinit
    {
        
    }
    
    
    func pickerImage( type type : String , presentInVc : UIViewController , pickedListner : onPicked , canceledListner : onCanceled , allowEditting:Bool){
        
        self.pickedListner = pickedListner
        self.canceledListner = canceledListner
        
        let picker : UIImagePickerController = UIImagePickerController()
        picker.sourceType = type == "Camera" ? UIImagePickerControllerSourceType.Camera : UIImagePickerControllerSourceType.PhotoLibrary
        if allowRev && type == "Camera"{
            picker.cameraDevice = .Front
        }else if allowRev == false && type == "Camera"{
            picker.cameraDevice = .Rear
        }else{}
        picker.delegate = self
        picker.modalPresentationStyle = .FormSheet
        picker.allowsEditing = allowEditting
        presentInVc.presentViewController(picker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
        if let listener = canceledListner{
            listener()
        }
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        picker.dismissViewControllerAnimated(true, completion: nil)
        if allowRev{
            if let image : UIImage = info[UIImagePickerControllerOriginalImage] as? UIImage,imageUrl = info[UIImagePickerControllerReferenceURL] , listener = pickedListner{
                listener(image,imageUrl.absoluteString)
            }else if let image : UIImage = info[UIImagePickerControllerOriginalImage] as? UIImage, listener = pickedListner {
                listener(image,"")
            }
        }else{
            if let image : UIImage = info[UIImagePickerControllerEditedImage] as? UIImage,imageUrl = info[UIImagePickerControllerReferenceURL] , listener = pickedListner{
                listener(image,imageUrl.absoluteString)
            }else if let image : UIImage = info[UIImagePickerControllerEditedImage] as? UIImage, listener = pickedListner {
                listener(image,"")
            }
        }
        
        
        
    }
    
    
    
    
}
