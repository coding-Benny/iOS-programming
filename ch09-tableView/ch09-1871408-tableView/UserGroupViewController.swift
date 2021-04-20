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
