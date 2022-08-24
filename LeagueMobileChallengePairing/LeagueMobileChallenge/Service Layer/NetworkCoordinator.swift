//
//  NetworkCoordinator.swift
//  LeagueMobileChallenge
//
//  Created by Amrita Kumar on 8/24/22.
//  Copyright © 2022 Kelvin Lau. All rights reserved.
//

import Foundation
import Alamofire

enum NetworkResponse:String {
    case success
    case authenticationError = "You need to be authenticated first."
    case badRequest = "Bad request"
    case outdated = "The url you requested is outdated."
    case failed = "Network request failed."
    case noData = "Response returned with no data to decode."
    case unableToDecode = "We could not decode the response."
}

enum Result<String>{
    case success
    case failure(String)
}
protocol ServiceCoordinator {
    
    func getAPIResponse<T : Codable, router: NetworkRouter>(router: router, requestType: EndPointConfig, parameter:Parameters?, headers:HTTPHeaders?, model: T.Type, completion: @escaping((Swift.Result<T, ErrorModel>)) ->  Void) where router.EndPoint == EndPointConfig
}

struct NetworkCoordinator: ServiceCoordinator {
    
    // Call router request with generic response and request type
    func getAPIResponse<T : Codable, router: NetworkRouter>(router: router, requestType: EndPointConfig, parameter:Parameters?, headers:HTTPHeaders?, model: T.Type, completion: @escaping((Swift.Result<T, ErrorModel>)) ->  Void) where router.EndPoint == EndPointConfig {
        router.request(requestType, parmeter: parameter, headers: headers) { (data, statusCode, error) in

            if error != nil {
                let error: ErrorModel = ErrorModel(ErrorKey.general.rawValue)
                completion(Swift.Result.failure(error))
            }

            if let statusCode = statusCode {
                let result = self.handleNetworkResponse(statusCode)

                switch result {
                case .success:
                    guard let responseData = data else {
                        let error: ErrorModel = ErrorModel(ErrorKey.parsing.rawValue)
                        completion(Swift.Result.failure(error))
                        return
                    }

                    // Decode response 
                    guard let responseModel = try? JSONDecoder().decode(T.self, from: responseData) else {
                        let error: ErrorModel = ErrorModel(ErrorKey.parsing.rawValue)

                        completion(Swift.Result.failure(error))
                        return
                    }
                    completion(Swift.Result.success(responseModel))

                case .failure( _):
                    completion(Swift.Result.failure(ErrorModel(ErrorKey.parsing.rawValue)))
                }
            }
        }
    }
    
    // Returns response status based on status code
    fileprivate func handleNetworkResponse(_ statusCode: Int) -> Result<String>{
        switch statusCode {
        case 200...299: return .success
        case 401...500: return .failure(NetworkResponse.authenticationError.rawValue)
        case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
        case 600: return .failure(NetworkResponse.outdated.rawValue)
        default: return .failure(NetworkResponse.failed.rawValue)
        }
    }
}
