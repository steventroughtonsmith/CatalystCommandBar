//
//  CMBSceneDelegate+NSToolbar.swift
//  CommandBar
//
//  Created by Steven Troughton-Smith on 29/12/2021.
//  
//

import UIKit

#if targetEnvironment(macCatalyst)
import AppKit

extension CMBSceneDelegate: NSToolbarDelegate {
    
	func toolbarItems() -> [NSToolbarItem.Identifier] {
		return [.toggleSidebar]
	}
	
	func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
		return toolbarItems()
	}
	
	func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
		return toolbarItems()
	}
	
	func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
		return NSToolbarItem(itemIdentifier: itemIdentifier)
	}
}
#endif
