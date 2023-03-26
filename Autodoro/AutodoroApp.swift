//
//  AutodoroApp.swift
//  Autodoro
//
//  Created by Josue Ttito on 25/03/23.
//

import SwiftUI
import AVFoundation

import AVKit


enum Mode: Int {
    case focus
    case brake_time
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
    @Published var counter: Int = 25
    var lastCounter: Int = -1
    @Published var mode: Mode = .focus  // 0 Is for focus time, 1 is for spare time
    var timer = Timer()
    @State var audioPlayer: AVAudioPlayer!

    func start() {
        SoundManager.instance.playSound(mode:self.mode)
        self.timer = Timer.scheduledTimer(withTimeInterval: 60.0,
                                                   repeats: true) { _ in
            self.counter -= 1
            if (self.counter == 0) {
                self.mode = self.mode == Mode.focus ? Mode.brake_time : Mode.focus
                self.restart()
            }
        }
    }
    
    func formatted() -> String {
        return String(self.counter).padLeft(totalWidth: 2, with: "0")
    }
    
    func restart() {
        self.timer.invalidate()
        if (self.lastCounter >= 0) {
            self.counter = self.lastCounter
        } else {
            self.lastCounter = -1
            self.counter = self.mode == Mode.focus ? 25 : 5
        }
        SoundManager.instance.playSound(mode:self.mode)
        self.start();
    }
    
    func pause() {
        self.lastCounter = self.counter;
        self.timer.invalidate()
    }
    
    func unpause() {
        self.restart()
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
    let customIcon = NSImage(named: "phone-call")
    @State var paused: Bool = false
    @ObservedObject var stopWatch = StopWatch()
    
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
            Divider()
            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }.keyboardShortcut("q")
        } label: {
            Text("\(stopWatch.mode == Mode.focus ? "": "♥ ")") + Text(String(stopWatch.formatted()))
        }
    }
    
    init() {
        stopWatch.start()
    }
}
