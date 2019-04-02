//
//  UserCell.swift
//  MobileLab1
//
//  Created by Max Rozhnov on 3/28/19.
//  Copyright © 2019 Max Rozhnov. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {

    @IBOutlet private var firstNameLabel: UILabel!
    @IBOutlet private var lastNameLabel: UILabel!
    @IBOutlet private var genderLabel: UILabel!
    @IBOutlet private var dateOfBirthLabel: UILabel!
    @IBOutlet private var profilePicture: UIImageView!
    private var modeledUser: UserModel?
    var user: UserModel? {
        get {
            return modeledUser
        }
        set {
            modeledUser = newValue
            firstNameLabel.text = modeledUser?.firstName
            lastNameLabel.text = modeledUser?.lastName
            genderLabel.text = modeledUser?.gender.rawValue
            dateOfBirth = modeledUser?.dateOfBirth ?? Date()
            profilePicture.image = modeledUser?.profilePicture
        }
    }

    var firstName: String {
        get {
            return firstNameLabel.text ?? ""
        }
        set {
            firstNameLabel.text = newValue
        }
    }
    var lastName: String {
        get {
            return lastNameLabel.text ?? ""
        }
        set {
            lastNameLabel.text = newValue
        }
    }
    var gender: Gender {
        get {
            return .male //temp
        }
        set {
            genderLabel.text = newValue.rawValue
        }
    }
    var dateOfBirth: Date {
        get {
            return Date(timeIntervalSinceNow: 0)
        }
        set {
            dateOfBirthLabel.text = "\(newValue.age) years old"
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        //self.contentView.
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension Date {
    var age: Int {
        return Calendar.current.dateComponents([.year], from: self, to: Date()).year ?? 0
    }
}