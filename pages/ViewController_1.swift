//
//  ViewController_1.swift
//  pages
//
//  Created by Bobo on 1/4/16.
//  Copyright © 2016 myname. All rights reserved.
//

import UIKit
import SnapKit

class ViewController_1: UIViewController {
    
    let pView = PView()
    let pModel = PModel()
    
    var tableView = UITableView()
    var results = [CSResult]()
    
    var filterTitle = "故障维修"
    var Titles_123 = ["价格不限", "距离不限", "默认排序"]
    var success = true
    var subButtonsInView = false
    
    let search = Search()
    
    var searchInfo = SearchInfo()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.lightGrayColor()
        
        tableView.frame = self.view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorColor = UIColor.clearColor()
        view.addSubview(tableView)
        
        let contentView = UIView(frame: CGRectMake(0, 0, self.view.frame.width, 200))
        
        let filterView = FilterView(title: filterTitle)
        filterView.sender = { (button: UIButton) -> Void in
            self.filtered(button)
        }
        contentView.addSubview(filterView)
        
        let scrolling = pView.getScrollingForTable(self)
        contentView.addSubview(scrolling)
        
        tableView.tableHeaderView = contentView
    
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        performSearch(Info: searchInfo)
    }
    
    func filtered(button: UIButton) {
        print(button.tag)
        
        switch button.tag {
            
        case 200:
            if let subView = self.view.viewWithTag(button.tag + 110) {
                subView.removeFromSuperview()
            } else {
                removeOtherSubButtonsView(button.tag)
                
                let filterView = FilterView(title: filterTitle)
                
                if let button = tableView.tableHeaderView?.subviews[0].subviews[0] as? UIButton {
                    self.filterTitle = (button.titleLabel?.text)!
                }
                
                let subView = filterView.ButtonsView_0(self)
                subView.tag = button.tag + 110
                self.tableView.addSubview(subView)
            }

            
        case 201, 202, 203:
            if let subView = self.view.viewWithTag(button.tag + 110) {
                subView.removeFromSuperview()
            } else {
                removeOtherSubButtonsView(button.tag)
                
                let filterView = FilterView(title: Titles_123[button.tag - 201])
                let subView = filterView.buttonsView_123(button.tag - 200, viewController: self)
                subView.tag = button.tag + 110
                self.tableView.addSubview(subView)
            }
            
        default:
            break
        }
        
        
        
        
    }
    
    func removeOtherSubButtonsView(index: Int) {
        for i in 0..<4 {
            let tag = 200 + i
            if i != index {
                if let subView = self.view.viewWithTag(tag + 110) {
                    subView.removeFromSuperview()
                }
            }
        }
    }
    
    
    
    func smallFilterTapped(sender: UIButton) {
        print(sender.tag)
        
        if sender.tag < 230 {
            if let button = tableView.tableHeaderView?.subviews[0].subviews[0] as? UIButton {
                button.setTitle(sender.titleLabel?.text, forState: .Normal)
                
                if let imageView = button.subviews[0] as? UIImageView {
                    imageView.image = UIImage(named: "下拉")
                }
            }
            
            self.searchInfo.CSKindID = kindIDFromIndex(sender.tag - 210)
            performSearch(Info: searchInfo)
            let bigButtonTag = 200 + 110
            if let subView = self.view.viewWithTag(bigButtonTag) {
                subView.removeFromSuperview()
            }
        }
        
        if sender.tag >= 230 && sender.tag < 260 {
            
            var index = 0
            if sender.tag < 240 { index = 0 }
            if sender.tag < 250 && sender.tag >= 240 { index = 1 }
            if sender.tag < 260 && sender.tag >= 250 { index = 2 }
            
            self.Titles_123[index] = (sender.titleLabel?.text)!
            
            if let button = tableView.tableHeaderView?.subviews[0].subviews[index + 1] as? UIButton {
                
                if let imageView = button.subviews[0] as? UIImageView {
                    imageView.image = UIImage(named: "下拉")
                }
            }
            
            let bigButtonTag = 201 + index + 110
            if let subView = self.view.viewWithTag(bigButtonTag) {
                subView.removeFromSuperview()
            }
        }
        
    }
    
    func kindIDFromIndex(index: Int) -> Int {
        var kindID = -1
        
        if index != 11 {
            kindID = index + 345
        } else {
            kindID = 436
        }
        
        return kindID
    }
    
    func performSearch(Info searchInfo: SearchInfo) {
        search.performSearchForText(searchInfo) { (success) -> Void in
            
            switch self.search.state {
            case .Results(let list):
                self.results = list as! [CSResult]
                self.tableView.reloadData()
            default:
                print("someting wrong")
            }
            
            self.success = success
        }
    }
    
    
}


extension ViewController_1: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch search.state {
        case .NotSearchedYet:
            return 0
        case .Loading:
            return 1
        case .NoResults:
            return 1
        case .Results(let list):
            return list.count
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 125
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch search.state {
            
        case .NotSearchedYet:
            fatalError("Should never get here")
            
        case .Loading:
            let cell = UITableViewCell(style: .Default, reuseIdentifier: "cell")
            cell.frame = CGRectMake(0, 0, self.view.frame.width, 125)
            let indicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
            indicator.startAnimating()
            indicator.frame = cell.bounds
            cell.contentView.addSubview(indicator)

            return cell
            
        case .NoResults:
            let cell = UITableViewCell(style: .Default, reuseIdentifier: "cell")
            cell.frame = CGRectMake(0, 0, self.view.frame.width, 125)
            cell.textLabel?.text = "无结果"
            return cell
            
        case .Results(let list):
            self.results = list as! [CSResult]
            let cell = CarServiceCell(style: .Default, reuseIdentifier: "cell")
            cell.frame = CGRectMake(0, 0, self.view.frame.width, 125)
            let result = results[indexPath.row]
            cell.configureForCell(result)
            return cell
            
        }
        
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
}


extension ViewController_1: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        print(__FUNCTION__)
        print(scrollView.contentSize)
        print(scrollView.contentOffset)
        
        if scrollView.contentSize.height - scrollView.contentOffset.y == self.view.frame.height {
            
        }
    }
}



