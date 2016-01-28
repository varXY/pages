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
    
    var contentView = UIView()
    
    var switchOn = false

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.lightGrayColor()
        
        let quitButton = UIBarButtonItem(image: UIImage(named: "back"), style: .Plain, target: self, action: "quit")
        self.navigationItem.leftBarButtonItem = quitButton
        
        tableView.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height - 64)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorColor = UIColor.clearColor()
        view.addSubview(tableView)
        
        contentView = UIView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height * 0.354))
        
        let filterView = FilterView(title: filterTitle, type: searchInfo.body[0])
        filterView.sender = { (button: UIButton) -> Void in
            self.filtered(button)
        }
        self.view.addSubview(filterView)
        
        let backgroundView = UIView(frame: CGRectMake(0, 0, self.view.frame.width, 40))
        backgroundView.backgroundColor = UIColor.whiteColor()
        contentView.addSubview(backgroundView)
        
        pView.getScrollingForTable(self)
        
        tableView.tableHeaderView = contentView
        
        if loadMoreFooterView == nil {
            loadMoreFooterView = LoadMoreTableFooterView(frame: CGRectMake(0, tableView.contentSize.height, tableView.frame.size.width, tableView.frame.size.height))
            loadMoreFooterView!.delegate = self
            loadMoreFooterView!.backgroundColor = UIColor.clearColor()
            tableView.addSubview(loadMoreFooterView!)
        }
        delayLoadFinish()
        
        let listButtonFrame = CGRectMake(20, self.view.frame.height - 134, 61, 61)
        let listButton = pView.appointmentListButton(listButtonFrame)
        listButton.addTarget(self, action: "openList", forControlEvents: .TouchUpInside)
        self.view.addSubview(listButton)
    
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setToolbarHidden(true, animated: true)
        
        self.navigationController?.hidesBarsOnSwipe = false
        self.navigationController?.hidesBarsOnTap = false
