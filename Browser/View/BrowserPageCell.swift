//
//  BrowserPageCell.swift
//  Browser
//
//  Created by Ankit Shah on 6/30/21.
//

import UIKit

class BrowserPageCell: UICollectionViewCell {
	
	static let reuseIdentifier = String(describing: BrowserPageCell.self)
	
	@IBOutlet var pageImage: UIImageView!
	
	@IBOutlet var closeButton: UIButton!
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		self.contentView.layer.cornerRadius = Constants.CornderRadius
		
		self.layer.cornerRadius = Constants.CornderRadius
		self.layer.borderColor = UIColor.systemBlue.cgColor
	}
	
}
