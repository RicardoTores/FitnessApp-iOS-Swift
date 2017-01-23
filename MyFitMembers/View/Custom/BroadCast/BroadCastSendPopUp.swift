//
//  BroadCastSendPopUp.swift
//  MyFitMembers
//
//  Created by cbl24 on 9/29/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit
protocol DelegateRemoveBroadCastSendPopUp {
    func delegateRemoveBroadCastSendPopUp()
}

class BroadCastSendPopUp: UIView {

    //MARK::- Outlets
    
   //MARK::- VARIABLES
    var delegate:DelegateRemoveBroadCastSendPopUp?
    var vc: BroadCastViewController?
    
    //MARK::- Functions
    func loadViewFromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "BroadCastSendPopUp", bundle: bundle)
        guard let view = nib.instantiateWithOwner(self, options: nil)[0] as? UIView else {return UIView()}
        return view
    }
    
    func xibSetup() {
        let view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        addSubview(view)
    }
    
    
    
    //MARK::- Ovveride Functions
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        xibSetup()
        
    }
    
    //MARK::- Actions
    
    
    @IBAction func btnActionSend(sender: UIButton) {
        sendBroadCastMessage()
        
    }
    
    
    
    @IBAction func btnActionCancel(sender: UIButton) {
        removeAnimate(self)
    }

//MARK::- API
    
    func sendBroadCastMessage(){
        
        guard let message = NSUserDefaults.standardUserDefaults().valueForKey("BroadCastMessage") as? String , vc = vc else {return}
        let dictForBackEnd = API.ApiCreateDictionary.BroadCastMessage(message: message).formatParameters()
        
        ApiDetector.getDataOfURL(ApiCollection.apiMessageBroadCast, dictForBackend: dictForBackEnd, failure: { (data) in
            
            }, success: { [unowned self ] (data) in
                self.delegate?.delegateRemoveBroadCastSendPopUp()
                removeAnimate(self)
            }, method: .POST, viewControl: vc, pic: UIImage(), placeHolderImageName: "", headers: [:] , showLoader: true, loaderColor: Colorss.DarkRed.toHex())
    }
}
