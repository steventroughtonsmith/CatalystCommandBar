//
//  CMBCommandBarResultsCell.swift
//  CommandBar
//
//  Created by Steven Troughton-Smith on 29/12/2021.
//

import UIKit

class CMBCommandBarResultsCell: UICollectionViewCell {
	
	let imageView = UIImageView()
	let textLabel = UILabel()
	let subtitleLabel = UILabel()
	
	override var isSelected: Bool {
		didSet {
			recolor()
		}
	}
	
	// MARK: -
	
	override init(frame:CGRect) {
		super.init(frame: .zero)
		
		textLabel.font = UIFont.systemFont(ofSize: UIFloat(16))
		subtitleLabel.font = UIFont.systemFont(ofSize: UIFloat(14))

		contentView.addSubview(textLabel)
		contentView.addSubview(subtitleLabel)

		imageView.contentMode = .scaleAspectFit
		contentView.addSubview(imageView)
		
		let selection = UIView()
		selection.backgroundColor = .systemBlue
		selection.layer.cornerRadius = UIFloat(8)
		selection.layer.cornerCurve = .continuous
		
		selectedBackgroundView = selection
		
		if let selectedBackgroundView = selectedBackgroundView {
			selectedBackgroundView.alpha = 0
			insertSubview(selectedBackgroundView, at: 0)
			
			selectedBackgroundView.layer.cornerRadius = UIFloat(8)
			selectedBackgroundView.layer.cornerCurve = .continuous
			selectedBackgroundView.layer.masksToBounds = true
		}
		
		contentView.layer.cornerRadius = UIFloat(8)
		contentView.layer.cornerCurve = .continuous
		contentView.layer.masksToBounds = true
		
		if #available(macCatalyst 15.0, iOS 15.0, *) {
			focusEffect = nil
		}
		
		recolor()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: -
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		let imageWidth = UIFloat(70)
		
		let xMargins = UIFloat(13)
		let yMargins = UIFloat(0)
		let padding = UIFloat(8)
		let textPadding = UIFloat(8)

		let safeContentArea = bounds.insetBy(dx: xMargins, dy: yMargins)
		
		contentView.frame = safeContentArea
		selectedBackgroundView?.frame = safeContentArea
		
		let division = contentView.bounds.divided(atDistance: imageWidth, from: .minXEdge)
		
		var imageViewRect = division.slice.insetBy(dx: padding, dy: 0)
		imageViewRect.size.height = imageViewRect.size.width*3/4
		imageViewRect.origin.y = (safeContentArea.height-imageViewRect.size.height)/2
		
		imageView.frame = imageViewRect
		
		let textRect = division.remainder.insetBy(dx: 0, dy: textPadding)
		let labelsDivider = textRect.divided(atDistance: textRect.height/2, from: .minYEdge)
		
		textLabel.frame = labelsDivider.slice
		
		let subtitleFrame = labelsDivider.remainder
		
		subtitleLabel.frame = subtitleFrame
	}
	
	// MARK: -
	
	func recolor() {
		if isSelected == true {
			
			textLabel.textColor = .white
			subtitleLabel.textColor = .white
			imageView.tintColor = .white
			
			if let selectedBackgroundView = selectedBackgroundView {
				selectedBackgroundView.alpha = 1
				selectedBackgroundView.backgroundColor = .systemBlue
			}
		}
		else {
			textLabel.textColor = .label
			subtitleLabel.textColor = .secondaryLabel
			imageView.tintColor = .systemBlue
			
			if let selectedBackgroundView = selectedBackgroundView {
				selectedBackgroundView.alpha = 0
				selectedBackgroundView.backgroundColor = .systemBlue
			}
		}
	}
	
	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		super.traitCollectionDidChange(previousTraitCollection)
		
		recolor()
	}
	
	// MARK: -
	
	override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
		
		super.didUpdateFocus(in: context, with: coordinator)
		
		if context.nextFocusedItem === self {
			isHighlighted = true
		} else if context.previouslyFocusedItem === self {
			isHighlighted = false
		}
	}
	
}
