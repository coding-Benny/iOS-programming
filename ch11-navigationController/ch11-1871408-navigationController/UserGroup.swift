//
//  UserGroup.swift
//  ch09-1871408-tableView
//
//  Created by JeongHyeon Lee on 2021/04/18.
//

import Foundation

class UserGroup: NSObject {
    var users = [User]()
    
    override init() {
        super.init()
    }
    
    func testData() {
        for _ in 0...9 {
            users.append(User(random: true))
        }
    }
    
    func count() -> Int {
        return users.count
    }
    
    func addUser(user: User) {
        users.append(user)
    }
    
    func modifyUser(user: User, index: Int) {
        users[index] = user
    }
    
    func removeUser(index: Int) {
        users.remove(at: index)
    }
}
