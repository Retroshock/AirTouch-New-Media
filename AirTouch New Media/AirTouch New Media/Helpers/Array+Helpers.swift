//
//  Array+Helpers.swift
//  AirTouch New Media
//
//  Created by Adrian Popovici on 03/08/2018.
//  Copyright © 2018 adrian. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {
    mutating func removeDuplicates() {
        var result = [Element]()
        for value in self {
            if !result.contains(value) {
                result.append(value)
            }
        }
        self = result
    }
}
