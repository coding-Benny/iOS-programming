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
        
        fahrenheitTextField = createTextField(placeHolder: "VALUE")
        celsiusLabel = createLabel("???", fontSize: 70)
        fdegreeLabel = createLabel("degrees Fahrenheit", fontSize: 36)
        cdegreeLabel = createLabel("degrees Celsius", fontSize: 36)
        
        connectVertically(views: fahrenheitTextField, fdegreeLabel, isLabel, celsiusLabel, cdegreeLabel, spacing: 8)
        connectHorizontally(views: [fahrenheitTextField, fdegreeLabel, isLabel, celsiusLabel, cdegreeLabel])
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
        label.font = UIFont(name: label.font.fontName, size: fontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        return label
    }
}

extension ConversionViewController {
    func connectVertically(views: UIView..., spacing: CGFloat) {
        for i in 0..<views.count - 1 {
            views[i].bottomAnchor.constraint(equalTo: views[i + 1].topAnchor, constant: spacing).isActive = true
        }
    }
}

extension ConversionViewController {
    func connectHorizontally(views: [UIView]) {
        for view in views {
            view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        }
    }
}

