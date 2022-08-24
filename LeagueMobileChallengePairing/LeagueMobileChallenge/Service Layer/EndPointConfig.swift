//
//  EndPointConfig.swift
//  LeagueMobileChallenge
//
//  Created by Amrita Kumar on 8/24/22.
//  Copyright © 2022 Kelvin Lau. All rights reserved.
//

import Foundation
import Alamofire

protocol EndPointConfigProtocol {
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: Alamofire.HTTPMethod { get }
}

public enum EndPointConfig {
    case Login
    case Post
    case User
}

extension EndPointConfig: EndPointConfigProtocol {
    ///  returns base url w.r.t. environment
    var baseURL: URL {
        let domainUrl = HTTPHelper.shared.Domain
        
        guard let url = URL(string: domainUrl) else { fatalError("baseURL could not be configured.")}
        return url
    }
    
    /// returns  path w.r.t. api type
    var path: String {
        switch self {
        case .Login:
            return Route.loginAPI.rawValue
        case .Post:
            return Route.postAPI.rawValue
        case .User:
            return Route.userAPI.rawValue
        }
    }
    
    /// return method w.r.t. API
    var httpMethod: Alamofire.HTTPMethod {
        switch self {
        case .Login, .User, .Post:
            return .get
        }
        
    }
}
