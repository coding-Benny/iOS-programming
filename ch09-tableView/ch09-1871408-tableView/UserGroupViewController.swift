//
//  ViewController.swift
//  ch09-1871408-tableView
//
//  Created by JeongHyeon Lee on 2021/04/18.
//

import UIKit

class UserGroupViewController: UIViewController {

    @IBOutlet weak var userTableView: UITableView!
    var userGroup: UserGroup!

}

extension UserGroupViewController {
    @IBAction func editTable(_ sender: UIButton) {
        if userTableView.isEditing == true {
            userTableView.isEditing = false
            sender.setTitle("Edit", for: .normal)
        } else {
            userTableView.isEditing = true
            sender.setTitle("Done", for: .normal)
        }
    }
}

extension UserGroupViewController {
    @IBAction func addUser(_ sender: UIButton) {
        let user = User(random: true)
        userGroup.addUser(user: user)
        let indexPath = IndexPath(row: userGroup.count() - 1, section: 0)
        userTableView.insertRows(at: [indexPath], with: .automatic)
    }
}

extension UserGroupViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        userGroup = UserGroup()
        userGroup.testData()
        
        userTableView.dataSource = self
        userTableView.delegate = self
        // userTableView.isEditing = true
    }
}

extension UserGroupViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userGroup.count()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // let cell = UITableViewCell(style: .value1, reuseIdentifier: "UITableViewCell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell")!
        
        let user = userGroup.users[indexPath.row]
        cell.textLabel!.text = user.id
        cell.detailTextLabel!.text = user.name
        cell.backgroundColor = .white
        
        if indexPath.row % 2 == 0 {
            cell.accessoryType = .checkmark  // type
        } else {
            cell.accessoryView = UISwitch(frame: CGRect())
        }
        return cell
    }
}

extension UserGroupViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)!.backgroundColor = .green
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)!.backgroundColor = .white
    }
}

extension UserGroupViewController {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            userGroup.removeUser(index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

extension UserGroupViewController {
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let from = userGroup.users[sourceIndexPath.row]
        let to = userGroup.users[destinationIndexPath.row]
        userGroup.modifyUser(user: from, index: destinationIndexPath.row)
        userGroup.modifyUser(user: to, index: sourceIndexPath.row)
        tableView.moveRow(at: sourceIndexPath, to: destinationIndexPath)
    }
}
