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
    
    let statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
    
    override func awakeFromNib() {
        print("EZStatusMenuController awaken from nib")
        let icon = NSImage(named: "StatusBarButtonImage")
        icon?.isTemplate = true
        statusItem.image = icon
        statusItem.menu = self.statusMenu
    }
    
    @IBAction func quitMenuItemClicked(_ sender: NSMenuItem) {
        print("quitMenuItemClicked, exiting...")
        NSApplication.shared().terminate(self)
    }
}
