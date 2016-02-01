//
//  NSArray+removeAtIndexs.swift
//  pages
//
//  Created by Bobo on 1/20/16.
//  Copyright © 2016 myname. All rights reserved.
//

import Foundation

extension Array {
    mutating func removeAtIndexes(incs: [Int]) {
        incs.sort(>).forEach { removeAtIndex($0) }
    }
}
