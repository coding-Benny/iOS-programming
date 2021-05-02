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
}

extension UserDetailViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        user = user ?? User(random: true)
        idTextField.text = user!.id
        nameTextField.text = user!.name
        passwdTextField.text = user!.passwd
    }
}

extension UserDetailViewController {
    @IBAction func dismissUserViewController(_ sender: UIButton) {
    }
}
