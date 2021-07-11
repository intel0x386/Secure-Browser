//
//  ViewController.swift
//  Browser
//
//  Created by Ankit Shah on 6/29/21.
//

import UIKit
import WebKit

class PageViewController: UIViewController{
	
	var googleURL = "https://www.google.com/search?q="
	
	@IBOutlet internal var addressBar: UITextField!
	@IBOutlet internal var cancelButton: UIButton!
	@IBOutlet private var stackView: UIStackView!
	@IBOutlet internal var webBrowser: WKWebView!
	@IBOutlet internal var progressView: UIProgressView!
	@IBOutlet private var userToolBar: UIToolbar!
	
	var pageObject: BrowserPage!
	
	let goBack = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .plain, target: self, action: #selector(backForwardButtonPressed))
	let goForward = UIBarButtonItem(image: UIImage(systemName: "arrow.forward"), style: .plain, target: self, action: #selector(backForwardButtonPressed))
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Setup URL Address Bar
		addressBar.delegate = self
		addressBar.layer.cornerRadius = Constants.CornderRadius
		
		// Setup WebView
		webBrowser.navigationDelegate = self
		webBrowser.allowsBackForwardNavigationGestures = true
		resetBrowser()
		webBrowser.allowsLinkPreview = true
		
		webBrowser.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
		
		// Setup StackView
		stackView.directionalLayoutMargins = .init(top: 16, leading: 16, bottom: 16, trailing: 16)
		stackView.isLayoutMarginsRelativeArrangement = true
		stackView.layer.cornerRadius = Constants.CornderRadius
		
		
		let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedOnView))
		view.addGestureRecognizer(tapRecognizer)
		
		// Setup ToolBar
		let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
		let openInSafariButton = UIBarButtonItem(image: UIImage(systemName: "safari"), style: .plain, target: self, action: #selector(openInSafari))
		
		goBack.tag = Constants.BackButtonTag
		goBack.isEnabled = false
		
		goForward.tag = Constants.ForwardButtonTag
		goForward.isEnabled = false
		
		let showStack = UIBarButtonItem(image: UIImage(systemName: "square.grid.2x2"), style: .plain, target: self, action: #selector(dismissPressed))
		
		userToolBar.items = [goBack, spacer, goForward, spacer, showStack, spacer, openInSafariButton]
		
		
		
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		print("PG View will Appear")
		// If the webPage is de-init'd when we get back to that page.
		if webBrowser.url == nil {
			webBrowser.reload()
			print("Reloading the web browser!!!!!!!!!!!!!")
		}
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
	}
	
	@objc func dismissPressed(_ sender: UIBarButtonItem) {
		
		// Let's take snapshot of the Browser Page...
		
//		UIGraphicsBeginImageContext(webBrowser.frame.size)
		UIGraphicsBeginImageContext(view.frame.size)
		if let context = UIGraphicsGetCurrentContext() {
			view.layer.render(in: context)
//			webBrowser.layer.render(in: context)
			
			let img = UIGraphicsGetImageFromCurrentImageContext()
			UIGraphicsEndImageContext()
			
			pageObject.image = img
		}
		self.dismiss(animated: true, completion: nil)
	}
	
	@objc func openInSafari(_ sender: UIBarButtonItem) {
		if let url = webBrowser.url {
			UIApplication.shared.open(url, options: [:], completionHandler: nil)
		}
	}
	
	@IBAction private func cancelPressed(_ sender: UIButton) {
		addressBar.resignFirstResponder()
	}
	
	@objc func tappedOnView(_ sender: UIButton) {
		addressBar.resignFirstResponder()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		if addressBar.text?.isEmpty ?? false {
			addressBar.becomeFirstResponder()
		}
	}
}


// MARK:- Text
extension PageViewController: UITextFieldDelegate {
	
	func textFieldDidBeginEditing(_ textField: UITextField) {
		
		UIView.animate(withDuration: 0.25) { [unowned self] in
			cancelButton.isHidden = false
			stackView.layoutIfNeeded()
		}
		
		addressBar.selectedTextRange = addressBar.textRange(from: addressBar.beginningOfDocument, to: addressBar.endOfDocument)
		
	}
	
	func textFieldDidEndEditing(_ textField: UITextField) {
		
		UIView.animate(withDuration: 0.25) { [unowned self] in
			cancelButton.isHidden = true
			stackView.layoutIfNeeded()
		}
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		progressView.isHidden = false
		loadWebPage()
		textField.resignFirstResponder()
		return true
	}
}

