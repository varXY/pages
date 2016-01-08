//
//  CustomPop.swift
//  pages
//
//  Created by Bobo on 1/5/16.
//  Copyright © 2016 myname. All rights reserved.
//

import Foundation
import UIKit

typealias _FDViewControllerWillAppearInjectBlock = (viewConroller: UIViewController, animated: Bool) -> Void



class _FDFullscreenPopGestureRecognizerDelegate: NSObject, UIGestureRecognizerDelegate {
    
    var navigationController =  UINavigationController()
    
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if self.navigationController.viewControllers.count <= 1 {
            return false
        }
        
        let topViewController = self.navigationController.viewControllers.last!
        if topViewController.fd_interactivePopDisabled {
            return false
        }
        
        let beginningLocation = gestureRecognizer.locationInView(gestureRecognizer.view)
        let maxAllowedInitialDistance = topViewController.fd_interactivePopMaxAllowedInitialDistanceToLeftEdge
        
        if maxAllowedInitialDistance > 0 && beginningLocation.x > maxAllowedInitialDistance {
            return false
        }
        
        if let boolValue = self.navigationController.valueForKey("_isTransitioning")?.boolValue {
            if boolValue {
                return false
            }
        }
        
        if let gesture = gestureRecognizer as? UIPanGestureRecognizer {
            let translation = gesture.translationInView(gesture.view)
            if translation.x <= 0 {
                return false
            }
        }
        
        return true
    }
    
    
}


protocol FDFullscreenPopGesture {
    var fd_fullscreenPopGestureRecognizer: UIPanGestureRecognizer { get }
    var fd_viewControllerBasedNavigationBarAppearanceEnabled: Bool { get set }
    
}

protocol FDFullscreenPopGesturePrivate {
    var fd_willAppearInjectBlock: _FDViewControllerWillAppearInjectBlock { get set }
}



extension UINavigationController {
    
    
}