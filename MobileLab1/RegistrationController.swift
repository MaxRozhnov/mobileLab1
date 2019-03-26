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

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.hideKeyboardWhenTappedAround()
        self.aboutTextView.delegate = self
        self.aboutTextView.textColor = .lightGray
        self.aboutTextView.layer.borderWidth = 0.5
        self.aboutTextView.layer.cornerRadius = 5.0
        self.aboutTextView.layer.borderColor = UIColor.lightGray.cgColor
//        self.miscellaneousTextView.text = "Please tell us about yourself in a few words."
//
//        NotificationCenter.default.addObserver(
//            self,
//            selector: #selector(keyboardWillShow),
//            name: UIResponder.keyboardWillShowNotification,
//            object: nil
//        )
        // Do any additional setup after loading the view.
    }

    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
        }
        if let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
        }
        if let animationCurve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt {
        }
    }
}

extension RegistrationController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            print("nilled")
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text =  "Please tell us about yourself in a few words."
            textView.textColor = UIColor.lightGray
        }
//        UIView.animate(withDuration: animationDuration) {
//            self.view.frame.origin.y = 0
//        }
    }
}
