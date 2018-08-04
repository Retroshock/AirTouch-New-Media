//
//  ConversionCalculator.swift
//  AirTouch New Media
//
//  Created by Adrian Popovici on 03/08/2018.
//  Copyright © 2018 adrian. All rights reserved.
//

import Foundation

class ConversionCalculator {

    static func addValues(forTransactions transactions: [ProductData],
                          withConversions conversions: [ConversionData],
                          completion: @escaping(Decimal?) -> ()) {
        DispatchQueue.global(qos: .background).async {
            var sum: Decimal = 0
            for transaction in transactions {
                var rate: Decimal = Decimal(1)
                switch transaction.currency {
                case Currency.AUD:
                    if let conversion = conversions.first(where: { $0.from == Currency.AUD && $0.to == Currency.EUR }) {
                        guard conversion.rate != nil else {
                            completion(nil)
                            return
                        }
                        rate = conversion.rate!
                    }
                case Currency.CAD:
                    if let conversion = conversions.first(where: { $0.from == Currency.CAD && $0.to == Currency.EUR }) {
                        guard conversion.rate != nil else {
                            completion(nil)
                            return
                        }
                        rate = conversion.rate!
                    }
                case Currency.USD:
                    if let conversion = conversions.first(where: { $0.from == Currency.USD && $0.to == Currency.EUR }) {
                        guard conversion.rate != nil else {
                            completion(nil)
                            return
                        }
                        rate = conversion.rate!
                    }
                case Currency.EUR:
                    rate = 1
                default:
                    rate = 1
                }
                guard let amount = transaction.amount else {
                    completion(nil)
                    return
                }
                sum += amount * rate
            }
            completion(sum)
        }
    }

    static func createConversionsToEur(fromExistingConversions conversions: [ConversionData],
                                       completion: @escaping([ConversionData]?) -> ()) {
        DispatchQueue.global(qos: .background).async {
            var newConversions = conversions
            for conversion in conversions {
                var first = conversion.from
                var last: String = conversion.to
                var queue: [String] = [first]
                var predecesor: [Int] = [-1]
                var firstIndex: Int = 0
                var lastIndex: Int = 0
                while last != Currency.EUR && firstIndex <= lastIndex {
                    first = queue[firstIndex]
                    var discoveredConverionsCount = 0
                    for discoveredConversion in conversions {
                        if discoveredConversion.from == first {
                            if !queue.contains(discoveredConversion.to) {
                                discoveredConverionsCount += 1
                                last = discoveredConversion.to
                                queue.append(last)
                                predecesor.append(firstIndex)
                                if last == Currency.EUR {
                                    break
                                }

                            }
                        }
                    }
                    lastIndex = queue.count - 1
                    firstIndex += 1
                }
                if !(firstIndex > lastIndex && last != Currency.EUR) {
                    var index = lastIndex
                    var product = Decimal(1)
                    while predecesor[index] > -1 {
                        guard let tempConversion = conversions.first(where: { $0.from == queue[predecesor[index]] && $0.to == queue[index] }) else {
                            completion(nil)
                            return
                        }
                        guard let rate = tempConversion.rate else {
                            completion(nil)
                            return
                        }
                        product = product * rate
                        index = predecesor[index]
                    }
                    if !newConversions.contains(where: { (data) -> Bool in
                        return data.from == queue[0] && data.to == last }) {
                        newConversions.append(ConversionData(from: queue[0],
                                                             to: last,
                                                             rate: product))
                    }
                }
            }
            completion(newConversions)
        }
    }
}
