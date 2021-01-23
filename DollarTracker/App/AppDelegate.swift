//
//  AppDelegate.swift
//  DollarTracker
//
//  Created by SERDAR TURAN on 23.01.2021.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var menu: NSMenu!
    @IBOutlet weak var aboutItem: NSMenuItem!
    @IBOutlet weak var preferencesItem: NSMenuItem!
    
    var statusItem: NSStatusItem?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application

    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem?.button?.title = "Dollar Tracker"
        
        if let menu = menu {
            statusItem?.menu = menu
        }
    }
    
    @IBAction func showAbout(_ sender: NSMenuItem) {
        
    }
    
    @IBAction func showPreferences(_ sender: NSMenuItem) {
        
    }
    

}

