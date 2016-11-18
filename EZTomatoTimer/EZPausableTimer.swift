//
//  EZStopwatch.swift
//  EZTomatoTimer
//
//  Created by Edward Zhuk on 15.11.16.
//  Copyright © 2016 lynxknight. All rights reserved.
//

import Foundation

class EZPausableTimer: NSObject {
    var timer: Timer?
    var completion: (() -> Void)
    var paused = false
    var timeRemaining: TimeInterval
    var isValid = true
    
    private var latestStartDate: Date
    
    override init() {
        fatalError("Fuck you")
    }
    
    init(timeInterval: TimeInterval, completion: @escaping () -> Void) {
        self.latestStartDate = Date()
        self.completion = completion
        self.timeRemaining = timeInterval
        super.init()
        self.timer = self.startTimer(timeInterval: self.timeRemaining)
    }
    
    deinit {
        self.timer?.invalidate()
    }
    
    func pause() {
        print("EZPausableTimer] pause() called")
        guard let _ = self.timer else { print("NO TIMER ON PAUSE"); return }
        self.stopTimer()
        print("EZPausableTimer] pause() called stopTimer()")
        self.paused = true
        print("EZPausableTimer] pause() self.paused set to True")
        self.timeRemaining -= Date().timeIntervalSince(self.latestStartDate)
        print("EZPausableTimer] pause() self.timeRemaining calculated, result = \(self.timeRemaining)")
    }
    
    func resume() {
        print("EZPausableTimer] resume() called")
        guard self.timer == nil else { print("EZPausableTimer] resume() has no timer, returning"); return }  // If there's a timer, then we're not paused. TODO
        guard self.paused else {
            print("Timer is not paused")
            return
        }
        self.paused = false
        print("EZPausableTimer] resume() self.pause set to False")
        self.latestStartDate = Date()
        print("EZPausableTimer] resume() self.latestStartDate refreshed")
        print("EZPausableTimer] resume() running new timer, with time remaining: \(self.timeRemaining)")
        self.timer = self.startTimer(timeInterval: self.timeRemaining)
    }
    
    func poll() -> TimeInterval {
        if self.paused {
            return self.timeRemaining
        }
        return self.timeRemaining - Date().timeIntervalSince(self.latestStartDate)
    }
    
    func timerEnded() {
        print("Timer fired")
        self.timer?.invalidate()  // TODO: investigate on this
        self.timer = nil
        self.isValid = false
        self.completion()
    }
    
    // Timer heplers
    private func startTimer(timeInterval: TimeInterval) -> Timer {
        print("EZPausableTimer] startTimer() call")
        guard self.timer == nil else {
          fatalError("Started timer while having existing")
        }
        let timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(timerEnded), userInfo: nil, repeats: false)
        print("EZPausableTimer] startTimer() timer created")
        RunLoop.main.add(timer, forMode: RunLoopMode.commonModes)
        print("EZPausableTimer] startTimer() timer scheduled to loop")
        print("EZPausableTimer] startTimer() timer returned")
        return timer
    }
    
    private func stopTimer() {
        print("EZPausableTimer] stopTimer() call")
        guard let timer = self.timer else {
            print("Timer already paused/destroyed")
            return // If there's no timer -- there's nothing to stop
        }
        timer.invalidate()
        self.timer = nil
        print("EZPausableTimer] stopTimer() self.timer invalidated and set to nil")
    }
    
}
