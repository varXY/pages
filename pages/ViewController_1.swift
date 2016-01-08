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
    
    var loadMoreFooterView: LoadMoreTableFooterView?
    var loadingMore: Bool = false
    var loadingMoreShowing: Bool = false
    
    let search = Search()
    var page = 1
    
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
        
        if loadMoreFooterView == nil {
            loadMoreFooterView = LoadMoreTableFooterView(frame: CGRectMake(0, tableView.contentSize.height, tableView.frame.size.width, tableView.frame.size.height))
            loadMoreFooterView!.delegate = self
            loadMoreFooterView!.backgroundColor = UIColor.clearColor()
            tableView.addSubview(loadMoreFooterView!)
        }
        delayLoadFinish()
    
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
//        performSearch(info: searchInfo)
    }
    
    func delayLoadFinish() {
        if (loadingMore) {
            doneLoadingMoreTableViewData()
        }
        
        loadingMoreShowing = true
//        let itemsCount = 30
//        if (itemsCount != 30) {
//            loadingMoreShowing = false
//        } else {
//            loadingMoreShowing = true
//        }
        if (!loadingMoreShowing) {
            tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        }
        
        performSearch(info: searchInfo)
//        tableView.reloadData()
    }
    
    func makeDatas() {
        self.page += 1
        
        self.searchInfo.body[3] = String(self.page)
        performSearch(info: searchInfo)
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
        self.results.removeAll()
        self.page = 1
        self.searchInfo.body[3] = "1"
        
        for i in 0..<4 {
            if let button = tableView.tableHeaderView?.subviews[0].subviews[i] as? UIButton {
                button.enabled = false
            }
        }
        
        if sender.tag < 230 {
            if let button = tableView.tableHeaderView?.subviews[0].subviews[0] as? UIButton {
                button.setTitle(sender.titleLabel?.text, forState: .Normal)
                
                if let imageView = button.subviews[0] as? UIImageView {
                    imageView.image = UIImage(named: "下拉")
                }
            }
            
            searchInfo.CSKindID = kindIDFromIndex(sender.tag - 210)
            searchInfo.addition = ""
            performSearch(info: searchInfo)
            let bigButtonTag = 200 + 110
            if let subView = self.view.viewWithTag(bigButtonTag) {
                subView.removeFromSuperview()
            }
        }
        
        if sender.tag >= 230 && sender.tag < 260 {
            
            var index = 0
            
            if sender.tag < 240 {
                index = 0
                
                if sender.tag == 230 {
                    searchInfo.addition = ""
                } else if sender.tag == 235 {
                    searchInfo.addition = ""
                    customFilter(0)
                } else {
                    let factor = sender.tag - 231
                    let minPrice = 500 * factor
                    let maxPrice = 500 * (factor + 1)
                    searchInfo.addition = "&minPrice=\(minPrice)&maxPrice=\(maxPrice)"
                }
                
            }
            
            if sender.tag < 250 && sender.tag >= 240 {
                index = 1
                
                if sender.tag == 240 {
                    searchInfo.addition = ""
                } else if sender.tag == 245 {
                    searchInfo.addition = ""
                    customFilter(1)
                } else if sender.tag == 244 {
                    let distance = 20.0
                    searchInfo.addition = "&distance=\(distance)"
                } else {
                    let factor = sender.tag - 240
                    let distance = factor == 1 ? 10.0 : 50.0 * Double(factor - 1)
                    searchInfo.addition = "&distance=\(distance)"
                }

            }
            
            if sender.tag < 260 && sender.tag >= 250 {
                index = 2
                
                let orderType = sender.tag - 249
                searchInfo.addition = "&orderType=\(orderType)"
            }
            
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
            
            performSearch(info: searchInfo)
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
    
    func customFilter(type: Int) {
        
        var title = ""
        var placeholder_0 = ""
        var placeholder_1 = ""
        
        switch type {
        case 0:
            title = "自定义价格"
            placeholder_0 = "最低价格"
            placeholder_1 = "最高价格"
        case 1:
            title = "自定义距离"
            placeholder_0 = "距离范围"
        default:
            break
        }
        
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "确定", style: .Default) { (action) -> Void in
            if type == 0 {
                if let minPrice = alert.textFields![0].text {
                    if let maxPrice = alert.textFields![1].text {
                        self.searchInfo.addition = "&minPrice=\(minPrice)&maxPrice=\(maxPrice)"
                        self.searchInfo.body[3] = "1"
                        self.results.removeAll()
                        self.performSearch(info: self.searchInfo)
                    }
                }
                
                
            } else {
                if let distance = alert.textFields![0].text {
                    self.searchInfo.addition = "&distance=\(distance)"
                    self.searchInfo.body[3] = "1"
                    self.results.removeAll()
                    self.performSearch(info: self.searchInfo)
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .Default) { (action) -> Void in
        }
        
        alert.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = placeholder_0
            textField.keyboardType = .DecimalPad
        }
        
        if type == 0 {
            alert.addTextFieldWithConfigurationHandler { (textField) -> Void in
                textField.placeholder = placeholder_1
                textField.keyboardType = .DecimalPad
            }
        }
        
        
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func performSearch(info searchInfo: SearchInfo) {
        search.performSearchForText(searchInfo) { (success) -> Void in
            
            if !success {
                print("something wrong with net work")
            }
            
            switch self.search.state {
            case .Results(let list):
                self.results += list as! [CSResult]
            default:
                break
            }
            
            self.tableView.reloadData()
            
            for i in 0..<4 {
                if let button = self.tableView.tableHeaderView?.subviews[0].subviews[i] as? UIButton {
                    button.enabled = true
                }
            }
            
            self.doneLoadingMoreTableViewData()
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
            return results.count
        case .Results(_):
            return results.count
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
            if self.results.count != 0 {
                let cell = CarServiceCell(style: .Default, reuseIdentifier: "cell")
                cell.frame = CGRectMake(0, 0, self.view.frame.width, 125)
                let result = results[indexPath.row]
                cell.configureForCell(result)
                return cell
            } else {
                let cell = UITableViewCell(style: .Default, reuseIdentifier: "cell")
                cell.frame = CGRectMake(0, 0, self.view.frame.width, 125)
                cell.textLabel?.text = "无结果"
                cell.textLabel?.textAlignment = .Center
                return cell
            }
            
            
        case .Results(_):
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
    
    func scrollViewDidScroll(scrollView: UIScrollView)
    {
        if (loadingMoreShowing) {
            loadMoreFooterView!.loadMoreScrollViewDidScroll(scrollView)
        }
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if (loadingMoreShowing) {
            loadMoreFooterView!.loadMoreScrollViewDidEndDragging(scrollView)
        }
    }
}

extension ViewController_1: LoadMoreTableFooterViewDelegate {
    
    func loadMoreTableFooterDidTriggerRefresh(view: LoadMoreTableFooterView) {
        loadMoreTableViewDataSource()
    }
    
    func loadMoreTableFooterDataSourceIsLoading(view: LoadMoreTableFooterView) -> Bool {
        return loadingMore
    }
    
    // ViewController function
    func loadMoreTableViewDataSource() {
        loadingMore = true
        makeDatas()
    }
    
    func doneLoadingMoreTableViewData() {
        loadingMore = false
        loadMoreFooterView!.loadMoreScrollViewDataSourceDidFinishedLoading(tableView)
    }
}





