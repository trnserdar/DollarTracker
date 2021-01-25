//
//  PreferencesViewController.swift
//  DollarTracker
//
//  Created by SERDAR TURAN on 24.01.2021.
//

import Cocoa

class PreferencesViewController: NSViewController {

    @IBOutlet var apiKeyTextField: NSTextField!
    @IBOutlet var currencyMenu: NSPopUpButton!
    @IBOutlet var displayModeMenu: NSPopUpButton!
    
    static var storyboardId = "PreferencesViewController"
    var localeManager: LocaleManagerProtocol = LocaleManager()
    var networkManager: NetworkManagerProtocol = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        getLocale()
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        
        setLocale()
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.post(name: Notification.Name("PreferencesChanged"), object: nil)
    }
        
    func getLocale() {
        apiKeyTextField.stringValue = localeManager.getApiKey() ?? "Please enter api key"
        if displayModeMenu.menu?.items.count ?? 0 > localeManager.getDisplayMode() {
            displayModeMenu.select(displayModeMenu.menu?.items[localeManager.getDisplayMode()])
        }
        
        if let currencyTypes = localeManager.getCurrencyTypes() {
            configureCurrencyTypesMenu(dictionary: currencyTypes)
        } else {
            getCurrencyTypes()
        }
    }
    
    func getCurrencyTypes() {
        networkManager.getCurrencyTypes { (dictionary) in
            guard let dictionary = dictionary else {
                return
            }
            
            self.localeManager.setValue(value: dictionary, key: UserDefaultKeys.currencyTypes)
            self.configureCurrencyTypesMenu(dictionary: dictionary)
        }
    }
    
    func configureCurrencyTypesMenu(dictionary: [String: String]) {
        
        let selectedCurrency = localeManager.getSelectedCurrencyType()
        for (code, currency) in dictionary.sorted(by: <) {
            DispatchQueue.main.async {
                let item = NSMenuItem(title: "\(code): \(currency)", action: nil, keyEquivalent: "")
                item.state = code == selectedCurrency ? .on : .off

                self.currencyMenu.menu?.addItem(item)
                if code == selectedCurrency {
                    self.currencyMenu.select(item)
                }
            }
        }
    }
    
    func setLocale() {
        localeManager.setValue(value: apiKeyTextField.stringValue, key: .apiKey)
        localeManager.setValue(value: displayModeMenu.selectedItem?.tag ?? 0, key: .displayMode)
        
        if let selectedItem = currencyMenu.selectedItem {
            localeManager.setValue(value: String(selectedItem.title.prefix(3)), key: .selectedCurrencyType)
        }
    }
    
    @IBAction func currencyMenuSelected(_ sender: Any) {
        
        guard let popUpButton = sender as? NSPopUpButton,
              let selectedMenuItem = popUpButton.selectedItem else {
            return
        }
        
        localeManager.setValue(value: String(selectedMenuItem.title.prefix(3)), key: .selectedCurrencyType)
                
        for menuItem in currencyMenu.menu?.items ?? [] {
            menuItem.state = selectedMenuItem == menuItem ? .on : .off
        }
    }
    
    
    
}
