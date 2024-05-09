//
//  userDBModel.swift
//  ReadingSpeedTest
//
//  Created by Andrew Jenkins on 11/22/22.
//

import Foundation

class UserDBModel: Codable{
    var users: [User]
    
    init(){
        users = [User]()
        loadDatabase()
    }
    
    func loadDatabase(){
        users.append(User("Bob"))
        users.append(User("Jim"))
        users.append(User("George"))
    }
    
    func userAtIndex(_ idx: Int)-> User{
        return users[idx]
    }
    
    func count() -> Int{
        return users.count
    }
    
    func deleteUser(at idx: Int){
        users.remove(at: idx)
    }
    
    func addUser(_ u: User){
        users.append(u)
    }
    
}
