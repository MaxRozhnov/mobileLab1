//
//  UserModel.swift
//  MobileLab1
//
//  Created by Max Rozhnov on 3/28/19.
//  Copyright © 2019 Max Rozhnov. All rights reserved.
//

import Foundation

enum Gender: String {
    case male = "Male"
    case female = "Female"
}

struct User {
    let firstName: String
    let middleName: String
    let lastName: String

    let dateOfBirth: Date

    let gender: Gender

    //todo add picture here
}
