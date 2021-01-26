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
    let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
    var timer: Timer?
    
    var localeManager: LocaleManagerProtocol = LocaleManager()
    var networkManager: NetworkManagerProtocol = NetworkManager()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {

        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(configurePreferences), name: Notification.Name("PreferencesChanged"), object: nil)
        
        configurePreferences()
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
        
        guard let preferencesViewController = storyboard.instantiateController(withIdentifier: PreferencesViewController.storyboardId) as? PreferencesViewController,
              statusItem?.button != nil else {
            return
        }
        
        let popoverView = NSPopover()
        popoverView.contentViewController = preferencesViewController
        popoverView.behavior = .transient
        popoverView.show(relativeTo: statusItem!.button!.bounds, of: statusItem!.button!, preferredEdge: .maxY)
    }
    
    @objc func configurePreferences() {
    
        timer = Timer.scheduledTimer(timeInterval: 60 * 30, target: self, selector: #selector(getLatest), userInfo: nil, repeats: true)
        timer?.tolerance = 60
        
        getLatest()
    }
    
    @objc func getLatest() {
        
        guard let apiKey = localeManager.getApiKey() else {
            statusItem?.button?.title = "Please enter api key"
            return
        }
        
        let selectedCurrency = localeManager.getSelectedCurrencyType()
        let displayMode = localeManager.getDisplayMode()
        var title = ""
        
        networkManager.getLatest(apiKey: apiKey, selectedCurrency: selectedCurrency) { (response) in
            defer {
                DispatchQueue.main.async {
                    self.statusItem?.button?.title = title
                }
            }
            
            guard let response = response else {
                title = "Please enter valid api key"
                return
            }

            if let rates = response[selectedCurrency] as? Double {
                title = displayMode == 0 ? "1 USD = \(String(format: "%.2f", rates)) \(selectedCurrency)" : "1 \(selectedCurrency) = \(String(format: "%.2f", 1 / rates)) USD"
            }
            
            if let lastUpdate = response["timestamp"] as? Int {
                let date = Date(timeIntervalSince1970: Double(lastUpdate))
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH:mm"
                title += " \(dateFormatter.string(from: date))"
            }
        }
    }
    

}

