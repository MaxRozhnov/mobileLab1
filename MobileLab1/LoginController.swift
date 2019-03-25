//
//  LoginController.swift
//  MobileLab1
//
//  Created by Max Rozhnov on 3/23/19.
//  Copyright © 2019 Max Rozhnov. All rights reserved.
//

import UIKit

class LoginController: UIViewController {

    @IBAction private func logInPressed(_ sender: Any) {
        print("user tried to log in with username: \(userName) and password: \(userPassword)")
        performSegue(withIdentifier: "successfullLoginSegue", sender: nil)
    }
    @IBOutlet private var userPasswordTextField: UITextField!

    @IBOutlet private var userNameTextField: UITextField!

    public var userName: String {
        return userNameTextField.text ?? ""
    }

    public var userPassword: String {
        return userPasswordTextField.text ?? ""
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        userNameTextField.delegate = self
        userPasswordTextField.delegate = self
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

extension LoginController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == userNameTextField {
            userPasswordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(LoginController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
