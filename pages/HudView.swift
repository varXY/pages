//
//  HudView.swift
//  SanBank2.0
//
//  Created by 文川术 on 15/8/3.
//  Copyright (c) 2015年 肖瑶. All rights reserved.
//

import UIKit

class HudView: UIView {

	var text = ""

	class func hudInView(view: UIView, animated: Bool) -> HudView {
		let hudView = HudView(frame: view.bounds)
		hudView.opaque = false
		view.addSubview(hudView)
		view.userInteractionEnabled = false
		hudView.showAnimated(animated)
		return hudView
	}

	override func drawRect(rect: CGRect) {
		let boxWidth: CGFloat = 130
		let boxHeight: CGFloat = 130

		let boxRect = CGRect(x: round((self.bounds.size.width - boxWidth) / 2), y: round((bounds.size.height - boxHeight) / 2), width: boxWidth, height: boxHeight)

		let roundedRect = UIBezierPath(roundedRect: boxRect, cornerRadius: 20)
		UIColor(white: 0.3, alpha: 0.8).setFill()
		roundedRect.fill()

		let attribs = [NSFontAttributeName: UIFont.systemFontOfSize(22.0), NSForegroundColorAttributeName: UIColor.whiteColor()]
		let textSize = text.sizeWithAttributes(attribs)
		let textPoint = CGPoint(x: self.center.x - round(textSize.width / 2), y: self.bounds.size.height / 2 - round(textSize.height / 2))
		text.drawAtPoint(textPoint, withAttributes: attribs)
	}

	func showAnimated(animated: Bool) {

		if animated {
			self.alpha = 0
			self.transform = CGAffineTransformMakeScale(1.3, 1.3)

			UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: UIViewAnimationOptions(rawValue: 0), animations: { () -> Void in
				self.alpha = 1
				self.transform = CGAffineTransformIdentity
			}, completion: nil)
			
		}

	}
}
