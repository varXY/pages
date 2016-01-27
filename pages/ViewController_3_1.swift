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
    var results = [Product]()
    
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
        
//        let backgroundView = UIView(frame: CGRectMake(0, 0, self.view.frame.width, 40))
//        backgroundView.backgroundColor = UIColor.whiteColor()
//        contentView.addSubview(backgroundView)
//        pView.getSliderForProductTable(self)
//        tableView.tableHeaderView = contentView
        
        performSearch(self.searchInfo)
        
    }
    
    func quit() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func performSearch(searchInfo: SearchInfo) {
        search.performSearchForText(searchInfo) { (_) -> Void in
            print(self.search.state)
            
            switch self.search.state {
            case .Results(let items):
                if let products = items as? [Product] {
                    self.results = products
                    self.tableView.reloadData()
                }
                
            case .NoResults:
                self.results.removeAll()
                self.tableView.reloadData()
                
            default:
                break
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
//        tableView.userInteractionEnabled = false
//        let VC_2 = ViewController_1_2()
//        VC_2.hidesBottomBarWhenPushed = true
//        VC_2.request = NSURLRequest(URL: NSURL(string: String(format: "http://www.cncar.net/api/app/server/content.php?itemid=%@", results[indexPath.row].itemid))!)
//        
//        searchInfo.typeName = "item"
//        searchInfo.itemID = results[indexPath.row].itemid
//        search.performSearchForText(searchInfo) { (_) -> Void in
//            switch self.search.state {
//            case .Results(let items):
//                let item = items[0] as! CSItem
//                VC_2.item = item
//                tableView.deselectRowAtIndexPath(indexPath, animated: false)
//                tableView.userInteractionEnabled = true
//            default:
//                tableView.userInteractionEnabled = true
//                break
//            }
//            
//            self.navigationController?.pushViewController(VC_2, animated: true)
        
//        }
        

    }
}




extension ViewController_3_1 : CompanySelected {
    
    func companySelected(name: String) {
        //        print(__FUNCTION__)
        //
        //        for item in results {
        //            if item.company == name && switchOn == false {
        //                switchOn = true
        //                let urlString = String(format: "http://www.cncar.net/jq/carservice-companydetail.html?itemid=%@&name=%@", item.itemid, name).URLEncodedString()
        //                let url = NSURL(string: urlString!)
        //
        //                let webVC = WebViewController()
        //                webVC.url = url!
        //                webVC.title = name
        //                self.navigationController?.pushViewController(webVC, animated: true)
        //            }
        //        }
        
        
    }
}







