//
//  AllUsersController.swift
//  MobileLab1
//
//  Created by Max Rozhnov on 3/28/19.
//  Copyright © 2019 Max Rozhnov. All rights reserved.
//

import UIKit
import CoreData

class AllUsersController: UITableViewController {
    // MARK: - public properties
    public var login: String?
// MARK: - private properties
    private var loggedUserIndex: Int = 0
    private var users: [UserModel] = []
// MARK: - private functions
    private func updateTable() {
        if let pulledUsers = self.pullUsers() {
            self.users = pulledUsers
        }
        self.tableView.reloadData()
    }
    private func pullUsers() -> [UserModel]? {
        var retrievedUsers: [UserModel] = []
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserData")
        do {
            if let result = try managedContext.fetch(fetchRequest) as? [NSManagedObject] {
                for data in result {
                    if let user = getUser(from: data) {
                        retrievedUsers.append(user)
                    }
                }
                retrievedUsers.sort { $0.lastName < $1.lastName }
            } else {
                print("well...")
            }
        } catch {
            print(error)
        }
        return retrievedUsers
    }
    private func getUser(from data: NSManagedObject) -> UserModel? {
        guard let firstName = data.value(forKey: "firstName") as? String else { return nil }
        guard let middleName = data.value(forKey: "middleName") as? String else { return nil }
        guard let lastName = data.value(forKey: "lastName") as? String else { return nil }
        guard let dateOfBirth = data.value(forKey: "dateOfBirth") as? Date else { return nil }
        guard let genderString = data.value(forKey: "gender") as? String else { return nil }
        guard let login = data.value(forKey: "login") as? String else { return nil }
        guard let passwordHash = data.value(forKey: "passwordHash") as? Int else { return nil }
        let gender: Gender
        if genderString.lowercased() == "male" {
            gender = .male
        } else {
            gender = .female
        }
        guard let profilePictureData = data.value(forKey: "profilePicture") as? Data else { return nil }
        guard let profilePicture = UIImage(data: profilePictureData) else { return nil }
        guard let about = data.value(forKey: "about") as? String else { return nil }
        let user = UserModel(firstName: firstName,
                             middleName: middleName,
                             lastName: lastName,
                             dateOfBirth: dateOfBirth,
                             gender: gender,
                             login: login,
                             passwordHash: passwordHash,
                             profilePicture: profilePicture,
                             about: about)
        return user
    }
    private func deleteUser(at userIndex: Int) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserData")
        fetchRequest.predicate = NSPredicate(format: "login = %@", users[userIndex].login)
        do {
            let response = try managedContext.fetch(fetchRequest)
            if let userToDelete = response[0] as? NSManagedObject {
                managedContext.delete(userToDelete)
            }
            try managedContext.save()
        } catch {
            print(error)
        }
    }
    @objc func logOut() {
        print("logged out")
        self.navigationController?.popToRootViewController(animated: true)
    }
    @objc func addUser() {
        self.performSegue(withIdentifier: "addUserSegue", sender: nil)
    }
// MARK: - overriden functions
    override func viewDidLoad() {
        super.viewDidLoad()
        let backButton = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(logOut))
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addUser))
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.rightBarButtonItem = addButton
        tableView.register(UINib(nibName: "UserCell", bundle: nil), forCellReuseIdentifier: "cellIdentifier")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateTable()
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if loggedUserIndex != indexPath.row {
            return true
        } else {
            return false
        }
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier",
                                                    for: indexPath) as? UserCell {
            cell.user = users[indexPath.row]
            if users[indexPath.row].login == login {
                let label = UILabel(frame: CGRect(x: 0,
                                                  y: 0,
                                                  width: 40,
                                                  height: 40))
                loggedUserIndex = indexPath.row
                label.text = "👑"
                cell.accessoryView = label
            }
            return cell
        }
        return UITableViewCell()
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userData = users[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let controller = storyboard.instantiateViewController(withIdentifier: "profileView") as? RegistrationController {
            controller.user = userData
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteUser(at: indexPath.row)
            updateTable()
        }
    }
}
