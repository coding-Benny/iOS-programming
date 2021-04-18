//
//  ViewController.swift
//  ch09-1871408-tableView
//
//  Created by JeongHyeon Lee on 2021/04/18.
//

import UIKit

class UserGroupViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var userGroup: UserGroup!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        userGroup = UserGroup()
        userGroup.testData()
        
        tableView.dataSource = self
    }


}

extension UserGroupViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userGroup.count()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "UITableViewCell")
        
        let user = userGroup.users[indexPath.row]
        cell.textLabel!.text = user.id
        cell.detailTextLabel!.text = user.name
        return cell
    }
}
