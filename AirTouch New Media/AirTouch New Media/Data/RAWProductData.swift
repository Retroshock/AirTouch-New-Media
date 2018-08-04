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

typealias RAWProductDataArray = [RAWProductData]

struct ProductData {
    var sku: String
    var amount: Decimal?
    var currency: String

    init(sku: String,
         amount: Decimal,
         currency: String) {
        self.sku = sku
        self.amount = amount
        self.currency = currency
    }

    init?(rawData: RAWProductData) {
        self.sku = rawData.sku
        self.currency = rawData.currency
        if let amountInDouble = Double(rawData.amount) {
            self.amount = Decimal(amountInDouble)
        } else {
            return nil
        }
    }
}
