//
//  UserDetailViewController.swift
//  ch10-1871408-stackView
//
//  Created by JeongHyeon Lee on 2021/05/08.
//

import UIKit

class UserDetailViewController: UIViewController {
    
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwdTextField: UITextField!
    @IBOutlet weak var facilityTableView: UITableView!
    
    var user: User?
    var facilityGroup: FacilityGroup!
    var map: [String: Int] = [:]
}

extension UserDetailViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = user {
            idTextField.text = user.id
            nameTextField.text = user.name
            passwdTextField.text = user.passwd
            for name in user.uses {
                map[name] = 1
            }
            facilityTableView.dataSource = self
        }
    }
}

extension UserDetailViewController {
    override func viewWillDisappear(_ animated: Bool) {
        if let user = user {
            user.id = idTextField.text!
            user.name = nameTextField.text!
            user.passwd = passwdTextField.text
            user.uses = Array(map.keys)
        }
    }
}

extension UserDetailViewController {
    @IBAction func dismissUserViewController(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension UserDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return facilityGroup.count()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "facilityTableViewCell")!
        let facility = facilityGroup.facilities[indexPath.row]
        cell.textLabel!.text = facility.name
        cell.detailTextLabel!.text = "\(facility.open):00~\(facility.close):00, \(facility.unit)"
        let allowed = UISwitch(frame: CGRect())
        allowed.addTarget(self, action: #selector(facilityAllowed), for: .valueChanged)
        cell.accessoryView = allowed
        allowed.tag = indexPath.row
        if let _ = map[facility.name] {
            allowed.isOn = true
        }
        return cell
    }
}

extension UserDetailViewController {
    @objc func facilityAllowed(sender: UISwitch) {
        let facilityName = facilityGroup.facilities[sender.tag].name
        map[facilityName] = sender.isOn ? 1 : nil
    }
}
