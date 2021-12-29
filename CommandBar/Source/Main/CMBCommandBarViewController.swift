//
//  CMBCommandBarViewController.swift
//  CommandBar
//
//  Created by Steven Troughton-Smith on 29/12/2021.
//

import UIKit
import CoreGraphics
import Foundation

extension NSNotification.Name {
	static let upArrowPressedNotification = NSNotification.Name("CMBSearchTextFieldUp")
	static let downArrowPressedNotification = NSNotification.Name("CMBSearchTextFieldDown")
	static let returnPressedNotification = NSNotification.Name("CMBSearchTextFieldReturn")
}

class CMBCommandBarViewController: UIViewController, UITextFieldDelegate {
	
	let searchField = UISearchTextField()
	let resultsViewController = CMBCommandBarResultsViewController()
	
	init() {
		super.init(nibName:nil, bundle:nil)
		
		searchField.font = UIFont.systemFont(ofSize: UIFloat(26))
		searchField.focusEffect = nil
		searchField.delegate = self
		searchField.placeholder = NSLocalizedString("Open Quickly", comment: "")
		searchField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
		searchField.borderStyle = .none
		
		view.addSubview(searchField)
		
		addChild(resultsViewController)
		view.addSubview(resultsViewController.view)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: -
	
	override func viewDidLayoutSubviews() {
		
		let searchHeight = UIFloat(80)
		
		let safeFrame = view.bounds.inset(by:view.safeAreaInsets)
		
		let searchRect = CGRect(x: safeFrame.minX, y: safeFrame.minY, width: safeFrame.width, height: searchHeight)
		searchField.frame = searchRect
		
		resultsViewController.view.frame = CGRect(x: safeFrame.minX, y: safeFrame.minY + searchHeight, width: safeFrame.width, height: (preferredExpandedContentSize.height-safeFrame.minY)-searchHeight)
	}
	
	// MARK: - Keyboard Navigation
	
	override var keyCommands:[UIKeyCommand] {
		get {
			let upItem = UIKeyCommand(input: UIKeyCommand.inputUpArrow, modifierFlags: [], action: #selector(goUp(_:)))
			let downItem = UIKeyCommand(input: UIKeyCommand.inputDownArrow, modifierFlags: [], action: #selector(goDown(_:)))
			let escapeItem = UIKeyCommand(input: UIKeyCommand.inputEscape, modifierFlags: [], action: #selector(dismiss(_:)))
			let returnItem = UIKeyCommand(input: "\r", modifierFlags: [], action: #selector(actuateSelection(_:)))
			
			upItem.wantsPriorityOverSystemBehavior = true
			downItem.wantsPriorityOverSystemBehavior = true
			returnItem.wantsPriorityOverSystemBehavior = true

			return [upItem, downItem, escapeItem, returnItem]
		}
	}
	
	@objc func actuateSelection(_ sender:Any?) {
		NotificationCenter.default.post(name: .returnPressedNotification, object: nil)
	}
	
	@objc func goUp(_ sender:Any?) {
		NotificationCenter.default.post(name: .upArrowPressedNotification, object: nil)
	}

	@objc func goDown(_ sender:Any?) {
		NotificationCenter.default.post(name: .downArrowPressedNotification, object: nil)
	}
	
	@objc func textFieldDidChange(_ textField:UITextField) {
		if textField.text == "" {
			contract()
		}
		else {
			expand()
		}
	}
	
	@objc func dismiss(_ sender:Any?) {
		searchField.resignFirstResponder()
		presentingViewController?.dismiss(animated:true)
	}
	
	// MARK: -
	
	var preferredExpandedContentSize = CGSize(width: UIFloat(400), height: UIFloat(400))
	var preferredContractedContentSize = CGSize(width: UIFloat(400), height: UIFloat(80))
	
	// MARK: -

	
	func contract() {

		preferredContentSize = preferredContractedContentSize
	}
	
	func expand() {
	
		preferredContentSize = preferredExpandedContentSize
	}
	
	
}
