//
//  LoginController.swift
//  MobileLab1
//
//  Created by Max Rozhnov on 3/23/19.
//  Copyright © 2019 Max Rozhnov. All rights reserved.
//

import UIKit
import CoreData

class LoginController: UIViewController {

    @IBAction private func logInPressed(_ sender: Any) {
        print("user tried to log in with username: \(userName) and password: \(userPassword.hash)")
        print(loginCredentials)
        if loginCredentials[userName] == userPassword.hash {
            performSegue(withIdentifier: "successfullLoginSegue", sender: nil)
        } else {
            //tell user
        }
    }
    @IBOutlet private var userPasswordTextField: UITextField!

    @IBOutlet private var userNameTextField: UITextField!

    public var userName: String {
        return userNameTextField.text ?? ""
    }

    public var userPassword: String {
        return userPasswordTextField.text ?? ""
    }
    private var loginCredentials: [String: Int] = [:]

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

    @objc func logOut(sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("dnd".hash)
        self.hideKeyboardWhenTappedAround()
        userNameTextField.delegate = self
        userPasswordTextField.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserData")
        do {
            if let result = try managedContext.fetch(fetchRequest) as? [NSManagedObject] {
                for data in result {
                    guard let login = data.value(forKey: "login") as? String else { return }
                    guard let passwordHash = data.value(forKey: "passwordHash") as? Int else { return }
                    self.loginCredentials[login] = passwordHash
                }
            } else {
                print("well...")
            }
        } catch {
            print(error)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "successfullLoginSegue" {
            if let allUsersController = segue.destination as? AllUsersController {
                allUsersController.login = userName
            }
        }
    }
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
