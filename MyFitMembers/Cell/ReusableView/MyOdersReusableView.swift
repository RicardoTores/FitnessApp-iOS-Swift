//
//  MyOdersReusableView.swift
//  BarExchangeDemo
//
//  Created by cbl16 on 7/27/16.
//  Copyright © 2016 cbl16. All rights reserved.
//

import UIKit

protocol RemoveBanner {
    func removeBanner()
}


class MyOdersReusableView: UICollectionReusableView {
    
    @IBOutlet weak var labelMessage: UILabel!
    
    @IBOutlet weak var viewBanner: UIView!
    
    var delegate:RemoveBanner?
    
    
    @IBAction func btnActionRemove(sender: UIButton) {
        delegate?.removeBanner()
    }
    
    
    func tapOnBaner(){
        viewBanner.addSingleTapGestureRecognizerWithResponder({ [unowned
            self] (tap) in
            
            
            })
    }
}
