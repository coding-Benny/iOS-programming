//
//  ViewController.swift
//  ch05-lab
//
//  Created by JeongHyeon Lee on 2021/03/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var communityPickerView: UIPickerView!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordChangeButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var communityLabel: UILabel!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        communityPickerView.translatesAutoresizingMaskIntoConstraints = false
        loginTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordChangeButton.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        communityLabel.translatesAutoresizingMaskIntoConstraints = false
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        passwordLabel.translatesAutoresizingMaskIntoConstraints = false
        
        loginTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        let x = loginTextField.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 50)
        x.isActive = true
        loginTextField.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        
        loginTextField.topAnchor.constraint(equalTo: communityPickerView.bottomAnchor, constant: 10).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: loginTextField.bottomAnchor, constant: 10).isActive = true
        passwordChangeButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 10).isActive = true
        confirmButton.topAnchor.constraint(equalTo: passwordChangeButton.bottomAnchor, constant: 10).isActive = true
        
        communityPickerView.leadingAnchor.constraint(equalTo: loginTextField.leadingAnchor).isActive = true
        passwordTextField.leadingAnchor.constraint(equalTo: loginTextField.leadingAnchor).isActive = true
        passwordChangeButton.leadingAnchor.constraint(equalTo: loginTextField.leadingAnchor).isActive = true
        confirmButton.leadingAnchor.constraint(equalTo: loginTextField.leadingAnchor).isActive = true
        
        communityPickerView.widthAnchor.constraint(equalTo: loginTextField.widthAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: loginTextField.widthAnchor).isActive = true
        
        communityLabel.centerYAnchor.constraint(equalTo: communityPickerView.centerYAnchor).isActive = true
        loginLabel.centerYAnchor.constraint(equalTo: loginTextField.centerYAnchor).isActive = true
        passwordLabel.centerYAnchor.constraint(equalTo: passwordTextField.centerYAnchor).isActive = true
        
        communityLabel.trailingAnchor.constraint(equalTo: loginTextField.leadingAnchor, constant: -10).isActive = true
        loginLabel.trailingAnchor.constraint(equalTo: loginTextField.leadingAnchor, constant: -10).isActive = true
        passwordLabel.trailingAnchor.constraint(equalTo: loginTextField.leadingAnchor, constant: -10).isActive = true
        
        communityPickerView.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
}



