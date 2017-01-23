//
//  NewBroadCast.swift
//  MyFitMembers
//
//  Created by cbl24 on 9/29/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit

protocol BroadCastDone {
    func delegatebroadCastDone()
}
class NewBroadCast: UIView , DelegateRemoveBroadCastSendPopUp {
    
    //MARK::- Outlets
    
    @IBOutlet weak var textView: UITextView!
    //MARK::- VARIABLES
    var popUpBroadCast: BroadCastSendPopUp?
    var vc: BroadCastViewController?
    var delegate:BroadCastDone?
    
    //MARK::- Functions
    func loadViewFromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "NewBroadCast", bundle: bundle)
        guard let view = nib.instantiateWithOwner(self, options: nil)[0] as? UIView else {return UIView()}
        return view
    }
    
    func xibSetup() {
        let view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        addSubview(view)
    }
    
    func instantiateViewControllers(){
        popUpBroadCast = BroadCastSendPopUp(frame: CGRect(x: 0, y: 0, w: DeviceDimensions.width, h: DeviceDimensions.height))
        popUpBroadCast?.delegate = self
    }
    
    
    //MARK::- Ovveride Functions
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
        instantiateViewControllers()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        xibSetup()
        
    }
    
    //MARK::- Delegate
    
    func delegateRemoveBroadCastSendPopUp(){
        removeAnimate(self)
        delegate?.delegatebroadCastDone()
    }
    
    //MARK::- Actions
    
    
    @IBAction func btnActionOk(sender: UIButton) {
        
        popUpBroadCast?.vc = vc
        self.addSubview(popUpBroadCast ?? UIView())
        if textView.text.characters.count > 0 && textView.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) != ""{
            NSUserDefaults.standardUserDefaults().setValue(textView.text ?? "", forKey: "BroadCastMessage")
            
            showAnimate(popUpBroadCast ?? UIView())
        }else{
            guard let vc  = vc else {return}
            AlertView.callAlertView("", msg: "Empty Message", btnMsg: "OK", vc: vc)
        }
    }
    
}
