//
//  BrowserCollectionViewController.swift
//  Browser
//
//  Created by Ankit Shah on 7/8/21.
//

import UIKit


class BrowserCollectionViewController: UICollectionViewController {
	
	var browserPages = BrowserPages.default
	
	let popAnimator = PopAnimation()
	
	var closeAll: UIBarButtonItem! = nil
	var doneButton: UIBarButtonItem! = nil
	
	private var browserDataSource: UICollectionViewDiffableDataSource<Section, BrowserPage>!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		let viewController = storyboard?.instantiateViewController(identifier: "PageViewControllerSID") as! PageViewController
		let browserPageMain = BrowserPage(pageVC: viewController, image: UIImage(named: "defaultPage"))
		browserPages.pages.append(browserPageMain)
//		viewController = storyboard?.instantiateViewController(identifier: "PageViewControllerSID") as! PageViewController
//		browserPageMain = BrowserPage(pageVC: viewController, image: UIImage(named: "defaultPage"))
//		browserPages.pages.append(browserPageMain)
//		viewController = storyboard?.instantiateViewController(identifier: "PageViewControllerSID") as! PageViewController
//		browserPageMain = BrowserPage(pageVC: viewController, image: UIImage(named: "defaultPage"))
//		browserPages.pages.append(browserPageMain)
//		viewController = storyboard?.instantiateViewController(identifier: "PageViewControllerSID") as! PageViewController
//		browserPageMain = BrowserPage(pageVC: viewController, image: UIImage(named: "defaultPage"))
//		browserPages.pages.append(browserPageMain)
//		viewController = storyboard?.instantiateViewController(identifier: "PageViewControllerSID") as! PageViewController
//		browserPageMain = BrowserPage(pageVC: viewController, image: UIImage(named: "defaultPage"))
//		browserPages.pages.append(browserPageMain)
//		viewController = storyboard?.instantiateViewController(identifier: "PageViewControllerSID") as! PageViewController
//		browserPageMain = BrowserPage(pageVC: viewController, image: UIImage(named: "defaultPage"))
//		browserPages.pages.append(browserPageMain)
		
		
		// Configure the NavigationController's ToolBar
		navigationController?.isToolbarHidden = false
		let spacer = UIBarButtonItem(systemItem: .flexibleSpace)
		
		
		closeAll = UIBarButtonItem(title: "Close All", style: .plain, target: self, action: #selector(closeAllOrDonePressed))
		closeAll.tag = Constants.CloseAllTag
		closeAll.tintColor = .white
		closeAll.setTitleTextAttributes([ .font : UIFont.preferredFont(forTextStyle: .headline) ], for: .normal)
		
		
		let largeConfig = UIImage.SymbolConfiguration(pointSize: 88, weight: .black, scale: .large)
		let add = UIBarButtonItem(image: UIImage(systemName: "plus.square", withConfiguration: largeConfig), style: .plain, target: self, action: #selector(addNewTab))
		add.tintColor = .white
		
		
		doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(closeAllOrDonePressed))
		doneButton.tag = Constants.DoneTag
		doneButton.tintColor = .white
		doneButton.setTitleTextAttributes([ .font : UIFont.preferredFont(forTextStyle: .headline) ], for: .normal)
		
		toolbarItems = [closeAll, spacer, add, spacer, doneButton]
		
		
		// Setting up the Color Scheme for CollectionView
		navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)]
		navigationController?.navigationBar.barTintColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
		navigationController?.toolbar.barTintColor = .darkGray
		
		
		// Configure CV
		
		collectionView.delegate = self
		configureCollectionView()
		clearsSelectionOnViewWillAppear = false
		
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		createAndUpdateCollectionViewSnapshot()
		
		collectionView.collectionViewLayout = getCompositionalLayout()
