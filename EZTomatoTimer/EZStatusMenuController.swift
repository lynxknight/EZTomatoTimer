//
//  EZStatusMenuController.swift
//  EZTomatoTimer
//
//  Created by Edward Zhuk on 11.11.16.
//  Copyright © 2016 lynxknight. All rights reserved.
//

import Cocoa

var activity: NSObjectProtocol?

struct Interval {
    static let pomodoro = 25 * 60.0
    static let chill = 5 * 60.0
    static let rest = 10 * 60.0
    static let debug = 5.0 * 100
    static let no = 0.0
}

class EZStatusMenuController: NSObject {
    let statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
    var pausableTimer: EZPausableTimer?
    var statusUpdateTimer: Timer?
    

    @IBOutlet weak var statusMenu: NSMenu!
    @IBOutlet weak var timingItem: NSMenuItem!
    @IBOutlet weak var pauseItem: NSMenuItem!
    
    @IBAction func quitMenuItemClicked(_ sender: NSMenuItem) {
        print("quitMenuItemClicked, exiting...")
        NSApplication.shared().terminate(self)
    }
    
    @IBAction func pauseItemClicked(_ sender: NSMenuItem) {
        guard let pausableTimer = self.pausableTimer else {
            print("For some reason there's no timer and user was able to call pauseItemClicked")
            fatalError()
        }
        // TODO: Add toggle to pausableTimer
        if pausableTimer.paused {
            pausableTimer.resume()
        } else {
            pausableTimer.pause()
        }
        self.updatePauseItemAccordingToTimer()
    }
    
    @IBAction func pomodoroClicked(_ sender: NSMenuItem) {
        self.pausableTimer = EZPausableTimer(
            timeInterval: Interval.pomodoro,
            completion: {
            () -> Void in self.showNotification(message: "pomodoro")
        })
        // TODO: remove updatePauseItemAccordingToTimer copypaste
        self.updatePauseItemAccordingToTimer()
    }
    
    @IBAction func chillClicked(_ sender: NSMenuItem) {
        self.pausableTimer = EZPausableTimer(
            timeInterval: Interval.chill,
            completion: {
                () -> Void in self.showNotification(message: "chill")
        })
        self.updatePauseItemAccordingToTimer()
    }
    
    @IBAction func breakClicked(_ sender: NSMenuItem) {
        self.pausableTimer = EZPausableTimer(
            timeInterval: Interval.rest,
            completion: {
                () -> Void in self.showNotification(message: "rest")
        })
        self.updatePauseItemAccordingToTimer()
    }

    override func awakeFromNib() {
        print("EZStatusMenuController awaken from nib")
        // Setup process info
        activity = ProcessInfo().beginActivity(
            options: ProcessInfo.ActivityOptions.userInitiated, reason: "I want my timer to work properly")
        // Setup icon
        let icon = NSImage(named: "StatusBarButtonImage")
        icon?.isTemplate = true
        self.statusItem.image = icon
        // Set menu to our class
        self.statusItem.menu = self.statusMenu
        // Init refresher loop
        self.statusUpdateTimer = Timer.scheduledTimer(
            timeInterval: 0.2,
            target: self,
            selector: #selector(statusUpdateTick),
            userInfo: nil,
            repeats: true
        )
        RunLoop.main.add(self.statusUpdateTimer!, forMode: RunLoopMode.commonModes)
    }
    
    func statusUpdateTick() {
        let timeRemaining: TimeInterval
        
        if self.pausableTimer?.isValid == true {
            timeRemaining = self.pausableTimer!.poll()
        } else {
            timeRemaining = Interval.no
        }
        self.timingItem.title = self.formatTimeInterval(ti: timeRemaining)
        self.statusMenu.itemChanged(self.timingItem)
    }
    
    func formatTimeInterval(ti: TimeInterval) -> String {
        let interval = Int(ti)
        return String(
            format: "%02d:%02d", // mm:ss
            interval / 60,       // minutes
            interval % 60        // seconds
        )
    }
    
    func updatePauseItemAccordingToTimer() {
        if self.pausableTimer?.paused == true {
            self.pauseItem.title = "Pause"
        } else {
            self.pauseItem.title = "Continue"
        }
        self.statusMenu.itemChanged(self.pauseItem)
    }
    
    func showNotification(message: String) {
        let notification = NSUserNotification()
        notification.title = "\(message) ended"
        notification.informativeText = "Useful information here later!"
        notification.soundName = NSUserNotificationDefaultSoundName
        NSUserNotificationCenter.default.scheduleNotification(notification)
    }
}
