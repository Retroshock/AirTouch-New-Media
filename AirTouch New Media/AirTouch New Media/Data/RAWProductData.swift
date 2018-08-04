//
//  ProductData.swift
//  AirTouch New Media
//
//  Created by Adrian Popovici on 03/08/2018.
//  Copyright © 2018 adrian. All rights reserved.
//

import Foundation

struct RAWProductData: Decodable {
    var sku: String
    var amount: String
    var currency: String
}

typealias ProductDataArray = [RAWProductData]
