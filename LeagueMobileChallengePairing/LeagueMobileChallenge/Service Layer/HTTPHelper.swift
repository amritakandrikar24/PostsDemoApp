//
//  HTTPHelper.swift
//  LeagueMobileChallenge
//
//  Created by Amrita Kumar on 8/24/22.
//  Copyright © 2022 Kelvin Lau. All rights reserved.
//

import Foundation

class HTTPHelper {
    static let shared = HTTPHelper()
    // Domain for all envorment (PROD, UAT, QA)
    // Enum should be used for more than 1 domain
    var Domain = "https://engineering.league.dev/challenge/api/"
    let user = "user"
    let password = "password"
    
    var apiKey = ""
}

// Add new api routes here Also add in 'EndPointConfig'
enum Route: String {
    case loginAPI = "login"
    case postAPI  = "posts"
    case userAPI  = "users"
}

public enum HTTPMethod : String {
    case get     = "GET"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
}
