//
//  MockNetworkRouter.swift
//  LeagueMobileChallengeTests
//
//  Created by Amrita Kumar on 8/24/22.
//  Copyright © 2022 Kelvin Lau. All rights reserved.
//

import Foundation
import Alamofire
@testable import LeagueMobileChallenge

final class MockNetworkRouter<EndPoint: EndPointConfigProtocol>: NetworkRouter {
    func request(_ route: EndPoint, parmeter: Parameters?, headers: HTTPHeaders?, completion: @escaping NetworkRouterCompletion) {
        var fileName = ""
        let requestType = route as? EndPointConfig
        guard let reqtype = requestType else {
            completion(nil, nil, HTTPNetworkError.couldNotParse)
            return
        }
        switch reqtype  {
        case .User:
            fileName = "users"
            break
        case .Post:
            fileName = "posts"
            break
        case .Login:
            fileName = ""
            break
            
        }
        // Retrieves a path to the users.json file
        let pathString = Bundle(for: type(of: self)).path(forResource: fileName, ofType: "json")!
        let url = URL(fileURLWithPath: pathString)
        let jsonData = try! Data(contentsOf: url)
        // Pass data to caller
        completion(jsonData, 200, nil)
    }
    
}
