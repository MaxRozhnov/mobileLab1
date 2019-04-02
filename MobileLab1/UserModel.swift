//
//  UserModel.swift
//  MobileLab1
//
//  Created by Max Rozhnov on 3/28/19.
//  Copyright © 2019 Max Rozhnov. All rights reserved.
//

import Foundation
import UIKit.UIImage

enum Gender: String {
    case male
    case female

//    init?(from: String) {
//        
//    }
}

struct UserModel {
    let firstName: String
    let middleName: String
    let lastName: String

    let dateOfBirth: Date

    let gender: Gender

    let login: String
    let passwordHash: Int

    let profilePicture: UIImage

    let about: String

    //todo add picture here
}
