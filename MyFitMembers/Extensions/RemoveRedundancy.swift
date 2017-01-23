//
//  RemoveRedundancy.swift
//  GoHobo
//
//  Created by cbl24 on 6/3/16.
//  Copyright © 2016 GCode. All rights reserved.
//

import UIKit

extension Array where Element:Equatable {
    func removeDuplicates() -> [Element] {
        var result = [Element]()
        
        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }
        
        return result
    }
}
