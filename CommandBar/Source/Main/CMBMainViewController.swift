//
//  CMBMainViewController.swift
//  CommandBar
//
//  Created by Steven Troughton-Smith on 29/12/2021.
//  
//

import UIKit

extension NSObject {
	@objc func CMB_shouldHideAnchor() -> Bool {
		return true
	}
}

final class CMBMainViewController: UIViewController, UIPopoverPresentationControllerDelegate {
	
	init() {
		super.init(nibName: nil, bundle: nil)
		title = "CommandBar"
		view.backgroundColor = .systemBackground
		
		/*
		 macOS needs a straightforward swizzle to hide the popover arrow.
		 
		 N.B.: if you have other popovers in your app, you might want to find a way to specify
		 that only certain NSPopover instances hide the arrow. Outside of scope for this
		 example!
		 */
		 
		do {
			let m1 = class_getInstanceMethod(NSClassFromString("NSPopover"), NSSelectorFromString("shouldHideAnchor"))
			let m2 = class_getInstanceMethod(NSClassFromString("NSPopover"), NSSelectorFromString("CMB_shouldHideAnchor"))
			
			if let m1 = m1, let m2 = m2 {
				method_exchangeImplementations(m1, m2)
			}
		}
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: -
	
	func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
		return .none
	}
	
#if !targetEnvironment(macCatalyst)
	override var keyCommands:[UIKeyCommand] {
		return [UIKeyCommand(input: "o", modifierFlags: [.command, .shift], action: #selector(showCommandBar(_:)))]
	}
#endif
	
	@objc func showCommandBar(_ sender:Any?) {
		let cmb = CMBCommandBarViewController()
		cmb.modalPresentationStyle = .popover
		cmb.preferredContentSize = CGSize(width: UIFloat(400), height: UIFloat(80))
		
		if let pc = cmb.popoverPresentationController {
			pc.delegate = self
			pc.sourceView = view
			let safeRect = view.bounds.inset(by:view.safeAreaInsets)
			
#if targetEnvironment(macCatalyst)
			pc.permittedArrowDirections = [.up]
#else
			pc.permittedArrowDirections = [.init(rawValue:0)] // iOS lets you hide the popover arrow like so
#endif
			pc.sourceRect = CGRect(x: safeRect.midX, y: safeRect.midY / 2, width: 1, height: 1)
		}
		present(cmb, animated: true, completion: {
			cmb.searchField.becomeFirstResponder()
		})
	}
}
