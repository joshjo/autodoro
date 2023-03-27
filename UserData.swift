//
//  UserData.swift
//  Autodoro
//
//  Created by Josue Ttito on 26/03/23.
//

import Foundation


class UserData {

    let userDefaults: UserDefaults
    
    enum Key: String {
        case lastValue
        case lastMode
        case autodoroCounter
        case workTime
        case shortBreakTime
        case longBreakTime
        case breaksToLong
    }
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        self.userDefaults.register(defaults: [
            Key.lastValue.rawValue: -1,
            Key.lastMode.rawValue: Mode.work.rawValue,
            Key.autodoroCounter.rawValue: 0,
            Key.workTime.rawValue: 25,
            Key.shortBreakTime.rawValue: 5,
            Key.longBreakTime.rawValue: 15,
            Key.breaksToLong.rawValue: 4
        ])
    }
    
    func getWorkTime() -> Int {
        return self.userDefaults.value(forKey: Key.workTime.rawValue) as? Int ?? 0
    }
    
    func getBreaksToLong() -> Int {
        return self.userDefaults.value(forKey: Key.breaksToLong.rawValue) as? Int ?? 0
    }
    
    func getLastValue() -> Int {
        return self.userDefaults.value(forKey: Key.lastValue.rawValue) as? Int ?? 0
    }
    
    func getLastMode() -> Int {
        return self.userDefaults.value(forKey: Key.lastMode.rawValue) as? Int ?? Mode.work.rawValue
    }
    
    func getAutodoroCounter() -> Int {
        return self.userDefaults.value(forKey: Key.autodoroCounter.rawValue) as? Int ?? 0
    }
    
    func getShortBreakTime() -> Int {
        return self.userDefaults.value(forKey: Key.shortBreakTime.rawValue) as? Int ?? 0
    }
    
    func getLongBreakTime() -> Int {
        return self.userDefaults.value(forKey: Key.longBreakTime.rawValue) as? Int ?? 0
    }
    
    func setLastValue(value: Int) {
        self.userDefaults.set(value, forKey: Key.lastValue.rawValue)
    }
    
    func setLastMode(value: Mode) {
        self.userDefaults.set(value.rawValue, forKey: Key.lastMode.rawValue)
    }
    
    func increaseAutodoroCounter() {
        let currentValue = getAutodoroCounter()
        self.userDefaults.set(currentValue + 1, forKey: Key.autodoroCounter.rawValue)
    }
}
