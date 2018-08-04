//
//  Double+Helpers.swift
//  AirTouch New Media
//
//  Created by Adrian Popovici on 02/08/2018.
//  Copyright © 2018 adrian. All rights reserved.
//

import Foundation

extension Double
{
    func truncate(places : Int) -> Double {
        return Double(floor(pow(10.0, Double(places)) * self)/pow(10.0, Double(places)))
    }

}
