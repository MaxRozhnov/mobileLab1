//
//  RegistrationController.swift
//  MobileLab1
//
//  Created by Max Rozhnov on 3/18/19.
//  Copyright © 2019 Max Rozhnov. All rights reserved.
//

import UIKit
import CoreData

class RegistrationController: UIViewController {

    public var user: UserModel? {
        get {
            return selectedUser
        }
        set {
            selectedUser = newValue
        }
    }

    private var selectedUser: UserModel?

    @IBAction private func pictureTapped(_ sender: Any) {
        view.endEditing(true)
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Take Photo", style: .default) { _ in
            self.openCamera()
        })
        alert.addAction(UIAlertAction(title: "Choose Photo", style: .default) { _ in
            self.openGallary()
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    @IBOutlet private var stackView: UIStackView!
    @IBOutlet private var userPic: UIImageView!
    @IBOutlet private var firstNameTextField: UITextField!
    @IBOutlet private var middleNameTextField: UITextField!
    @IBOutlet private var lastNameTextField: UITextField!
    @IBOutlet private var genderSegmentedControl: UISegmentedControl!
    @IBOutlet private var birthDatePicker: UIDatePicker!
    @IBOutlet private var aboutTextView: UITextView!
    @IBOutlet private var contentView: UIView!
    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var constraintContentHeight: NSLayoutConstraint!

    @IBOutlet private var loginTextField: UITextField!
    @IBOutlet private var passwordTextField: UITextField!
    @IBOutlet private var repeatPasswordTextField: UITextField!

    private var lastOffset: CGPoint?
    private var activeField: UITextField?
    private var aboutFieldIsActive: Bool = false
    private var keyboardHeight: CGFloat?

    private var imagePicker = UIImagePickerController()

    private var firstName: String {
        return firstNameTextField.text ?? ""
    }
    private var middleName: String {
        return middleNameTextField.text ?? ""
    }
    private var lastName: String {
        return lastNameTextField.text ?? ""
    }
    private var gender: Gender {
        switch genderSegmentedControl.selectedSegmentIndex {
        case 0:
            return .male
        case 1:
            return .female
        default:
            return .male
        }
    }
    private var birthDate: Date {
        return birthDatePicker.date
    }
    private var login: String {
        return loginTextField.text ?? ""
    }
    private var password: String {
        return passwordTextField.text ?? ""
    }
    private var retypedPassword: String {
        return repeatPasswordTextField.text ?? ""
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if let selectedUserData = selectedUser {
            self.navigationItem.title = "\(selectedUserData.firstName) \(selectedUserData.lastName)"
            viewSetup()
            self.firstNameTextField.text = selectedUserData.firstName
            self.middleNameTextField.text = selectedUserData.middleName
            self.lastNameTextField.text = selectedUserData.lastName
            switch selectedUserData.gender {
            case .male:
                self.genderSegmentedControl.selectedSegmentIndex = 0
            case.female:
                self.genderSegmentedControl.selectedSegmentIndex = 1
            }
            self.birthDatePicker.date = selectedUserData.dateOfBirth
            self.loginTextField.text = selectedUserData.login
            self.passwordTextField.text = "secure"
            self.repeatPasswordTextField.text = "secure"
            self.hideKeyboardWhenTappedAround()

            self.loginTextField.isHidden = true
            self.passwordTextField.isHidden = true
            self.repeatPasswordTextField.isHidden = true
            self.userPic.image = selectedUserData.profilePicture
        } else {
            self.navigationItem.title = "Registration"
            viewSetup()
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let allUsersController = segue.destination as? AllUsersController {
            allUsersController.login = login
        }
    }

    @objc func keyboardWillShow(_ notification: Notification) {
        guard keyboardHeight == nil else {
            return
        }
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardHeight = keyboardRectangle.height
            UIView.animate(withDuration: 0.3) {
                self.constraintContentHeight.constant += self.keyboardHeight ?? 0
            }
            let frameOrigin = activeField?.frame.origin.y ?? aboutTextView.frame.origin.y
            let frameHeight = activeField?.frame.size.height ?? aboutTextView.frame.size.height
            changeScrollViewOffset(frameOrigin: frameOrigin, frameHeight: frameHeight)
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.constraintContentHeight.constant -= self.keyboardHeight ?? 0
            self.scrollView.contentOffset = self.lastOffset ?? CGPoint()
        }
        keyboardHeight = nil
    }
    @objc func validateUserData() {
        var invalidFields: [UIView] = []
        if firstName.isEmpty {
            invalidFields.append(firstNameTextField)
        }
        if lastName.isEmpty {
            invalidFields.append(lastNameTextField)
        }
        if login.isEmpty {
            invalidFields.append(loginTextField)
        }
        if password.isEmpty || password != retypedPassword {
            invalidFields.append(passwordTextField)
            invalidFields.append(repeatPasswordTextField)
        }
        if userPic.image == #imageLiteral(resourceName: "UserPicPlaceholder") {
            invalidFields.append(userPic)
        }
        if invalidFields.isEmpty {
            let user = UserModel(firstName: firstName,
                                 middleName: middleName,
                                 lastName: lastName,
                                 dateOfBirth: birthDate,
                                 gender: gender,
                                 login: login,
                                 passwordHash: password.hash,
                                 profilePicture: userPic.image ?? #imageLiteral(resourceName: "UserPicPlaceholder"))
            saveToDatabase(userData: user)
        } else {
            self.highlight(views: invalidFields, withDuration: 3.0)
        }
    }

    func highlight(views: [UIView], withDuration seconds: TimeInterval) {
        for view in views {
            if view is UITextView || view is UIImageView {
                view.layer.borderColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
            }
            view.layer.borderWidth = 1.0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            for view in views {
                if view is UITextView || view is UIImageView {
                    view.layer.borderWidth = 0.5
                    view.layer.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
                } else {
                    view.layer.borderWidth = 0.0
                }
            }
        }
    }
    func changeScrollViewOffset(frameOrigin: CGFloat, frameHeight: CGFloat) {
        let distanceToBottom = self.scrollView.frame.size.height - frameOrigin - frameHeight
        var collapseSpace: CGFloat = keyboardHeight ?? 335.0
        collapseSpace -= distanceToBottom
        if collapseSpace < 0 {
            return
        }
        UIView.animate(withDuration: 0.3) {
            if let xValue = self.lastOffset?.x {
                self.scrollView.contentOffset = CGPoint(x: xValue, y: collapseSpace + 10)
            }
        }
    }
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Warning",
                                          message: "You don't have camera",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK",
                                          style: .default,
                                          handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    func openGallary() {
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    func saveToDatabase(userData: UserModel) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        if selectedUser == nil {
            guard let userEntity = NSEntityDescription.entity(forEntityName: "UserData", in: managedContext) else { print("WUT???"); return }
            let user = NSManagedObject(entity: userEntity, insertInto: managedContext)
            user.setValue(userData.firstName, forKey: "firstName")
            user.setValue(userData.middleName, forKey: "middleName")
            user.setValue(userData.lastName, forKey: "lastName")
            user.setValue(userData.dateOfBirth, forKey: "dateOfBirth")
            user.setValue(userData.gender.rawValue, forKey: "gender")
            user.setValue(selectedUser?.login ?? userData.login, forKey: "login")
            user.setValue(selectedUser?.passwordHash ?? userData.passwordHash, forKey: "passwordHash")
            if let imageData = UIImage.jpegData(userData.profilePicture)(compressionQuality: 1) {
                user.setValue(imageData, forKey: "profilePicture")
            }
        } else {
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "UserData")
            let format = selectedUser?.login ?? ""
            print("format is \(format)")
            fetchRequest.predicate = NSPredicate(format: "login = %@", selectedUser?.login ?? "")
            do {
                let response = try managedContext.fetch(fetchRequest)
                if let user = response[0] as? NSManagedObject {
                    user.setValue(userData.firstName, forKey: "firstName")
                    user.setValue(userData.middleName, forKey: "middleName")
                    user.setValue(userData.lastName, forKey: "lastName")
                    user.setValue(userData.dateOfBirth, forKey: "dateOfBirth")
                    user.setValue(userData.gender.rawValue, forKey: "gender")
                    user.setValue(selectedUser?.login ?? userData.login, forKey: "login")
                    user.setValue(selectedUser?.passwordHash ?? userData.passwordHash, forKey: "passwordHash")
                    if let imageData = UIImage.jpegData(userData.profilePicture)(compressionQuality: 1) {
                        user.setValue(imageData, forKey: "profilePicture")
                    }
                }
            } catch {
                print(error)
            }
        }
        if selectedUser == nil {
            performSegue(withIdentifier: "successfullSignUpSegue", sender: nil)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }

    private func viewSetup() {
        self.userPic.layer.borderWidth = 0.5
        self.userPic.layer.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        self.userPic.layer.cornerRadius = userPic.bounds.width / 2

        self.hideKeyboardWhenTappedAround()
        self.aboutTextView.delegate = self
        self.aboutTextView.textColor = .lightGray
        self.aboutTextView.layer.borderWidth = 0.5
        self.aboutTextView.layer.cornerRadius = 5.0
        self.aboutTextView.layer.borderColor = UIColor.lightGray.cgColor

        self.firstNameTextField.delegate = self
        self.middleNameTextField.delegate = self
        self.lastNameTextField.delegate = self
        self.loginTextField.delegate = self
        self.passwordTextField.delegate = self
        self.repeatPasswordTextField.delegate = self

        self.firstNameTextField.layer.borderColor = UIColor.red.cgColor
        self.middleNameTextField.layer.borderColor = UIColor.red.cgColor
        self.lastNameTextField.layer.borderColor = UIColor.red.cgColor
        self.loginTextField.layer.borderColor = UIColor.red.cgColor
        self.passwordTextField.layer.borderColor = UIColor.red.cgColor
        self.repeatPasswordTextField.layer.borderColor = UIColor.red.cgColor

        self.firstNameTextField.layer.cornerRadius = 5.0
        self.middleNameTextField.layer.cornerRadius = 5.0
        self.lastNameTextField.layer.cornerRadius = 5.0
        self.loginTextField.layer.cornerRadius = 5.0
        self.passwordTextField.layer.cornerRadius = 5.0
        self.repeatPasswordTextField.layer.cornerRadius = 5.0

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                                 target: self,
                                                                 action: #selector(validateUserData))

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
}

extension RegistrationController: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        aboutFieldIsActive = true
        let frameOrigin = stackView.frame.origin.y + aboutTextView.frame.origin.y
        let frameHeight = aboutTextView.frame.size.height//aboutTextView.frame.size.height
        changeScrollViewOffset(frameOrigin: frameOrigin, frameHeight: frameHeight)
        lastOffset = self.scrollView.contentOffset
        return true
    }

    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        aboutFieldIsActive = false
        return true
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text =  "Please tell us about yourself in a few words."
            textView.textColor = UIColor.lightGray
        }
    }
}
extension RegistrationController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        activeField = textField
        lastOffset = self.scrollView.contentOffset
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        lastOffset = self.scrollView.contentOffset
        if textField.isDescendant(of: stackView) {
        changeScrollViewOffset(frameOrigin: stackView.frame.origin.y + textField.frame.origin.y,
                               frameHeight: textField.frame.size.height)
        } else {
            changeScrollViewOffset(frameOrigin: textField.frame.origin.y,
                                   frameHeight: textField.frame.size.height)
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        activeField = nil
        return true
    }
}
extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.userPic.image = editedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.isNavigationBarHidden = false
        self.dismiss(animated: true, completion: nil)
    }
}
