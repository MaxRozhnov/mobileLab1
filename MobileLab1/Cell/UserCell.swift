//
//  UserCell.swift
//  MobileLab1
//
//  Created by Max Rozhnov on 3/28/19.
//  Copyright © 2019 Max Rozhnov. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {
// MARK: - Outlets
    @IBOutlet private var firstNameLabel: UILabel!
    @IBOutlet private var lastNameLabel: UILabel!
    @IBOutlet private var genderLabel: UILabel!
    @IBOutlet private var dateOfBirthLabel: UILabel!
    @IBOutlet private var profilePicture: UIImageView!
// MARK: - public properties
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
// MARK: - private properties
    private var modeledUser: UserModel?
    private var firstName: String {
        get {
            return firstNameLabel.text ?? ""
        }
        set {
            firstNameLabel.text = newValue
        }
    }
    private var lastName: String {
        get {
            return lastNameLabel.text ?? ""
        }
        set {
            lastNameLabel.text = newValue
        }
    }
    private var gender: Gender {
        get {
            return .male
        }
        set {
            genderLabel.text = newValue.rawValue
        }
    }
    private var dateOfBirth: Date {
        get {
            return Date(timeIntervalSinceNow: 0)
        }
        set {
            dateOfBirthLabel.text = "\(newValue.age) years old"
        }
    }
// MARK: - overriden functions
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
// MARK: - extensions
extension Date {
    var age: Int {
        return Calendar.current.dateComponents([.year], from: self, to: Date()).year ?? 0
    }
}
