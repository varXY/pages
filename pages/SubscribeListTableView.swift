//
//  SubscribeListTableView.swift
//  pages
//
//  Created by Bobo on 1/19/16.
//  Copyright © 2016 myname. All rights reserved.
//

import Foundation
import UIKit

typealias SelectedCount = (Int) -> Void
typealias PresentViewController = (UINavigationController) -> Void
typealias ShowAlert = (UIAlertController) -> Void

class SubscribeListTableView: UITableView {
    
    var applyItems = [ApplyItem]()
    
    var selectedCount: SelectedCount?
    var presentViewController: PresentViewController?
    var showAlert: ShowAlert?
    
    var loadMoreFooterView: LoadMoreTableFooterView?
    var loadingMore: Bool = false
    var loadingMoreShowing: Bool = false
    var page = 1
    
    var headerView: UIView?
    var selectedButtonIndex = -1
    
    init(frame: CGRect, info: [String]) {
        super.init(frame: frame, style: .Plain)
        
        self.dataSource = self
        self.delegate = self
        
        self.allowsMultipleSelectionDuringEditing = true
        
        self.separatorColor = UIColor.clearColor()
        
        self.headerView = viewForHeader()
        
        if loadMoreFooterView == nil {
            loadMoreFooterView = LoadMoreTableFooterView(frame: CGRectMake(0, self.contentSize.height, self.frame.size.width, self.frame.size.height))
            loadMoreFooterView!.delegate = self
            loadMoreFooterView!.backgroundColor = UIColor.clearColor()
            self.addSubview(loadMoreFooterView!)
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
            self.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        }
        self.reloadData()
//        performSearch(info: searchInfo)
        //        tableView.reloadData()
    }
    
