//
//  CMBSceneDelegate.swift
//  CommandBar
//
//  Created by Steven Troughton-Smith on 29/12/2021.
//  
//

import UIKit

class CMBSceneDelegate: UIResponder, UIWindowSceneDelegate {
	var window: UIWindow?
	
	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		guard let windowScene = scene as? UIWindowScene else {
			fatalError("Expected scene of type UIWindowScene but got an unexpected type")
		}
		window = UIWindow(windowScene: windowScene)
		
		if let window = window {
			window.rootViewController = CMBMainViewController()
			
#if targetEnvironment(macCatalyst)
			
			let toolbar = NSToolbar(identifier: NSToolbar.Identifier("CMBSceneDelegate.Toolbar"))
			toolbar.delegate = self
			toolbar.displayMode = .iconOnly
			toolbar.allowsUserCustomization = false
			
			windowScene.titlebar?.toolbar = toolbar
			windowScene.titlebar?.toolbarStyle = .unified
			
#endif
			
			window.makeKeyAndVisible()
		}
	}
}
