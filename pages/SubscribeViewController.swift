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
        
        self.title == "预约" ? showSubscribeTableView() : showSubscribeListTableView()
        
        if self.title != "预约" {
            self.navigationItem.rightBarButtonItem = editButtonItem()
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setToolbarHidden(true, animated: true)
    }
    
    func showSubscribeTableView() {
        let subscribeTableView = SubscribeTableView(frame: self.view.bounds, info: info)
        subscribeTableView.frame.size.height -= 64
        subscribeTableView.sendBack = { () -> () in
            self.navigationController?.popViewControllerAnimated(true)
        }
        self.view.addSubview(subscribeTableView)
    }
    
    func showSubscribeListTableView() {
        let subscribeListTableView = SubscribeListTableView(frame: self.view.bounds, info: ["hello"])
        subscribeListTableView.frame.size.height -= 64
        self.view.addSubview(subscribeListTableView)
    }
}

extension SubscribeViewController: UITableViewDelegate {
    
}






