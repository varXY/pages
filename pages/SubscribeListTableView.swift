//
//  SubscribeListTableView.swift
//  pages
//
//  Created by Bobo on 1/19/16.
//  Copyright © 2016 myname. All rights reserved.
//

import Foundation
import UIKit

class SubscribeListTableView: UITableView {
    
    init(frame: CGRect, info: [String]) {
        super.init(frame: frame, style: .Plain)
        
        self.dataSource = self
        self.delegate = self
        
        self.allowsMultipleSelectionDuringEditing = true
        
        self.separatorColor = UIColor.clearColor()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func viewForHeader() -> UIView {
        let contentView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 50))
        contentView.backgroundColor = UIColor.whiteColor()
        
        let PageWidth = contentView.frame.width
        let width = PageWidth / 5
        let titles = ["全 部", "待确认", "待服务", "已完成", "已取消"]
        
        for i in 0..<5 {
            let rect = CGRectMake((width * CGFloat(i)), 0, width, 50)
            let button = UIButton(type: .System)
            button.frame = rect
            button.setTitle(titles[i], forState: .Normal)
            button.setTitleColor(UIColor.blackColor(), forState: .Normal)
            button.setTitleColor(UIColor.themeColor(), forState: .Selected)
            button.setTitleColor(UIColor.themeColor(), forState: .Highlighted)
            button.tag = 100 + i
            button.addTarget(self, action: "filter:", forControlEvents: .TouchUpInside)
            contentView.addSubview(button)
        }
        
        return contentView
    }
    
    func filter(button: UIButton) {
        if button.tag == 100 {
            self.setEditing(true, animated: true)
        } else {
            self.setEditing(false, animated: true)
        }
    }
}

extension SubscribeListTableView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = viewForHeader()
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = CarServiceListCell(style: .Default, reuseIdentifier: "cell")
        cell.configureForCell()
        return cell
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        return indexPath
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(self.indexPathsForSelectedRows)
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    }
}