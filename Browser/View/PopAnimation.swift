//
//  PopAnimation.swift
//  Browser
//
//  Created by Ankit Shah on 6/30/21.
//

import UIKit

class PopAnimation: NSObject, UIViewControllerAnimatedTransitioning {

	var duration = 0.1
	var cellFrame = CGRect()
	var isPresenting = false
	
	func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
		return duration
	}
	
	func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
		
		let containerView = transitionContext.containerView
		
		switch isPresenting {
		case true:
			//Animate Cell to FullScreen transition
			guard let toView = transitionContext.view(forKey: .to)
			else { fatalError("Unable to transition to \"to\" View") }
			
			let originalCenter = toView.center
			
			containerView.addSubview(toView)
			
			toView.transform = .init(scaleX: cellFrame.width / toView.frame.width, y: cellFrame.height / toView.frame.height)
			toView.center = CGPoint(x: cellFrame.midX, y: cellFrame.midY)
			toView.layer.cornerRadius = Constants.CornderRadius
//			toView.alpha = 0
			
			UIView.animate(withDuration: duration) {
				toView.transform = .identity
				toView.center = originalCenter
//				toView.alpha = 1
			} completion: { _ in
				transitionContext.completeTransition(true)
			}

			break
			
		case false:
			// *	We are Dismissing the controller here...
			guard let fromView = transitionContext.view(forKey: .from)
			else { fatalError("Unable to transition to \"from\" View") }
			
			let originalCenter = fromView.center
			
			containerView.addSubview(fromView)
			
			fromView.clipsToBounds = true
			UIView.animate(withDuration: duration) {
				fromView.transform = .init(scaleX: self.cellFrame.width / fromView.frame.width, y: self.cellFrame.height / fromView.frame.height)
				fromView.center = CGPoint(x: self.cellFrame.midX, y: self.cellFrame.midY)
//				fromView.alpha = 0.2
			} completion: { _ in
				transitionContext.completeTransition(true)
				fromView.transform = .identity
				fromView.center = originalCenter
//				fromView.alpha = 1
				self.cellFrame = CGRect()
			}
			
			break
			
		}
	}
	
	
}
