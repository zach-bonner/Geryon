//
//  SettingsWindow.swift
//  Geryon
//
//  Created by Zachary Bonner on 3/2/25.
//

import SwiftUI
import AppKit

class SettingsWindow {
    static let shared = SettingsWindow()
    private var window: NSWindow?

    func show() {
        if window == nil {
            let settingsView = SettingsView()
            let hostingController = NSHostingController(rootView: settingsView)

            window = NSWindow(contentViewController: hostingController)
            window?.setContentSize(NSSize(width: 400, height: 250))
            window?.styleMask = [.titled, .closable, .resizable]
            window?.title = "Swift Code Merger Settings"
            window?.isReleasedWhenClosed = false // Prevents deallocation on close
        }
        
        // Bring window to front
        if let window = window {
            window.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true) // Ensures it pops up
        }
    }
}
