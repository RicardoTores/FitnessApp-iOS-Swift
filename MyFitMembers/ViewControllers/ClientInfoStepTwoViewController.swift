//
//  ClientInfoStepTwoViewController.swift
//  MyFitMembers
//
//  Created by cbl24 on 9/29/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit
import Fusuma

class ClientInfoStepTwoViewController: UIViewController {
    //MARK::- OUTLETS
    
    @IBOutlet weak var btnCamera: UIButton!{
        didSet{
            btnCamera.layer.cornerRadius = btnCamera.frame.height/2
        }
    }
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    
    @IBOutlet weak var imageProfile: UIImageView!{
        didSet{
            imageProfile.layer.cornerRadius = imageProfile.frame.height/2
        }
    }
    //MARK::- VARIABLES
    
    var clientInfoStepThreeVc:ClientInfoThreeViewController?
    var showSkip = true
    
    //MARK::- OVVERIDE FUNCTIONS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        instantiateViewControllers()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        setUpSideBar(false,allowRighSwipe: false)
        if showSkip{
            showSkip = false
            btnNext.setTitle("SKIP", forState: .Normal)
        }else{
            showSkip = false
        }
        let imageSelectCheck = NSUserDefaults.standardUserDefaults().valueForKey("ImageSelected") as? Bool ?? false
        
        if imageSelectCheck{
            btnNext.setTitle("NEXT", forState: .Normal)
        }else{
            btnNext.setTitle("SKIP", forState: .Normal)
        }
        tapOnCamera()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    //MARK::- FUNCTIONS
    
    func instantiateViewControllers(){
    }
    
    func tapOnCamera(){
        imageProfile.addTapGesture { (tap) in
            self.btnNext.setTitle("NEXT", forState: .Normal)
            let alertcontroller =   UIAlertController.showActionSheetController(title: "Choose your action", buttons: ["Camera" , "Photo Library"], success: { [unowned self]
                (state) -> () in
                self.callFusumaImagePicker(state)
                })
            self.presentViewController(alertcontroller, animated: true, completion: nil)
        }
    }
    
    func callFusumaImagePicker(item:String){
        allowRev = false
        CameraGalleryPickerBlock.sharedInstance.pickerImage(type: item, presentInVc: self, pickedListner: {
            [unowned self]
            (image,imageUrl) -> () in
            self.imageProfile.image = image
            NSUserDefaults.standardUserDefaults().setValue(true, forKey: "ImageSelected")
            }, canceledListner: { [weak self] in
                
            } , allowEditting:true)
        
    }
    
    //MARK::- DELEGATE
    
    
    //MARK::- ACTIONS
    
    @IBAction func btnActionCamera(sender: UIButton) {
        
    }
    
    @IBAction func btnActionNext(sender: UIButton) {
        sendUserInformation()
    }
    
    @IBAction func btnActionBack(sender: UIButton) {
        popVC()
    }
    
}


extension ClientInfoStepTwoViewController{
    
    //MARK::- API
    
    func sendUserInformation(){
        guard let dictForBackEnd = NSUserDefaults.standardUserDefaults().rm_customObjectForKey("AddNewUserInformation") as?  OptionalDictionary else {return}
        NSUserDefaults.standardUserDefaults().rm_setCustomObject(dictForBackEnd, forKey: "AddNewUserInformationWithImage")
        
        print(dictForBackEnd)
        ApiDetector.getDataOfURL(ApiCollection.apiAddClient, dictForBackend: dictForBackEnd, failure: { (data) in
            print(data)
            }, success: { [weak self] (data) in
                print(data)
                self?.showSkip = true
                guard let clientData = data as? ClientAddedDetail else {return}
                let vc = StoryboardScene.Main.instantiateClientInfoThreeViewController()
                vc.clientId = clientData.clientId
                self?.pushVC(vc)
                self?.btnBack.enabled = false
                NSUserDefaults.standardUserDefaults().setValue(nil, forKey: "ImageSelected")
            }, method: .PostWithImage, viewControl: self, pic: imageProfile?.image , placeHolderImageName: "profilePic", headers: [:] , showLoader: true, loaderColor: Colorss.DarkRed.toHex())
    }
    
    
    
    
}

extension ClientInfoStepTwoViewController : FusumaDelegate{
    
    //MARK::- Fusuma delegates
    
    func fusumaImageSelected(image: UIImage) {
        imageProfile.image = image
        let img = cropToBounds(image, width: 400, height: 400)
        NSUserDefaults.standardUserDefaults().setValue(true, forKey: "ImageSelected")
        btnCamera.setImage(img, forState: .Normal)
        btnCamera.setImage(img, forState: .Highlighted)
        btnCamera.setImage(img, forState: .Selected)
        print("Image selected")
    }
    
    // Return the image but called after is dismissed.
    func fusumaDismissedWithImage(image: UIImage) {
        print("Called just after FusumaViewController is dismissed.")
    }
    
    // When camera roll is not authorized, this method is called.
    func fusumaCameraRollUnauthorized() {
        print("Camera roll unauthorized")
    }
    
    func fusumaVideoCompleted(withFileURL fileURL: NSURL) {
    }
    
    
    
    func cropToBounds(image: UIImage, width: Double, height: Double) -> UIImage {
        
        let contextImage: UIImage = UIImage(CGImage: image.CGImage!)
        
        let contextSize: CGSize = contextImage.size
        
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        var cgwidth: CGFloat = CGFloat(width)
        var cgheight: CGFloat = CGFloat(height)
        
        // See what size is longer and create the center off of that
        if contextSize.width > contextSize.height {
            posX = ((contextSize.width - contextSize.height) / 2)
            posY = 0
            cgwidth = contextSize.height
            cgheight = contextSize.height
        } else {
            posX = 0
            posY = ((contextSize.height - contextSize.width) / 2)
            cgwidth = contextSize.width
            cgheight = contextSize.width
        }
        
        let rect: CGRect = CGRectMake(posX, posY, cgwidth, cgheight)
        
        // Create bitmap image from context using the rect
        let imageRef: CGImageRef = CGImageCreateWithImageInRect(contextImage.CGImage, rect)!
        
        // Create a new image based on the imageRef and rotate back to the original orientation
        let image: UIImage = UIImage(CGImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
        
        return image
    }
    
}