//
//  SubscribeViewController.swift
//  pages
//
//  Created by Bobo on 1/15/16.
//  Copyright © 2016 myname. All rights reserved.
//

import Foundation
import UIKit

class SubscribeViewController: UIViewController {
    
    var info: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let subscribeTableView = SubscribeTableView(frame: self.view.bounds, info: info)
        subscribeTableView.sendBack = { () -> () in
            self.navigationController?.popViewControllerAnimated(true)
        }
        view.addSubview(subscribeTableView)
        
//        let subscribeView = SubscribeView(frame: self.view.bounds, info: info!)
//        self.view.addSubview(subscribeView)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setToolbarHidden(true, animated: true)
    }
}