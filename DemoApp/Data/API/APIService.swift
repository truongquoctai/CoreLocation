//
//  APIService.swift
//  DemoApp
//
//  Created by Truong Quoc Tai on 5/28/21.
//  Copyright © 2021 TaiTQ. All rights reserved.
//

import Foundation
import MGAPIService
import RxSwift

final class API: APIBase {
    static var shared = API()
    
    override func handleResponseError(response: HTTPURLResponse, data: Data, json: JSONDictionary?) -> Error {
        return super.handleResponseError(response: response, data: data, json: json)
    }
    
    override func preprocess(_ input: APIInputBase) -> Observable<APIInputBase> {
        return super.preprocess(input)
    }
}