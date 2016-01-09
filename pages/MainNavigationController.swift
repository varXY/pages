//
//  MainNavigationController.swift
//  Q2
//
//  Created by 文川术 on 15/9/12.
//  Copyright (c) 2015年 xiaoyao. All rights reserved.
//

import Foundation
import UIKit

class MainNavigationController: UINavigationController {

	override func viewDidLoad() {
		super.viewDidLoad()
        self.delegate = self
		let color = UIColor(red: 255/255, green: 181/255, blue: 0/255, alpha: 1.0)
		self.navigationBar.barTintColor = UIColor(red: 255/255, green: 181/255, blue: 0/255, alpha: 1.0)
		self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
		self.navigationBar.tintColor = UIColor.whiteColor()
		self.navigationBar.translucent = false
        
        let rect = CGRectMake(0, 0, self.view.frame.width, 64)
        self.navigationBar.setBackgroundImage(UIImage.imageWithColor(color, rect: rect), forBarMetrics: UIBarMetrics.Default)
        self.navigationBar.shadowImage = UIImage.imageWithColor(UIColor.clearColor(), rect: CGRectMake(0, 0, 10, 10))
        
	}

	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return .LightContent
	}

}

extension MainNavigationController: UINavigationControllerDelegate {
    
    func navigationController(navigationController: UINavigationController, didShowViewController viewController: UIViewController, animated: Bool) {
    }
}










