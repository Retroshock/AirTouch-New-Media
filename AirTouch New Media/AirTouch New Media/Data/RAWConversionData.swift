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

typealias RAWConversionDataArray = [RAWConversionData]

struct ConversionData {

    var from: String
    var to: String
    var rate: Decimal?

    init (from: String,
          to: String,
          rate: Decimal) {
        self.from = from
        self.to = to
        self.rate = rate
    }

    init(rawData: RAWConversionData) {
        self.from = rawData.from
        self.to = rawData.to
        if let rateInDouble = Double(rawData.rate) {
            self.rate = Decimal(rateInDouble)
        } else {
            self.rate = nil
        }
    }
}
