//
//  ViewController.swift
//  iCloud Manager
//
//  Created by Ezekiel Elin on 4/5/17.
//  Copyright © 2017 Ezekiel Elin. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func dialogOKCancel(title: String, text: String) -> Bool {
        let myPopup: NSAlert = NSAlert()
        myPopup.messageText = title
        myPopup.informativeText = text
        myPopup.alertStyle = NSAlert.Style.warning
        myPopup.addButton(withTitle: "Continue")
        myPopup.addButton(withTitle: "Cancel")
        return myPopup.runModal() == NSApplication.ModalResponse.alertFirstButtonReturn
    }
    
    func getFiles(message: String) -> [URL] {
        let dialog = NSOpenPanel()
        
        dialog.title = message
        dialog.showsResizeIndicator = true
        dialog.canChooseFiles = true
        dialog.canChooseDirectories = true
        dialog.canCreateDirectories = false
        dialog.allowsMultipleSelection = true
        
        if (dialog.runModal() == NSApplication.ModalResponse.OK) {
            return dialog.urls
        } else {
            return []
        }
    }
    
    @IBAction func removeLocal(sender: Any?) {
        let results = getFiles(message: "Choose files to purge...")
        for url in results {
            print(url)
            do {
                if FileManager.default.isUbiquitousItem(at: url) {
                    try FileManager.default.evictUbiquitousItem(at: url)
                } else if !dialogOKCancel(title: "Error", text: "Item is not a cloud file \(url)") {
                    break
                }
            } catch {
                if !dialogOKCancel(title: "Error", text: "Unable to purge \(url)") {
                    break
                }
            }
        }
    }

    
    @IBAction func downloadLocal(sender: Any?) {
        let results = getFiles(message: "Choose files to download...")
        for url in results {
            do {
                try FileManager.default.startDownloadingUbiquitousItem(at: url)
            } catch {
                if !dialogOKCancel(title: "Error", text: "Unable to download \(url)") {
                    break
                }
            }
        }
    }

}

