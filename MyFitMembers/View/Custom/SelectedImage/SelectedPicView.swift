//
//  SelectedPicView.swift
//  MyFitMembers
//
//  Created by cbl24 on 10/19/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit
protocol DelegateSelectedPicView{
    func delegateSelectedPicViewAccept(image: UIImage)
    func delegateSelectedPicViewReject()
}
class SelectedPicView: UIView {
    
//MARK::- OUTLETS
    
    @IBOutlet weak var imageSelectedPic: UIImageView!
    
    
    //MARK::- VARIABLES
    
    var delegate: DelegateSelectedPicView?
    
    //MARK::- Functions
    func loadViewFromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "SelectedPicView", bundle: bundle)
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
    
   
    @IBAction func btnActionRejectPic(sender: UIButton) {
        delegate?.delegateSelectedPicViewAccept(imageSelectedPic.image ?? UIImage())
    }
    
    
    @IBAction func btnActionAcceptPic(sender: UIButton) {
        delegate?.delegateSelectedPicViewReject()
    }
    
}
