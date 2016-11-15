//
//  EZStatusMenuController.swift
//  EZTomatoTimer
//
//  Created by Edward Zhuk on 11.11.16.
//  Copyright © 2016 lynxknight. All rights reserved.
//

import Cocoa

class EZStatusMenuController: NSObject {
    let statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
    var timer: Timer?
    var destinationDate: Date?
    var stoppedDate: Date?
    
    // Intervals TODO: Struct?
    let pomodoroInterval = 25 * 60.0
    let chillInterval = 5 * 60.0
    let restInterval = 10 * 60.0
    let debugInterval = 5.0

    var remainingTime: TimeInterval = 0.0
    
    @IBOutlet weak var statusMenu: NSMenu!
    @IBOutlet weak var timingItem: NSMenuItem!
    @IBOutlet weak var pauseItem: NSMenuItem!
    
    @IBAction func quitMenuItemClicked(_ sender: NSMenuItem) {
        print("quitMenuItemClicked, exiting...")
        NSApplication.shared().terminate(self)
    }
    
    @IBAction func pauseItemClicked(_ sender: NSMenuItem) {
        if let _ = self.timer {
            // If there's an instance, then timer is running
            self.stopTimer()
            sender.title = "Continue"
        } else {
            // If there's no instance, them we were paused and should continue
            self.timer = self.startTimer()
            sender.title = "Pause"
        }
        self.statusMenu.itemChanged(sender)
    }
    
    @IBAction func pomodoroClicked(_ sender: NSMenuItem) {
    }
    
    @IBAction func chillClicked(_ sender: NSMenuItem) {
    }
    
    @IBAction func breakClicked(_ sender: NSMenuItem) {
    }

    override func awakeFromNib() {
        print("EZStatusMenuController awaken from nib")
        let icon = NSImage(named: "StatusBarButtonImage")
        icon?.isTemplate = true
        self.statusItem.image = icon
        self.statusItem.menu = self.statusMenu
        self.startCountdown(timeInterval: self.debugInterval)
    }


    func startCountdown(timeInterval ti: TimeInterval) {
        // Set destination date
        self.destinationDate = Date(timeInterval: ti, since: Date())
        self.timer = self.startTimer()
    }
    
    func timerTick() {
        let formattedTime: String
        self.remainingTime = self.destinationDate!.timeIntervalSince(Date())
        if self.remainingTime > 0 {
            formattedTime = self.formatTimeInterval(ti: self.remainingTime)
        } else {
            // TODO: Notificate
            // TODO: Remove ability to Pause
            formattedTime = self.formatTimeInterval(ti: 0.0)
            self.stopTimer()
        }
        self.timingItem.title = formattedTime
        self.statusMenu.itemChanged(self.timingItem)
        print("timingItem changed... \(self.remainingTime)")
    }

    // Timer heplers
    func startTimer() -> Timer {
        if let oldTimer = self.timer {
            return oldTimer // If there's a timer, return it
        }
        let timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(timerTick), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: RunLoopMode.commonModes)
        return timer
    }
    
    func stopTimer() {
        guard let timer = self.timer else {
            return // If there's no timer -- there's nothing to stop
        }
        timer.invalidate()
        self.timer = nil
    }
    
    func formatTimeInterval(ti: TimeInterval) -> String {
        let interval = Int(ti)
        return String(
            format: "%02d:%02d", // mm:ss
            interval / 60,       // minutes
            interval % 60        // seconds
        )
    }
}
