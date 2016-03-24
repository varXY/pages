//
//  ViewController_3_1.swift
//  pages
//
//  Created by Bobo on 1/25/16.
//  Copyright © 2016 myname. All rights reserved.
//

import Foundation
import UIKit

class ViewController_3_1: UIViewController {
    
    let pView = PView()
    let pModel = PModel()
    
    var tableView = UITableView()
    var topButtonView = UIView()
    var results = [Product]()
    
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
    
    var cats = [Product_catID]()
    
    var selectedCatTitle = "全部"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.backgroundColor()
        
        let quitButton = UIBarButtonItem(image: UIImage(named: "back"), style: .Plain, target: self, action: #selector(ViewController_3_1.quit))
        self.navigationItem.leftBarButtonItem = quitButton
        
        tableView.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height - 64)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorColor = UIColor.clearColor()
        view.addSubview(tableView)
        
        contentView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight * 0.352)
        let backgroundView = UIView(frame: CGRectMake(0, 0, self.view.frame.width, 40))
        backgroundView.backgroundColor = UIColor.whiteColor()
        contentView.addSubview(backgroundView)
        pView.getSliderForProductTable(self)
        tableView.tableHeaderView = contentView
        
        topButtonView = self.filterView()
        self.view.addSubview(topButtonView)
        
        
        if loadMoreFooterView == nil {
            loadMoreFooterView = LoadMoreTableFooterView(frame: CGRectMake(0, tableView.contentSize.height, tableView.frame.size.width, tableView.frame.size.height))
            loadMoreFooterView!.delegate = self
            loadMoreFooterView!.backgroundColor = UIColor.clearColor()
            tableView.addSubview(loadMoreFooterView!)
        }
        delayLoadFinish()
        
        
        
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
        
        performSearch(self.searchInfo)
        //        tableView.reloadData()
    }
    
    func makeDatas() {
        self.page += 1
        
        self.searchInfo.body[3] = String(self.page)
        performSearch(self.searchInfo)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setToolbarHidden(true, animated: true)
        
        switchOn = false
    }
    
    func quit() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func performSearch(searchInfo: SearchInfo) {
        search.performSearchForText(searchInfo) { (_) -> Void in
            
            switch self.search.state {
            case .Results(let items):
                if let products = items as? [Product] {
                    self.results += products
                    self.tableView.reloadData()
                    self.view.userInteractionEnabled = true
                }
                
            case .NoResults:
                self.results.removeAll()
                self.tableView.reloadData()
                self.view.userInteractionEnabled = true
                
            default:
                break
            }
            
            self.doneLoadingMoreTableViewData()
        }
        
        self.topButtonView.userInteractionEnabled = true
    }
    
    func filterView() -> UIView {
        let contentView = UIView(frame: CGRectMake(0, 0, ScreenWidth, 40))
        contentView.backgroundColor = UIColor.whiteColor()
        
        let titles = ["全部", "排序", "筛选"]
        let buttonWidth = ScreenWidth / 3
        
        for i in 0..<3 {
            let rect = CGRectMake(buttonWidth * CGFloat(i), 0, buttonWidth, 40)
            let button = UIButton(type: .System)
            button.frame = rect
            button.setTitle(titles[i], forState: .Normal)
            button.tintColor = UIColor.blackColor()
            button.layer.borderWidth = 0.5
            button.layer.borderColor = UIColor.lightGrayColor().CGColor
            
            let imageView = UIImageView(image: UIImage(named: "下拉"))
            imageView.frame = CGRectMake(button.frame.width - 15, 17.5, 8, 5)
            button.addSubview(imageView)
            
            button.tag = 1000 + i
            contentView.addSubview(button)
            
            button.addTarget(self, action: #selector(ViewController_3_1.filter(_:)), forControlEvents: .TouchUpInside)
            
            
        }
        
        return contentView
    }
    
    func filter(sender: UIButton) {
        
        if sender.tag == 1000 {
            var searchInfo = SearchInfo()
            searchInfo.typeName = "productCatID"
            searchInfo.productKindID = self.searchInfo.productKindID
            
            Search.performSearchForText(searchInfo, completion: { (search) -> Void in
                switch search.state {
                case .Results(let cats):
                    self.changeColorAndImgeOfButton(sender)
                    self.cats = cats as! [Product_catID]
                    if let view = self.view.viewWithTag(11110) {
                        view.removeFromSuperview()
                    } else {
                        self.showCatsView(self.cats)
                    }
                default:
                    let hudView = HudView.hudInView(self.view, animated: true)
                    hudView.text = "网络错误"
                    
                    delay(seconds: 0.7, completion: { () -> () in
                        hudView.removeFromSuperview()
                        self.view.userInteractionEnabled = true
                    })
                }
            })
            
        }
    }
    
    func changeColorAndImgeOfButton(sender: UIButton) {
        if let imageView = sender.subviews[0] as? UIImageView {
            
            if imageView.image == UIImage(named: "下拉") {
                imageView.image = UIImage(named: "收起")
                
                for view in topButtonView.subviews {
                    if let btn = view as? UIButton {
                        if btn != sender {
                            FilterView.changeButtonsImage(btn)
                        }
                    }
                }
                
            } else {
                imageView.image = UIImage(named: "下拉")
                
                for view in topButtonView.subviews {
                    if let btn = view as? UIButton {
                        if btn != sender {
                            FilterView.changeButtonsImage(btn)
                        }
                    }
                }
            }
            
        }
    }
    
    func showCatsView(cats: [Product_catID]) {
        let contentView = UIView()
        contentView.frame.origin = CGPoint(x: 0, y: 40)
        contentView.backgroundColor = UIColor.whiteColor()
        let times = ceil(CGFloat(cats.count / 4))
        contentView.frame.size = CGSize(width: self.view.frame.width, height: 20 + 50 * (times + 1))
        var y: CGFloat = 10
        
        for i in 0..<cats.count {
            let factor = i % 4
            let x = 10 + (contentView.frame.width - 20) / 4 * CGFloat(factor)
            
            let button = UIButton(type: .System)
            button.frame = CGRectMake(x, y, (contentView.frame.width - 20) / 4, 50)
            button.setTitle(cats[i].text, forState: .Normal)
            button.tintColor = UIColor.blackColor()
            button.layer.borderWidth = 0.5
            button.layer.borderColor = UIColor.lightGrayColor().CGColor
            button.addTarget(self, action: #selector(ViewController_3_1.smallButtonTapped(_:)), forControlEvents: .TouchUpInside)
            contentView.addSubview(button)
            
            if x == 10 + (contentView.frame.width - 20) / 4 * CGFloat(3) {
                y += 50
            }
            
            if button.titleLabel?.text == self.selectedCatTitle {
                button.tintColor = UIColor.themeColor()
            }
        }
        
        contentView.tag = 11110
        self.view.addSubview(contentView)
    }
    
    func addSecondaryButtonView(index: Int) -> UIView {
        let contentView = UIView()
        contentView.frame.origin = CGPoint(x: 0, y: 40)
        if index == 1 {
            contentView.frame.size = CGSize(width: ScreenWidth, height: 120)
            
            let titles = ["综合排序", "价格升序", "价格降序"]
            
            for i in 0..<3 {
                let frame = CGRectMake(0, 40 * CGFloat(i), ScreenWidth, 40)
                let button = UIButton(frame: frame)
                button.setTitle(titles[i], forState: .Normal)
                contentView.addSubview(button)
            }
            
        }
        
        return contentView
    }
    
    func smallButtonTapped(sender: UIButton) {
        
        self.view.userInteractionEnabled = false
        
        self.selectedCatTitle = (sender.titleLabel?.text)!
        
        if let button = self.topButtonView.subviews[0] as? UIButton {
            button.setTitle(self.selectedCatTitle, forState: .Normal)
            changeColorAndImgeOfButton(button)
        }
        
        if let view = self.view.viewWithTag(11110) {
            view.removeFromSuperview()
        }
        
        for cat in self.cats {
            if cat.text == sender.titleLabel?.text {
                var searchInfo = SearchInfo()
                searchInfo.typeName = "products"
                searchInfo.body = ["1", "1", "1", "1"]
                searchInfo.productKindID = cat.catid
                performSearch(searchInfo)
            }
        }
        
    }
    
}



extension ViewController_3_1: UITableViewDataSource, UITableViewDelegate {
    
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
                let cell = ProductCell(style: .Default, reuseIdentifier: "cell")
                cell.frame = CGRectMake(0, 0, self.view.frame.width, 125)
//                let result = results[indexPath.row]
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
            let cell = ProductCell(style: .Default, reuseIdentifier: "cell")
//            let result = results[indexPath.row]
//            cell.configureForCell(result)
//            cell.delegate = self
            tableView.userInteractionEnabled = true
            return cell
            
        }
        
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if let customCell = cell as? ProductCell {
            customCell.delegate = self
            customCell.configureForCell(results[indexPath.row])
        }
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.userInteractionEnabled = false
        let VC_2 = ViewController_3_2()
        VC_2.hidesBottomBarWhenPushed = true
        VC_2.request = NSURLRequest(URL: NSURL(string: String(format: "http://www.cncar.net/api/app/server/content.php?itemid=%@", results[indexPath.row].itemid))!)
        
        searchInfo.typeName = "productDetail"
        searchInfo.userName = "15927284689"
        searchInfo.itemID = results[indexPath.row].itemid
        search.performSearchForText(searchInfo) { (_) -> Void in
            switch self.search.state {
            case .Results(let items):
                let item = items[0] as! ProductDetail
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


extension ViewController_3_1: UIScrollViewDelegate {
    
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

extension ViewController_3_1: CompanySelected {
    
    func companySelected(name: String) {
        
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


extension ViewController_3_1: LoadMoreTableFooterViewDelegate {
    
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




