//
//  ViewController.swift
//  ch05-1871408-programmingView
//
//  Created by JeongHyeon Lee on 2021/03/24.
//

import UIKit

class ConversionViewController: UIViewController {

}

extension ConversionViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let helloLabel = UILabel(frame: CGRect(x: 100, y: 100, width: 200, height: 30))
        helloLabel.text = "Hello, autolayout"
        helloLabel.backgroundColor = .green
        helloLabel.textAlignment = .center
        
        view.addSubview(helloLabel)
    }
}