//		collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: .top)
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
//		collectionView.delegate?.collectionView?(collectionView, didSelectItemAt: IndexPath(item: 0, section: 0))
	}
	
	// MARK:- Collection View Layout, Cell, and Data Source.
	func getCompositionalLayout() -> UICollectionViewCompositionalLayout {
		
		let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1))
		let item = NSCollectionLayoutItem(layoutSize: itemSize)
		item.contentInsets = .init(top: 16, leading: 16, bottom: 16, trailing: 16)
		
		let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.5))
		let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
		group.contentInsets = .init(top: 16, leading: 16, bottom: 16, trailing: 16)
		
		let section = NSCollectionLayoutSection(group: group)
		
		return UICollectionViewCompositionalLayout(section: section)
	}
	
	
	func configureCollectionView() {
		browserDataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionV, indexP, page in
			guard let cell = collectionV.dequeueReusableCell(withReuseIdentifier: BrowserPageCell.reuseIdentifier, for: indexP) as? BrowserPageCell else {
				fatalError("Could not create Cell for CollectionView")
			}
			
			cell.pageImage.image = page.image
			cell.closeButton.imageView?.alpha = 1
			cell.closeButton.alpha = 1
			
			
			cell.closeButton.addTarget(self, action: #selector(self.closeButtonPressed), for: .touchUpInside)
			
			return cell
		})
		
	}
	
	
	func createAndUpdateCollectionViewSnapshot() {
		var snapshot = NSDiffableDataSourceSnapshot<Section, BrowserPage>()
		snapshot.appendSections([.Main])
		snapshot.appendItems(browserPages.pages)
		browserDataSource.apply(snapshot)
		
		if snapshot.numberOfItems == 0 {
			closeAll.isEnabled = false
			doneButton.isEnabled = false
		} else {
			closeAll.isEnabled = true
		}
	}
	
	// MARK:- Buttons: New Tab
	@objc func addNewTab(_ sender: UIBarButtonItem) {
		let pageVC = storyboard?.instantiateViewController(identifier: "PageViewControllerSID") as! PageViewController
		let page = BrowserPage(pageVC: pageVC, image: UIImage(named: "defaultPage"))
		browserPages.pages.append(page)
		
		createAndUpdateCollectionViewSnapshot()
		
		let lastCellIndex = IndexPath(item: browserPages.pages.count - 1, section: 0)
		
		collectionView.selectItem(at: lastCellIndex, animated: false, scrollPosition: .centeredVertically)
		collectionView.delegate?.collectionView?(collectionView, didSelectItemAt: lastCellIndex)
	}
	
	
	@objc func closeButtonPressed(_ sender: UIButton) {
		guard let cell = sender.superview?.superview as? BrowserPageCell,
					let indexP = collectionView.indexPath(for: cell),
					let page = browserDataSource.itemIdentifier(for: indexP)
		else {
			return
		}
		
		browserPages.deletePage(page: page)
		
		createAndUpdateCollectionViewSnapshot()
	}
	
	@objc func closeAllOrDonePressed(_ sender: UIBarButtonItem) {
		switch sender.tag {
		
		case Constants.CloseAllTag:
			browserPages.pages.removeAll()
			createAndUpdateCollectionViewSnapshot()
			
		case Constants.DoneTag:
			break
			
		default:
			break
		}
	}
}


// MARK:- Transition Extension
extension BrowserCollectionViewController: UIViewControllerTransitioningDelegate {
	
	func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		
		collectionView.reloadData()
		
		popAnimator.isPresenting = false
		
		return popAnimator
	}
	
	func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		
		guard let selectedIndex = collectionView.indexPathsForSelectedItems?.first,
					let selectedCell = collectionView.cellForItem(at: selectedIndex) as? BrowserPageCell else { return nil }
		
		popAnimator.cellFrame = collectionView.convert(selectedCell.frame, to: view)
		popAnimator.isPresenting = true
		return popAnimator
	}
}


// MARK:- UICollectionViewController Delegates implementation
extension BrowserCollectionViewController {
	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
		let page = browserDataSource.itemIdentifier(for: indexPath)!
		page.pageVC.transitioningDelegate = self
		page.pageVC.modalPresentationStyle = .overFullScreen
		page.pageVC.pageObject = page
		self.present(page.pageVC, animated: true, completion: nil)
	}
	
}
