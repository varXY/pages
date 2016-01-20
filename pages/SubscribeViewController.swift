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
    var tableView: UITableView!
    
    var editButton: UIBarButtonItem?
    
    var applyItems = [ApplyItem]()
    
    var selectedCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title == "预约" ? showSubscribeTableView() : showSubscribeListTableView()
        
        if self.title != "预约" {
            editButton = UIBarButtonItem(title: "Edit", style: .Plain, target: self, action: "edit:")
            self.navigationItem.rightBarButtonItem = editButton
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setToolbarHidden(true, animated: true)
    }
    
    func edit(sender: UIBarButtonItem) {
        if sender.title == "Edit" {
            
            changeButtonTitleBaseOnCount(self.selectedCount)
            
            if let listTableView = tableView as? SubscribeListTableView {
                listTableView.beginEditing()
            }
            
        } else {
            
            if self.selectedCount != 0 {
                
                if let listTableView = tableView as? SubscribeListTableView {
                    listTableView.deleteOrCancel(true)
                }
                
            } else {
                
                if let listTableView = tableView as? SubscribeListTableView {
                    listTableView.deleteOrCancel(false)
                }
                
            }
            
            self.selectedCount = 0
            sender.title = "Edit"
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor.whiteColor()

        }
    }
    
    func showSubscribeTableView() {
        let subscribeTableView = SubscribeTableView(frame: self.view.bounds, info: info)
        subscribeTableView.frame.size.height -= 64
        subscribeTableView.sendBack = { () -> () in
            self.navigationController?.popViewControllerAnimated(true)
        }
        self.tableView = subscribeTableView
        self.view.addSubview(tableView)
    }
    
    func showSubscribeListTableView() {
        let subscribeListTableView = SubscribeListTableView(frame: self.view.bounds, info: ["hello"])
        
        subscribeListTableView.frame.size.height -= 64

        subscribeListTableView.applyItems = applyItems
        
        subscribeListTableView.selectedCount = { (count) -> Void in
            self.selectedCount = count
            self.changeButtonTitleBaseOnCount(self.selectedCount)
        }
        
        self.tableView = subscribeListTableView
        self.view.addSubview(tableView)
        
        
        
    }
    
    func changeButtonTitleBaseOnCount(count: Int) {
        if count == 0 {
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor.whiteColor()
            self.navigationItem.rightBarButtonItem?.title = "Done"
        } else {
            self.navigationItem.rightBarButtonItem?.title = "Delete"
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor.redColor()
        }
    }
}

extension SubscribeViewController: UITableViewDelegate {
    
}






