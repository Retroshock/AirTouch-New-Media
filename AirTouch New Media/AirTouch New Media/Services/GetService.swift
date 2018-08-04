//
//  GetService.swift
//  AirTouch New Media
//
//  Created by Adrian Popovici on 03/08/2018.
//  Copyright © 2018 adrian. All rights reserved.
//

import Alamofire
import Foundation

class GetService {
    static var shared = GetService()

    func getConversionJSONs(completion: @escaping (Bool, RAWConversionDataArray?) -> ()) {
        let url = conversionsURL
        let headers: HTTPHeaders = [
            "Accept": "application/json"
        ]
        Alamofire.request(url,
                          method: .get,
                          parameters: nil,
                          encoding: JSONEncoding.default,
                          headers: headers).responseJSON { response in
                            print(response.result)
                            if !response.result.isFailure {
                                guard let data = response.data else {
                                    completion(false, nil)
                                    return
                                }

                                guard let values = try? JSONDecoder().decode(RAWConversionDataArray.self, from: data) else {
                                    print("Could not decode ConversionArray")
                                    completion(false, nil)
                                    return
                                }
                                completion(true, values)
                            }

        }

    }

    func getTransationJSONs(completion: @escaping (Bool, RAWProductDataArray?) -> ()) {
        let url = transactionsURL
        let headers: HTTPHeaders = [
            "Accept": "application/json"
        ]
        Alamofire.request(url,
                          method: .get,
                          parameters: nil,
                          encoding: JSONEncoding.default,
                          headers: headers).responseJSON { response in
                            print(response.result)
                            if !response.result.isFailure {
                                guard let data = response.data else {
                                    completion(false, nil)
                                    return
                                }

                                guard let values = try? JSONDecoder().decode(RAWProductDataArray.self, from: data) else {
                                    print("Could not decode ConversionArray")
                                    completion(false, nil)
                                    return
                                }
                                completion(true, values)
                            }

        }

    }
}