    func makeDatas() {
        page += 1
        
        var itemSearchInfo = SearchInfo()
        itemSearchInfo.typeName = "applyItem"
        itemSearchInfo.userName = "15927284689"
        itemSearchInfo.page = "\(page)"
        
        let search = Search()
        search.performSearchForText(itemSearchInfo) { (_) -> Void in
            switch search.state {
            case .Results(let items):
                if let applyItems = items as? [ApplyItem] {
                    self.applyItems += applyItems
                    self.reloadData()
                }
            default:
                break
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func viewForHeader() -> UIView {
        let contentView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 40))
        contentView.backgroundColor = UIColor.whiteColor()
        
        let PageWidth = contentView.frame.width
        let width = PageWidth / 5
        let titles = ["全 部", "待确认", "待服务", "已完成", "已取消"]
        
        for i in 0..<5 {
            let rect = CGRectMake((width * CGFloat(i)), 0, width, 40)
            let button = UIButton(type: .System)
            button.frame = rect
            button.setTitle(titles[i], forState: .Normal)
            button.setTitleColor(UIColor.blackColor(), forState: .Normal)
            button.setTitleColor(UIColor.themeColor(), forState: .Selected)
            button.setTitleColor(UIColor.themeColor(), forState: .Highlighted)
            button.tag = 100 + i
            button.addTarget(self, action: #selector(SubscribeListTableView.filter(_:)), forControlEvents: .TouchUpInside)
            contentView.addSubview(button)
        }
        
        let indicateLine = UIView(frame: CGRect(x: 0, y: contentView.frame.height - 2, width: width, height: 2))
        indicateLine.backgroundColor = UIColor.themeColor()
        indicateLine.tag = 110
        contentView.addSubview(indicateLine)
        
        if let button = contentView.subviews[0] as? UIButton {
            button.setTitleColor(UIColor.themeColor(), forState: .Normal)
        }
        
        return contentView
    }
    
    func filter(button: UIButton) {
        if button.titleColorForState(.Normal) == UIColor.blackColor() {
            button.setTitleColor(UIColor.themeColor(), forState: .Normal)
            self.selectedButtonIndex = button.tag - 100 - 1
            
            for i in 100..<105 {
                if i != button.tag {
                    if let button = self.headerView?.viewWithTag(i) as? UIButton {
                        button.setTitleColor(UIColor.blackColor(), forState: .Normal)
                    }
                }
            }
            
        }
        
        let status = button.tag - 100 - 1
        searchAndReload(status)
        
        self.headerView?.viewWithTag(110)?.frame.origin.x = button.frame.origin.x
    }
    
    func beginEditing() {
        self.selectedCount!(0)
        self.setEditing(true, animated: true)
    }
    
    func deleteOrCancel(delete: Bool) {
        if delete {
            
            let indexPaths = self.indexPathsForSelectedRows
            var indexes = [Int]()
            
            if indexPaths?.count > 0 {
                
                for indexPath in indexPaths! {
                    
                    let itemID = self.applyItems[indexPath.row].itemid
                    self.dealWithItem(itemID, action: "delete")
                    
                    indexes.append(indexPath.row)
                }
                
                self.applyItems.removeAtIndexes(indexes)
                self.deleteRowsAtIndexPaths(indexPaths!, withRowAnimation: .Fade)
            }
            

        }
        
        self.setEditing(false, animated: true)
    }
    
    func searchAndReload(status: Int) {
        
        var itemSearchInfo = SearchInfo()
        itemSearchInfo.typeName = "applyItem"
        itemSearchInfo.userName = "15927284689"
        itemSearchInfo.applyStatus = status
        
        let search = Search()
        search.performSearchForText(itemSearchInfo) { (_) -> Void in
            switch search.state {
            case .Results(let items):
                if let results = items as? [ApplyItem] {
                    self.applyItems = results
                    print(self.applyItems.count)
                    self.reloadData()
                }
            default:
                self.applyItems.removeAll()
                self.reloadData()
            }
        }
    }
    
    func dealWithItem(itemID: String, action: String) {
        
        var searchInfo = SearchInfo()
        searchInfo.typeName = "dealWithApply"
        searchInfo.itemID = itemID
        searchInfo.userName = "15927284689"
        searchInfo.action = action
        
        let search = Search()
        search.performSearchForText(searchInfo) { (_) -> Void in
            switch search.state {
            case .Results(let results):
                if let item = results[0] as? CSItem {
                    print(item.title)
                    if item.title == "1" {
                        
                        dispatch_async(dispatch_get_main_queue()) {
                            
                            self.userInteractionEnabled = false
                            let hudView = HudView.hudInView(self, animated: true)
                            hudView.text = "操作成功"
                            
                            delay(seconds: 0.7, completion: { () -> () in
                                hudView.removeFromSuperview()
                                self.userInteractionEnabled = true
                                self.searchAndReload(self.selectedButtonIndex)
                            })
                        }
                        
                    } else {
                        self.userInteractionEnabled = false
                        let hudView = HudView.hudInView(self, animated: true)
                        hudView.text = "操作失败"
                        
                        delay(seconds: 0.7, completion: { () -> () in
                            hudView.removeFromSuperview()
                            self.userInteractionEnabled = true
                        })
                    }
                }
            default:
                break
            }
        }
    }
    
    func writeComment(itemID: String) {
        let VC = CommentViewController()
        VC.itemid = itemID
        
        for item in applyItems {
            if item.itemid == itemID {
                VC.mallid = item.mallid
            }
        }
        
        VC.username = "15927284689"
        let navi = MainNavigationController(rootViewController: VC)
        
        self.presentViewController!(navi)

    }
}

extension SubscribeListTableView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return applyItems.count == 0 ? 1 : applyItems.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.headerView
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if applyItems.count != 0 {
            let cell = CarServiceListCell(style: .Default, reuseIdentifier: "cell")
            return cell
        } else {
            let cell = UITableViewCell(style: .Default, reuseIdentifier: "cell")
            cell.frame = CGRectMake(0, 0, self.frame.width, 200)
            cell.textLabel?.text = "无结果"
            cell.textLabel?.textAlignment = .Center
            tableView.userInteractionEnabled = true
            return cell
        }
        
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if applyItems.count != 0 {
            if let listCell = cell as? CarServiceListCell {
                listCell.delegate = self
                listCell.configureForCell(applyItems[indexPath.row])
            }
        }
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        return indexPath
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if self.editing == true {
            self.selectedCount!((self.indexPathsForSelectedRows?.count)!)
        } else {
            self.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        if self.editing == true {
            self.indexPathsForSelectedRows != nil ? self.selectedCount!((self.indexPathsForSelectedRows?.count)!) : self.selectedCount!(0)
        }
    }
    
//    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//        
//        dealWithItem(applyItems[indexPath.row].itemid, action: "delete")
//        
//        applyItems.removeAtIndex(indexPath.row)
//        
//        self.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
//    }
}


extension SubscribeListTableView: LoadMoreTableFooterViewDelegate {
    
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
        loadMoreFooterView!.loadMoreScrollViewDataSourceDidFinishedLoading(self)
    }
}


extension SubscribeListTableView: ActionEvent {
    
    func actionSended(itemID: String, buttonTitle: String) {
        switch buttonTitle {
        case "关闭":
            dealWithItem(itemID, action: "close")
        case "完成":
            dealWithItem(itemID, action: "done")
        case "申请取消":
            dealWithItem(itemID, action: "cancel")
        case "确认":
            dealWithItem(itemID, action: "check")
        case "同意取消":
            dealWithItem(itemID, action: "apply")
        case "删除":
            let alert = UIAlertController(title: "确定删除吗？", message: nil, preferredStyle: .Alert)
            let action_0 = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
            let action_1 = UIAlertAction(title: "确定", style: .Default, handler: { (_) -> Void in
                self.dealWithItem(itemID, action: "delete")
            })
            
            alert.addAction(action_0)
            alert.addAction(action_1)
            
            self.showAlert!(alert)
            
        case "评价":
            writeComment(itemID)
        default:
            break
        }
    }
}





