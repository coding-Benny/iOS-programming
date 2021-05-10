//
//  Facility.swift
//  ch10-1871408-stackView
//
//  Created by JeongHyeon Lee on 2021/05/09.
//

import Foundation

class Facility {
    static var count: Int = 0
    var name: String
    var open: Int
    var close: Int
    var unit: Int
    
    init(name: String, open: Int, close: Int, unit: Int) {
        self.name = name
        self.open = open
        self.close = close
        self.unit = unit
    }
}

extension Facility {
    convenience init(random: Bool = false) {
        if random == false {
            self.init(name: "", open: 0, close: 24, unit: 1)
            return
        }
        let names = ["Football", "Tennis", "Basketball"]
        let opens = [6, 8, 10]
        let closes = [14, 16, 18]
        
        var index = Facility.count % names.count
        Facility.count += 1
        let name = names[index] + String.init(format: "%02d", Facility.count)
        
        index = Int(arc4random_uniform(UInt32(opens.count)))
        let open = opens[index]
        
        index = Int(arc4random_uniform(UInt32(opens.count)))
        let close = closes[index]
        
        let unit = Int(arc4random_uniform(UInt32(4))) + 1
        self.init(name: name, open: open, close: close, unit: unit)
    }
}
