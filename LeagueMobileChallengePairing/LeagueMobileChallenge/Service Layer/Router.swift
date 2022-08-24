//
//  Router.swift
//  LeagueMobileChallenge
//
//  Created by Amrita Kumar on 8/24/22.
//  Copyright © 2022 Kelvin Lau. All rights reserved.
//

import Foundation
import Alamofire

public typealias NetworkRouterCompletion = (_ data: Data?,_ statusCode: Int?,_ error: Error?)->()

protocol NetworkRouter {
    
    associatedtype EndPoint: EndPointConfigProtocol
    func request(_ route: EndPoint, parmeter: Parameters?, headers: HTTPHeaders?, completion: @escaping NetworkRouterCompletion)
}

struct Router<EndPoint: EndPointConfigProtocol>: NetworkRouter {
    // construct url and call Alamofire
    func request(_ route: EndPoint, parmeter: Parameters?, headers: HTTPHeaders?, completion: @escaping NetworkRouterCompletion) {
        
        guard let url = URL(string: route.baseURL.absoluteString + route.path) else {
            completion(nil, nil, HTTPNetworkError.missingURL)
            return
        }
        
        let apiCall: (Error?) -> Void = { error in
            guard error == nil else {
                return
            }
            let authHeader: HTTPHeaders = ["x-access-token" : HTTPHelper.shared.apiKey]
            Alamofire.request(url, method: route.httpMethod, parameters: parmeter, encoding: URLEncoding.default, headers: authHeader).responseJSON { (response) in
                completion(response.data, response.response?.statusCode, response.error)
            }
        }
        
        // call auth / login api if apikey not found
        if HTTPHelper.shared.apiKey.isEmpty {
            callAuth() { error in
                apiCall(error)
            }
        } else {
            apiCall(nil)
        }
    }
    
    func callAuth(completion: @escaping (Error?) -> Void) {
        var headers: HTTPHeaders = [:]
        
        if let authorizationHeader = Request.authorizationHeader(user: HTTPHelper.shared.user, password: HTTPHelper.shared.password) {
            headers[authorizationHeader.key] = authorizationHeader.value
        }
        let authEndPoint: EndPointConfig = .Login
        
        guard let url = URL(string: authEndPoint.baseURL.absoluteString + authEndPoint.path) else {
            completion(HTTPNetworkError.missingURL)
            return
        }
        
        Alamofire.request(url, headers: headers).responseJSON { (response) in
            guard response.error == nil else {
                completion(HTTPNetworkError.authenticationError)
                return
            }
            
            if let value = response.result.value as? [AnyHashable : Any],
               let key = value["api_key"] as? String {
                HTTPHelper.shared.apiKey = key
                completion(nil)
            } else {
                completion(HTTPNetworkError.authenticationError)
            }
            
        }
    }
}
