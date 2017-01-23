//
//  ImageViewExtensions.swift
//  MyFitMembers
//
//  Created by cbl24 on 10/6/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit

extension UIImageView{
    
    func makeBlurImage(targetImageView:UIImageView?){
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = targetImageView!.bounds
        
        blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight] // for supporting device rotation
        targetImageView?.addSubview(blurEffectView)
    }
    
}
