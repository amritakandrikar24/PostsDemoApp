//
//  PostViewControllerViewModel.swift
//  LeagueMobileChallenge
//
//  Created by Amrita Kumar on 8/24/22.
//  Copyright © 2022 Kelvin Lau. All rights reserved.
//

import Combine
import Foundation

final class PostViewControllerViewModel {
    
    var users: [User] = []
    var posts: [Post] = []
    var reloadData: (() -> Void)?
    
    // Network coordinator use to call APIs
    private let service: ServiceCoordinator
    private let router = Router<EndPointConfig>()
    
    // Pass in an instance of `ServiceCoordinator`.
    // This will be used to pass in a mock during testing.
    init(service: ServiceCoordinator) {
        self.service = service
    }
    
    func fetchData() {
        // Create Group
        let group = DispatchGroup()
        
        // Add task to group
        group.enter()
        service.getAPIResponse(router: router, requestType: .Post, parameter: nil, headers: nil, model: [Post].self) { result in
            switch result {
            case Swift.Result.success(let response):
                self.posts = response
                break
            case Swift.Result.failure(_):
                break
            }
            group.leave()
        }
        
        // Add task to group
        group.enter()
        service.getAPIResponse(router: router, requestType: .User, parameter: nil, headers: nil, model: [User].self) { result in
            switch result {
            case Swift.Result.success(let response):
                self.users = response
                break
            case Swift.Result.failure(_):
                break
            }
            group.leave()
        }
        
        // Notify Completion of tasks on main thread.
        group.notify(queue: DispatchQueue.main) {
            DispatchQueue.main.async {
                self.reloadData?()
            }
        }
    }
}

