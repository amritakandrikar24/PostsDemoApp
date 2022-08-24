//
//  PostResponseModel.swift
//  LeagueMobileChallenge
//
//  Created by Amrita Kumar on 8/23/22.
//  Copyright © 2022 Kelvin Lau. All rights reserved.
//

import Foundation

struct Post: Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}
