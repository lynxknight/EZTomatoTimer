//
//  EZStatusMenuController.swift
//  EZTomatoTimer
//
//  Created by Edward Zhuk on 11.11.16.
//  Copyright © 2016 lynxknight. All rights reserved.
//

import Cocoa

class EZStatusMenuController: NSObject {
    @IBOutlet weak var statusMenu: NSMenu!
    @IBOutlet weak var timingItem: NSMenuItem!
    @IBOutlet weak var pauseItem: NSMenuItem!
    
    @IBAction func quitMenuItemClicked(_ sender: NSMenuItem) {
        print("quitMenuItemClicked, exiting...")
        NSApplication.shared().terminate(self)
    }


    let statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
    var timer: Timer?
    var destinationDate: Date?

    let pomodoroInterval = 25 * 60.0
    let chillInterval = 5 * 60.0
    let restInterval = 10 * 60.0
    
    let debugInterval = 5.0

    override func awakeFromNib() {
        print("EZStatusMenuController awaken from nib")
        let icon = NSImage(named: "StatusBarButtonImage")
        icon?.isTemplate = true
        self.statusItem.image = icon
        self.statusItem.menu = self.statusMenu
        self.startCountdown(timeInterval: self.debugInterval)
    }

    @IBAction func pauseItemClicked(_ sender: NSMenuItem) {
    }

    func startCountdown(timeInterval ti: TimeInterval) {
        // Set destination date
        self.destinationDate = Date(timeInterval: ti, since: Date())
        self.timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(timerTick), userInfo: nil, repeats: true)
        RunLoop.main.add(self.timer!, forMode: RunLoopMode.commonModes)
    }
    
    func timerTick() {
        let formattedTime: String
        let remainingTime = self.destinationDate!.timeIntervalSince(Date())
        if remainingTime > 0 {
            formattedTime = self.formatTimeInterval(ti: remainingTime)
        } else {
            // TODO: Notificate
            formattedTime = self.formatTimeInterval(ti: 0.0)
            self.timer!.invalidate()
            self.timer = nil
        }
        self.timingItem.title = formattedTime
        self.statusMenu.itemChanged(self.timingItem)
        print("timingItem changed... \(remainingTime)")
    }

    func formatTimeInterval(ti: TimeInterval) -> String {
        let interval = Int(ti)
        let minutes = interval / 60
        let seconds = interval % 60
        // set label text
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
