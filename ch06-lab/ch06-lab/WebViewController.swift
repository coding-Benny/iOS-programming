//
//  WebViewController.swift
//  ch06-lab
//
//  Created by JeongHyeon Lee on 2021/04/05.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let tabBarController = (parent as! UITabBarController).parent as! UITabBarController
        let cityViewController = tabBarController.viewControllers![0] as! CityViewController
        let (city, longitude, latitude) = cityViewController.getCurrentLonLat()

        let urlStr = city.addingPercentEncoding(withAllowedCharacters: .urlUserAllowed)!
        let url = URL(string: "https://en.wikipedia.org/wiki/\(urlStr)")!
        let request =  URLRequest(url: url)
        webView.load(request)
    }


}
