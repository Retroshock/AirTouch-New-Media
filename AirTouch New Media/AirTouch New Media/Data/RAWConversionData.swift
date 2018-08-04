//
//  ConversionData.swift
//  AirTouch New Media
//
//  Created by Adrian Popovici on 02/08/2018.
//  Copyright © 2018 adrian. All rights reserved.
//

import Foundation

struct RAWConversionData: Decodable {
    var from: String
    var to: String
    var rate: String
}

typealias ConversionDataArray = [RAWConversionData]
