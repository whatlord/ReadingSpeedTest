//
//  userModel.swift
//  ReadingSpeedTest
//
//  Created by Andrew Jenkins on 11/22/22.
//

import Foundation

class User: Codable{
    var username: String
    var history: Array<Int>
    var tries: Int
    
    init(_ un:String){
        self.username = un
        self.history = []
        self.tries = 0
    }
    
    func topSpeed()->Int?{
        return history.max()
    }
    
    func lastThree()->(Array<Int?>){
        var speeds:Array<Int> = []
        for x in history.reversed(){
            if(!speeds.contains(x)){
                speeds.append(x)
            }
        }
        switch(speeds.count){
        case 0:
            return [0,0,0]
        case 1:
            return [speeds[0],0,0]
        case 2:
            return [speeds[0],speeds[1],0]
        default:
            return Array(speeds[0...2])
        }
    }
    
    func speedCount(_ num:Int)->Int{
        return history.filter { record in
                return record == num
        }.count
    }
    
    func addTry(_ x:Int){
        history.append(x)
    }
    
}
