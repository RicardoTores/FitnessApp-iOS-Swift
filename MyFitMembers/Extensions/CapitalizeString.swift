//
//  CapitalizeString.swift
//  GoHobo
//
//  Created by cbl24 on 5/10/16.
//  Copyright © 2016 GCode. All rights reserved.
//

import UIKit

extension String {
    var first: String {
        return String(characters.prefix(1))
    }
    var last: String {
        return String(characters.suffix(1))
    }
    var uppercaseFirst: String {
        return first.uppercaseString + String(characters.dropFirst())
    }
    var lowerCaseFirst: String {
        return first.lowercaseString + String(characters.dropFirst())
    }

    
    func contains(find: String) -> Bool{
        return self.rangeOfString(find) != nil
    }
    
    func containsIgnoringCase(find: String) -> Bool{
        return self.rangeOfString(find, options: NSStringCompareOptions.CaseInsensitiveSearch) != nil
    }
    
    var html2AttributedString: NSAttributedString? {
        guard
            let data = dataUsingEncoding(NSUTF8StringEncoding)
            else { return nil }
        do {
            return try NSAttributedString(data: data, options: [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute:NSUTF8StringEncoding], documentAttributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription)
            return  nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
    
    func stringByURLEncoding() -> String? {
        let characters = NSCharacterSet.URLQueryAllowedCharacterSet().mutableCopy() as? NSMutableCharacterSet
        characters?.removeCharactersInString("&")
        guard let encodedString = self.stringByAddingPercentEncodingWithAllowedCharacters(characters ?? NSMutableCharacterSet()) else {
            return nil
        }
        return encodedString
    }
}
var urlGetHome = ""
var urlGetMixer = ""