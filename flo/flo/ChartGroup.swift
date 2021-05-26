//
//  ChartGroup.swift
//  flo
//
//  Created by JeongHyeon Lee on 2021/05/26.
//

import Foundation
import UIKit

class ChartGroup: NSObject {
    var chartList = [Music]()
    
    override init() {
        super.init()
    }
    
    func loadData() {
        
    }
    
    func count() -> Int {
        return chartList.count
    }
    
    func addMusic(music: Music) {
        chartList.append(music)
    }
}
