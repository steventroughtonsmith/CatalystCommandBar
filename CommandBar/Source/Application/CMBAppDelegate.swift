//
//  CMBAppDelegate.swift
//  CommandBar
//
//  Created by Steven Troughton-Smith on 29/12/2021.
//  
//

import UIKit

@UIApplicationMain
class CMBAppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }
	
	// MARK: - Menus
	
	override func buildMenu(with builder: UIMenuBuilder) {
		
		if builder.system == UIMenuSystem.context {
			return
		}
		
		super.buildMenu(with: builder)
		
		let command = UIKeyCommand(input: "o", modifierFlags: [.command, .shift], action: #selector(CMBMainViewController.showCommandBar(_:)))
		
		command.title = NSLocalizedString("Open Quickly…", comment: "")
		
		let menu = UIMenu(title: "", image: nil, identifier: UIMenu.Identifier("MENU_FILE_OPENQUICKLY"), options: .displayInline, children: [command])
		builder.insertSibling(menu, afterMenu: .newScene)
	}
}
