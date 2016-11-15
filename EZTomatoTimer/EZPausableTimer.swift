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
    var timeRemaining: TimeInterval = 0.0
    var timeToPass: TimeInterval
    
    private var latestStartDate: Date
    
    override init() {
        fatalError("Fuck you")
    }
    
    init(timeInterval: TimeInterval, completion: @escaping () -> Void) {
        self.latestStartDate = Date()
        self.completion = completion
        self.timeToPass = timeInterval
        super.init()
    }
    
    deinit {
        self.timer?.invalidate()
    }
    
    func start() {
        print("Called public start")
        self.timer = self.startTimer(timeInterval: self.timeToPass)
    }
    
    func pause() {
        self.stopTimer()
        self.paused = true
        self.timeRemaining = self.timeToPass - Date().timeIntervalSince(self.latestStartDate)
    }
    
    func resume() {
        guard self.paused else {
            print("Timer is not paused")
            return
        }
        self.paused = false
        self.latestStartDate = Date()
        self.timer = self.startTimer(timeInterval: self.timeRemaining)
    }
    
    func timerEnded() {
        print("Timer fired")
        self.timer?.invalidate()  // TODO: investigate on this
        self.timer = nil
        self.completion()
    }
    
    // Timer heplers
    private func startTimer(timeInterval: TimeInterval) -> Timer {
        guard self.timer == nil else {
          fatalError("Started timer while having existing")
        }
        let timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(timerEnded), userInfo: nil, repeats: false)
        RunLoop.main.add(timer, forMode: RunLoopMode.commonModes)
        return timer
    }
    
    private func stopTimer() {
        guard let timer = self.timer else {
            print("Timer already paused/destroyed")
            return // If there's no timer -- there's nothing to stop
        }
        timer.invalidate()
        self.timer = nil
    }
    
}
