//
//  FacilityGroup.swift
//  ch10-1871408-stackView
//
//  Created by JeongHyeon Lee on 2021/05/09.
//

import Foundation

class FacilityGroup {
    var facilities = [Facility]()
    
    init() {
        Facility.count = 0
    }
    
    func testData() {
        for _ in 0...10 {
            facilities.append(Facility(random: true))
        }
    }
    
    func count() -> Int {
        return facilities.count
    }
    
    func addFacility(facility: Facility) {
        facilities.append(facility)
    }
    
    func modifyFacility(facility: Facility, index: Int) {
        facilities[index] = facility
    }
    
    func removeFacility(index: Int) {
        facilities.remove(at: index)
    }
}
