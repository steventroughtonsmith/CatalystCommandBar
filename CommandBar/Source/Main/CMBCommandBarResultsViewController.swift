//
//  CMBCommandBarResultsViewController.swift
//  CommandBar
//
//  Created by Steven Troughton-Smith on 29/12/2021.
//

import UIKit
import Foundation

class CMBCommandBarResultsViewController: UICollectionViewController {
	
	enum CMBCommandBarSection {
		case main
	}
	
	struct CMBCommandBarItem: Hashable {
		var title: String = ""
		
		func hash(into hasher: inout Hasher) {
			hasher.combine(identifier)
		}
		static func == (lhs: CMBCommandBarItem, rhs: CMBCommandBarItem) -> Bool {
			return lhs.identifier == rhs.identifier
		}
		private let identifier = UUID()
	}
	
	var dataSource: UICollectionViewDiffableDataSource<CMBCommandBarSection, CMBCommandBarItem>! = nil
	
	init() {
		
		let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
											  heightDimension: .absolute(UIFloat(60)))
		let item = NSCollectionLayoutItem(layoutSize: itemSize)
		
		let group = NSCollectionLayoutGroup.vertical(layoutSize: itemSize,
													 subitems: [item])
		
		let section = NSCollectionLayoutSection(group: group)
		let layout = UICollectionViewCompositionalLayout(section: section)
		
		super.init(collectionViewLayout: layout)
		
		collectionView.backgroundColor = .clear
		collectionView.isOpaque = false
		collectionView.selectionFollowsFocus = true
		
		configureDataSource()
		
		NotificationCenter.default.addObserver(forName: .upArrowPressedNotification, object: nil, queue: nil) { _ in
			self.goUp(nil)
		}
		
		NotificationCenter.default.addObserver(forName: .downArrowPressedNotification, object: nil, queue: nil) { _ in
			self.goDown(nil)
		}
		
		NotificationCenter.default.addObserver(forName: .returnPressedNotification, object: nil, queue: nil) { _ in
			self.actuateSelection(nil)
		}
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: Data Source -
	
	func configureDataSource() {
		
		let cellRegistration = UICollectionView.CellRegistration<CMBCommandBarResultsCell, CMBCommandBarItem> { cell, indexPath, menuItem in
			
			cell.imageView.image = UIImage(named:"swiftdoc")
			cell.textLabel.text = menuItem.title
			cell.subtitleLabel.text = "/path/to/thing"
		}
		
		dataSource = UICollectionViewDiffableDataSource<CMBCommandBarSection, CMBCommandBarItem>(collectionView: collectionView) {
			(collectionView: UICollectionView, indexPath: IndexPath, item: CMBCommandBarItem) -> UICollectionViewCell? in
			
			return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
		}
		
		collectionView.dataSource = dataSource
		
		refresh()
	}
	
	private lazy var menuItems: [CMBCommandBarItem] = {
		return [
			CMBCommandBarItem(title: "MyApp.swift"),
			CMBCommandBarItem(title: "MyScene.swift"),
			CMBCommandBarItem(title: "MyView.swift"),
		]
	}()
	
	func initialSnapshot(forItems:[CMBCommandBarItem]) -> NSDiffableDataSourceSectionSnapshot<CMBCommandBarItem> {
		var snapshot = NSDiffableDataSourceSectionSnapshot<CMBCommandBarItem>()
		
		snapshot.append(forItems, to: nil)
		snapshot.expand(forItems)
		
		return snapshot
	}
	
	func refresh() {
		guard let dataSource = collectionView.dataSource as? UICollectionViewDiffableDataSource<CMBCommandBarSection, CMBCommandBarItem> else { return }
		
		dataSource.apply(initialSnapshot(forItems: menuItems), to: .main, animatingDifferences: false)
		collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: [])
	}
	
	// MARK: - Input  Navigation
	
	@objc func actuateSelection(_ sender:Any?) {
		guard let item = collectionView.indexPathsForSelectedItems?.first else { return }
		
		NSLog("Actuated item \(item)")
	}
	
	@objc func goUp(_ sender:Any?) {
		var current = IndexPath(item:0, section:0)
		
		if let item = collectionView.indexPathsForSelectedItems?.first {
			current = item
		}
		
		if current.item - 1 >= 0 {
			collectionView.selectItem(at: IndexPath(item: current.item - 1, section: 0), animated: false, scrollPosition: [])
		}
	}
	
	@objc func goDown(_ sender:Any?) {
		let max = collectionView.numberOfItems(inSection: 0)
		var current = IndexPath(item:0, section:0)
		
		if let item = collectionView.indexPathsForSelectedItems?.first {
			current = item
		}
		
		if current.item + 1 < max {
			collectionView.selectItem(at: IndexPath(item: current.item + 1, section: 0), animated: false, scrollPosition: [])
		}
	}
	
	// MARK: -
	
	deinit {
		NotificationCenter.default.removeObserver(self, name: .upArrowPressedNotification, object:nil)
		NotificationCenter.default.removeObserver(self, name: .downArrowPressedNotification, object:nil)
		NotificationCenter.default.removeObserver(self, name: .returnPressedNotification, object:nil)
	}
}
