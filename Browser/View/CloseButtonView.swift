//
//  CloseButton.swift
//  Browser
//
//  Created by Ankit Shah on 7/2/21.
//

import UIKit

class CloseButtonView: UICollectionReusableView {
	
	static let reuseIdentifier = String(describing: CloseButtonView.self)
	let closeButton = UIButton(type: .infoLight)
	var indexP: IndexPath!
	
	required init?(coder: NSCoder) {
		fatalError()
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		configure()
	}
	
	func configure() {
//		backgroundColor = .lightGray
		
		closeButton.translatesAutoresizingMaskIntoConstraints = false
		closeButton.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
		closeButton.layer.backgroundColor = UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 1).cgColor
		closeButton.tintColor = .white
		closeButton.sizeToFit()
		closeButton.layer.cornerRadius = closeButton.frame.width / 2
		closeButton.layer.shadowColor = UIColor.gray.cgColor
		closeButton.layer.shadowRadius = 2
		
		addSubview(closeButton)
		
		NSLayoutConstraint.activate( [
			closeButton.topAnchor.constraint(equalTo: topAnchor),
			closeButton.leadingAnchor.constraint(equalTo: leadingAnchor),
			closeButton.trailingAnchor.constraint(equalTo: trailingAnchor),
			closeButton.bottomAnchor.constraint(equalTo: bottomAnchor)
		] )
		
		
		
	}
	
	
}
