//
//  AutodoroApp.swift
//  Autodoro
//
//  Created by Josue Ttito on 25/03/23.
//

import SwiftUI


enum Mode: Int {
    case work
    case break_
}


extension String {

    func padLeft(totalWidth: Int, with byString: String) -> String {
        let toPad = totalWidth - self.count
        if toPad < 1 {
            return self
        }
    
        return "".padding(toLength: toPad, withPad: byString, startingAt: 0) + self
    }
}

class StopWatch: ObservableObject {
    @Published var ticker: Int
    var lastTicker: Int = -1
    var workTime: Int
    var seconds = 60
    @Published var isPaused: Bool = false
    var userData: UserData
    @Published var mode: Mode  // 0 Is for focus time, 1 is for spare time
    var timer = Timer()
    
    init(userData: UserData) {
        self.userData = userData
        let lastValue = userData.getLastValue()
        self.workTime = userData.getWorkTime()
        self.mode = userData.getLastMode() == Mode.work.rawValue ? Mode.work : Mode.break_
        self.ticker = lastValue >= 0 ? lastValue : userData.getWorkTime()
        self.ticker = self.ticker * 60
    }

    func start() {
        SoundManager.instance.playSound(mode:self.mode)
        self.timer = Timer.scheduledTimer(withTimeInterval: Float64(self.seconds),
                                                   repeats: true) { _ in
            self.ticker -= self.seconds
            self.userData.setLastValue(value: self.ticker)
            if (self.ticker <= 0) {
                self.restart()
            }
        }
    }
    
    func formatted() -> String {
        return String(self.ticker / self.seconds).padLeft(totalWidth: 2, with: "0")
    }
    
    func setTicker(value: Int) {
        self.ticker = value * self.seconds
    }
    
    func restart() {
        self.timer.invalidate()
        if self.mode == Mode.work {
            self.userData.increaseAutodoroCounter()
            self.mode = Mode.break_
            if self.userData.getAutodoroCounter() % self.userData.getBreaksToLong() == 0 {
                self.setTicker(value: self.userData.getLongBreakTime())
            } else {
                self.setTicker(value: self.userData.getShortBreakTime())
            }
        } else {
            self.mode = Mode.work
            self.setTicker(value: self.userData.getWorkTime())
        }
        self.userData.setLastMode(value: self.mode)
        SoundManager.instance.playSound(mode:self.mode)
        self.start();
    }
    
    func pause() {
        self.isPaused = true
        self.lastTicker = self.ticker;
        self.timer.invalidate()
    }
    
    func unpause() {
        self.isPaused = false
        self.timer.invalidate()
        self.ticker = self.lastTicker
        self.lastTicker = -1
        self.start()
    }
}

struct MyTextLabelView: View {
    let labelText: String
    
    var body: some View {
        Text(labelText)
    }
}

@main
struct AutodoroApp: App {
    @State var paused: Bool = false
    @ObservedObject var stopWatch: StopWatch
    var userData: UserData
    
    var body: some Scene {
        MenuBarExtra {
            Button("\(paused ? "Continue" : "Pause")") {
                if (paused) {
                    paused = false
                    stopWatch.unpause()
                } else {
                    paused = true
                    stopWatch.pause()
                }
            }.keyboardShortcut("1")
            Button("Autodoros: \(userData.getAutodoroCounter())") {
                
            }
            Divider()
            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }.keyboardShortcut("q")
        } label: {
            Text("\(stopWatch.isPaused ? "⏸ " : stopWatch.mode == Mode.work ? "": "★ ")") + Text(String(stopWatch.formatted())).monospacedDigit()
        }
    }
    
    init() {
        userData = UserData()
        stopWatch = StopWatch(userData: userData)
        stopWatch.start()
    }
}
