//
//  ViewController.swift
//  ch05-1871408-programmingView
//
//  Created by JeongHyeon Lee on 2021/03/24.
//

import UIKit

class ConversionViewController: UIViewController {

    var fahrenheitTextField: UITextField!
    var celsiusLabel: UILabel!
    var fdegreeLabel, isLabel, cdegreeLabel: UILabel!
}

extension ConversionViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isLabel = createLabel("is", fontSize: 36)
        isLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        isLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
    }
}

extension ConversionViewController {
    func createTextField(placeHolder: String) -> UITextField {
        let textField = UITextField(frame: CGRect())
        textField.textAlignment = .center
        textField.placeholder = placeHolder
        textField.font = UIFont(name: textField.font!.fontName, size: 70)
        textField.keyboardType = .decimalPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textField)
        return textField
    }
}

extension ConversionViewController {
    func createLabel(_ text: String, fontSize: CGFloat) -> UILabel {
        
        let label = UILabel(frame: CGRect())
        label.text = text
        label.textColor = UIColor(red: CGFloat(0xe1)/CGFloat(256), green: CGFloat(0x58)/CGFloat(256), blue: CGFloat(0x29)/CGFloat(256), alpha: CGFloat(1))
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        return label
    }
}

