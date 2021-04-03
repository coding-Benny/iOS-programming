//
//  MapViewController.swift
//  ch06-1871408-tabBarController
//
//  Created by JeongHyeon Lee on 2021/04/03.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("MapViewController.viewDidLoad")
    }
    

}

extension MapViewController {
    override func viewWillAppear(_ animated: Bool) {
        print("MapViewController.viewWillAppear")
    }
}
