//
//  AboutViewController.swift
//  DollarTracker
//
//  Created by SERDAR TURAN on 26.01.2021.
//

import Cocoa

class AboutViewController: NSViewController {

    static let storyboardId = "AboutViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func poweredByButtonTapped(_ sender: Any) {
        NSWorkspace.shared.open(URL(string: "https://openexchangerates.org/signup/free")!)
    }
    
    
}
