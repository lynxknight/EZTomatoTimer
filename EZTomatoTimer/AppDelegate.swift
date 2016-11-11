//
//  AppDelegate.swift
//  EZTomatoTimer
//
//  Created by Edward Zhuk on 11.11.16.
//  Copyright © 2016 lynxknight. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var statusMenu: NSMenu!

    let statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        print("Application did finish launching")
        statusItem.title = "TomatoTimer"
        statusItem.menu = self.statusMenu
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    @IBAction func quitMenuItemClicked(_ sender: NSMenuItem) {
        print("quitMenuItemClicked, exiting...")
        NSApplication.shared().terminate(self)
    }

}

