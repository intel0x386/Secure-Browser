//
//  ViewControllerExtensionWebView.swift
//  Browser
//
//  Created by Ankit Shah on 6/30/21.
//

import Foundation
import WebKit

// MARK:- Web Kit Delegate
extension PageViewController: WKNavigationDelegate {
	
	func loadErrorPage() {
		let htmlErrorStr = """
				<H1> Privacy Browser Can't Find \(addressBar.text) </H1>
		"""
		webBrowser.loadHTMLString(htmlErrorStr, baseURL: nil)
	}
	
	func canOpenURL(string: String?) -> Bool {
		let regEx = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
		let predicate = NSPredicate(format:"SELF MATCHES %@", argumentArray:[regEx])
		return predicate.evaluate(with: string)
	}
	
	func loadWebPage() {
		// Hard Error if addressBar does not contain anything
		guard var urlString = addressBar.text else {
			fatalError("Error in getting address Bar Text")
		}
		
		print("******INSIDE LOAD WEB PAGE")
		
		if !urlString.hasPrefix("http://") && !urlString.hasPrefix("https://") {
			urlString = "https://" + urlString
		}
		
		// Let's try Google Search if URL cannot be formed with
		//  entered Text Field.
		guard let url = URL(string: urlString) else {
			reloadWithGoogleSearch()
			return
		}
		
		if !canOpenURL(string: urlString) {
			reloadWithGoogleSearch()
			return
		}
		
		let urlReq = URLRequest(url: url)
		
		print("***Loading WebPage \(urlReq)")
		webBrowser.load(urlReq)
	} // loadWebPage
	
	func reloadWithGoogleSearch() {
		guard let urlString = addressBar.text,
					let urlEncodedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
		else {
			fatalError("Error in getting address Bar Text")
		}
		
		if let url = URL(string: googleURL + urlEncodedString) {
			let urlReq = URLRequest(url: url)
			webBrowser.load(urlReq)
		}
	} // reloadWithGoogleSearch
	
	func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
		progressView.isHidden = false
	}
	
	func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
		print("***Finished loading the current URL")
		if let currentURL = webView.url?.absoluteString {
			addressBar.text = currentURL
		}

		goBack.isEnabled = webView.canGoBack ? true : false
		goForward.isEnabled = webView.canGoForward ? true : false
		
	}
	
	// In case the Web Page loading has errors, we will arrive here.
	func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
		loadErrorPage()
	}
	
	// In case the URL does not load, we will arrive here.
	func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
		loadErrorPage()
	}
	
	
	
	func resetBrowser() {
		webBrowser.configuration.websiteDataStore.httpCookieStore.getAllCookies { cookies in
			for cookie in cookies {
				self.webBrowser.configuration.websiteDataStore.httpCookieStore.delete(cookie, completionHandler: nil)
			}
		}
		
		webBrowser.configuration.websiteDataStore.removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(), modifiedSince: .distantPast) {
			print("***All Data Removed")
		}
		
		webBrowser.configuration.websiteDataStore.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
		}
	} // reset Browser
	
	override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
		if keyPath == "estimatedProgress" {
			progressView.progress = Float(webBrowser.estimatedProgress)
			
			if webBrowser.estimatedProgress == 1 {
				progressView.isHidden = true
			}
			
		}
	}
	
	@objc func backForwardButtonPressed(_ sender: UIBarButtonItem)
	{
		switch sender.tag {
		
		case Constants.BackButtonTag:
			webBrowser.goBack()
			
		case Constants.ForwardButtonTag:
			webBrowser.goForward()
			
		default:
			break;
		}
	}
	
}
