//
//  BannerBroadCastView.swift
//  MyFitMembers
//
//  Created by cbl24 on 29/11/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit

class BannerBroadCastView: UIView {
    
    //MARK::- Outlets
    
    
    
    //MARK::- VARIABLES
    var delegate:DelegateAddWeighIn?
    
    //MARK::- Functions
    func loadViewFromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "BannerBroadCastView", bundle: bundle)
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
    
    
    
}
