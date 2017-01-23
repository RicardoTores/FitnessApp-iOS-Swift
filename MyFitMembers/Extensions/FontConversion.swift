//
//  FontConversion.swift
//  GoHobo
//
//  Created by cbl24 on 6/2/16.
//  Copyright © 2016 GCode. All rights reserved.
//

import UIKit

extension NSMutableAttributedString
{
    func convertFontTo(font: UIFont, rng:Int)
    {
        var range = NSMakeRange(0, 0)
        
        while (NSMaxRange(range) < length)
        {
            let attributes = attributesAtIndex(NSMaxRange(range), effectiveRange: &range)
            if let oldFont = attributes[NSFontAttributeName]
            {
                let newFont = UIFont(descriptor: font.fontDescriptor().fontDescriptorWithSymbolicTraits(oldFont.fontDescriptor().symbolicTraits), size: font.pointSize)
                addAttribute(NSFontAttributeName, value: newFont, range: NSRange(location: 0,length: rng))
            }
        }
    }
}
