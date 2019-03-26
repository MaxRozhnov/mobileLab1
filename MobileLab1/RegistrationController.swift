//
//  RegistrationController.swift
//  MobileLab1
//
//  Created by Max Rozhnov on 3/18/19.
//  Copyright © 2019 Max Rozhnov. All rights reserved.
//

import UIKit

class RegistrationController: UIViewController {
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

    override func viewDidLoad() {
        super.viewDidLoad()
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

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(validateUserData))

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
        var dataIsValid = true
        if let personName = firstNameTextField.text {
            if personName.isEmpty {
                //highlight field
                dataIsValid = false
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
}

extension RegistrationController: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        aboutFieldIsActive = true
        let frameOrigin = aboutTextView.frame.origin.y
        let frameHeight = aboutTextView.frame.size.height
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
        changeScrollViewOffset(frameOrigin: textField.frame.origin.y,
                               frameHeight: textField.frame.size.height)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        activeField = nil
        return true
    }
}
