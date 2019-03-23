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
        print("user pressed log in")
    }
    @IBOutlet private var userPasswordField: UITextField!


    @IBOutlet private var userNameTextField: UITextField!


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