//        performSearch(info: searchInfo)
        switchOn = false
        searchInfo.typeName = "carService"
    }
    
    func quit() {
        self.navigationController?.popViewControllerAnimated(true)
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
        
        switch button.tag {
            
        case 200:
            if let subView = self.view.viewWithTag(button.tag + 110) {
                subView.removeFromSuperview()
            } else {
                removeOtherSubButtonsView(button.tag)
                
                let filterView = FilterView(title: filterTitle, type: searchInfo.body[0])
                
                if let button = self.view.subviews[1].subviews[0] as? UIButton {
                    self.filterTitle = (button.titleLabel?.text)!
                }
                
                let subView = filterView.ButtonsView_0(self)
                subView.tag = button.tag + 110
                self.view.addSubview(subView)
            }

            
        case 201, 202, 203:
            if let subView = self.view.viewWithTag(button.tag + 110) {
                subView.removeFromSuperview()
            } else {
                removeOtherSubButtonsView(button.tag)
                
                let filterView = FilterView(title: Titles_123[button.tag - 201], type: searchInfo.body[0])
                let subView = filterView.buttonsView_123(button.tag - 200, viewController: self)
                subView.tag = button.tag + 110
                self.view.addSubview(subView)
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
        
        print(sender.tag)
        
        for i in 0..<4 {
            if let button = self.view.subviews[1].subviews[i] as? UIButton {
                button.enabled = false
            }
        }
        
        if sender.tag < 230 {
            if let button = self.view.subviews[1].subviews[0] as? UIButton {
                button.setTitle(sender.titleLabel?.text, forState: .Normal)
                
                if let imageView = button.subviews[0] as? UIImageView {
                    imageView.image = UIImage(named: "下拉")
                }
            }
            
            if sender.tag == 210 {
                print("kind id is set as -1")
                searchInfo.CSKindID = -1
            } else {
                searchInfo.CSKindID = kindIDFromIndex(sender.tag - 210)
            }
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
                    let distance = 20
                    searchInfo.addition = "&distance=\(distance)"
                } else {
                    let factor = sender.tag - 240
                    let distance = factor == 1 ? 1 : 5 * Double(factor - 1)
                    searchInfo.addition = "&distance=\(distance)"
                }

            }
            
            if sender.tag < 260 && sender.tag >= 250 {
                index = 2
                
                let orderType = sender.tag - 249
                searchInfo.addition = "&orderType=\(orderType)"
            }
            
            self.Titles_123[index] = (sender.titleLabel?.text)!
            
            if let button = self.view.subviews[1].subviews[index + 1] as? UIButton {
                
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
        
        self.tableView.contentOffset.y = 0.0
        
    }
    
    func kindIDFromIndex(index: Int) -> Int {
        var kindID = -1
        switch searchInfo.body[0] {
        case "2":
            if index != 11 {
                kindID = index + 345
            } else {
                kindID = 436
            }
        case "1":
            kindID = index + 335
        case "3":
            kindID = index + 355
        default:
            break
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
    
    func openList() {
        
//        let VC = CommentViewController()
//        VC.itemid = "323"
//        VC.mallid = "2"
//        VC.username = "15927284689"
//        let navi = MainNavigationController(rootViewController: VC)
//        self.presentViewController(navi, animated: true, completion: nil)
        
        let subscribeVC = SubscribeViewController()
        subscribeVC.title = "预约列表"
        subscribeVC.info = ["hello"]
        
        var itemSearchInfo = SearchInfo()
        itemSearchInfo.typeName = "applyItem"
        itemSearchInfo.userName = "15927284689"
        
        search.performSearchForText(itemSearchInfo) { (_) -> Void in
            switch self.search.state {
            case .Results(let items):
                if let applyItem = items as? [ApplyItem] {
                    subscribeVC.applyItems = applyItem
                }
                self.navigationController?.pushViewController(subscribeVC, animated: true)
            case .NoResults:
                let hudView = HudView.hudInView(self.view, animated: true)
                hudView.text = "没有预约"
                
                delay(seconds: 0.7, completion: { () -> () in
                    hudView.removeFromSuperview()
                    self.view.userInteractionEnabled = true
                })
                
            default:
                let hudView = HudView.hudInView(self.view, animated: true)
                hudView.text = "网络出错"
                
                delay(seconds: 0.7, completion: { () -> () in
                    hudView.removeFromSuperview()
                    self.view.userInteractionEnabled = true
                })
            }
        }
        
        
//        let url = NSURL(string: "http://www.cncar.net/jq/carservice-servicelist-reservelist.html".URLEncodedString()!)
//        
//        let webVC = WebViewController_1()
//        webVC.title = "预约"
//        webVC.url = url!
//        let webVC_Navi = MainNavigationController(rootViewController: webVC)
//        self.presentViewController(webVC_Navi, animated: true, completion: nil)
    }
    
    func performSearch(info searchInfo: SearchInfo) {
        search.performSearchForText(searchInfo) { (success) -> Void in
            
            if !success {
                let hudView = HudView.hudInView(self.view, animated: true)
                hudView.text = "网络故障"
                
                delay(seconds: 0.7, completion: { () -> () in
                    hudView.removeFromSuperview()
                    self.view.userInteractionEnabled = true
                    self.navigationController?.popViewControllerAnimated(true)
                })
            }
            
            switch self.search.state {
            case .Results(let list):
                self.results += list as! [CSResult]
            default:
                break
            }
            
            self.tableView.reloadData()
            
            for i in 0..<4 {
                if let button = self.view.subviews[1].subviews[i] as? UIButton {
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
            if results.count == 0 {
                return 1
            } else {
                return results.count
            }
        case .Results(_):
            return results.count
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 135
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch search.state {
            
        case .NotSearchedYet:
//            fatalError("Should never get here")
            
            let cell = UITableViewCell(style: .Default, reuseIdentifier: "cell")
            cell.frame = CGRectMake(0, 0, self.view.frame.width, 125)
            cell.textLabel?.text = "无结果"
            cell.textLabel?.textAlignment = .Center
            tableView.userInteractionEnabled = true
            return cell
            
        case .Loading:
            let cell = UITableViewCell(style: .Default, reuseIdentifier: "cell")
            cell.frame = CGRectMake(0, 0, self.view.frame.width, 125)
            let indicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
            indicator.startAnimating()
            indicator.frame = cell.bounds
            cell.contentView.addSubview(indicator)
            tableView.userInteractionEnabled = false
            return cell
            
        case .NoResults:
            if self.results.count != 0 {
                let cell = CarServiceCell(style: .Default, reuseIdentifier: "cell")
                cell.frame = CGRectMake(0, 0, self.view.frame.width, 125)
//                let result = results[indexPath.row]
//                cell.delegate = self
//                cell.configureForCell(result)
                tableView.userInteractionEnabled = true
                return cell
            } else {
                let cell = UITableViewCell(style: .Default, reuseIdentifier: "cell")
                cell.frame = CGRectMake(0, 0, self.view.frame.width, 125)
                cell.textLabel?.text = "无结果"
                cell.textLabel?.textAlignment = .Center
                tableView.userInteractionEnabled = true
                return cell
            }
            
            
            
        case .Results(_):
            let cell = CarServiceCell(style: .Default, reuseIdentifier: "cell")
//            let result = results[indexPath.row]
//            cell.configureForCell(result)
//            cell.delegate = self
            tableView.userInteractionEnabled = true
            return cell
            
        }
        
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if let customCell = cell as? CarServiceCell {
            customCell.delegate = self
            customCell.configureForCell(results[indexPath.row])
        }
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.userInteractionEnabled = false
        let VC_2 = ViewController_1_2()
        VC_2.hidesBottomBarWhenPushed = true
        VC_2.request = NSURLRequest(URL: NSURL(string: String(format: "http://www.cncar.net/api/app/server/content.php?itemid=%@", results[indexPath.row].itemid))!)
        
        searchInfo.typeName = "item"
        searchInfo.itemID = results[indexPath.row].itemid
        search.performSearchForText(searchInfo) { (_) -> Void in
            switch self.search.state {
            case .Results(let items):
                let item = items[0] as! CSItem
                VC_2.item = item
                tableView.deselectRowAtIndexPath(indexPath, animated: false)
                tableView.userInteractionEnabled = true
            default:
                tableView.userInteractionEnabled = true
                break
            }
            
            self.navigationController?.pushViewController(VC_2, animated: true)

        }
        
        
        
        
    }
}

extension ViewController_1 : CompanySelected {
    
    func companySelected(name: String) {
        print(__FUNCTION__)
        
        for item in results {
            if item.company == name && switchOn == false {
                switchOn = true
                
                var searchInfo = SearchInfo()
                searchInfo.typeName = "company"
                searchInfo.userID = item.userid
                
                Search.performSearchForText(searchInfo) { (search) -> Void in
                    switch search.state {
                    case .Results(let items):
                        if let company = items[0] as? Company {
                            let companyVC = CompanyViewController()
                            companyVC.company = company
                            
                            self.navigationController?.pushViewController(companyVC, animated: true)
                            
                        }
                        
                    default:
                        print(search.state)
                    }
                }

            }
        }
        
        
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





