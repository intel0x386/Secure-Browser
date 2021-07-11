//
//  BrowserPagesData.swift
//  Browser
//
//  Created by Ankit Shah on 6/30/21.
//

import Foundation
import UIKit

enum Section: Hashable {
	case Main
}

class BrowserPage: Hashable {

	var pageVC: PageViewController!
	var image: UIImage! {
		didSet {
			print("A new image is availabel for VC \(pageVC)")
		}
	}
	
	static func == (lhs: BrowserPage, rhs: BrowserPage) -> Bool {
		lhs.pageVC === rhs.pageVC
	}
	
	func hash(into hasher: inout Hasher) {
		hasher.combine(pageVC)
	}
	
	init(pageVC: PageViewController, image: UIImage?) {
		self.pageVC = pageVC
		self.image = image
	}
	
}

class BrowserPages {
	
	var pages: [BrowserPage]!
	
	static let `default` = BrowserPages()
	
	private init() {
		pages = []
	}
	
	func deletePage(page: BrowserPage) {
		if let firstIndex = pages.firstIndex(of: page) {
			pages.remove(at: firstIndex)
		}
	}
	
}
