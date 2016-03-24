//
//  CompanyViewController.swift
//  pages
//
//  Created by Bobo on 1/28/16.
//  Copyright © 2016 myname. All rights reserved.
//

import Foundation
import UIKit


class CompanyViewController: UIViewController {
    
    var tableView: UITableView!
    var sectionHeardView: UIView!
    var detailWebView: UIWebView!
    var company: Company!
    
    var detailHeight: CGFloat = 30
    
    var cellModel = [AnyObject]()
    var selectedIndex = 100
    
    var services: [Company_modelss]!  {
        didSet {
            cellModel = services as [AnyObject]
            tableView.reloadData()
        }
    }
    
    var items: [Company_items]! {
        didSet {
            cellModel = items as [AnyObject]
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.backgroundColor()
        self.title = company.company
        
        let quitButton = UIBarButtonItem(image: UIImage(named: "back"), style: .Plain, target: self, action: #selector(CompanyViewController.quit))
        self.navigationItem.leftBarButtonItem = quitButton
        
        cellModel.append(company)
        sectionHeardView = tableHeaderView()
        detailWebView = UIWebView(frame: CGRectMake(0, 0, ScreenWidth, 30))
        detailWebView.delegate = self
        detailWebView.userInteractionEnabled = false
        detailWebView.loadHTMLString(company.content, baseURL: nil)
        
        tableView = UITableView(frame: self.view.bounds)
        tableView.frame.size.height -= 64
        tableView.separatorStyle = .None
        tableView.dataSource = self
        tableView.delegate = self
        self.view.addSubview(tableView)
        
        let imageView = UIImageView(frame: CGRectMake(0, 0, ScreenWidth, 135))
        
        if company.thumb.containsString("img") {
            if let url = NSURL(string: company.thumb) {
                imageView.loadImageWithURl(url)
                
            }
        } else {
            let image = UIImage.imageWithColor(UIColor.lightGrayColor(), rect: imageView.bounds)
            imageView.image = image
            
            let label = UILabel()
            label.text = "企业暂未上传照片"
            label.textColor = UIColor.whiteColor()
            label.textAlignment = .Center
            label.sizeToFit()

            label.center = CGPoint(x: imageView.bounds.width / 2, y: imageView.bounds.height / 2)
            imageView.addSubview(label)
        }
        
        imageView.contentMode = .ScaleAspectFill
        imageView.clipsToBounds = true
        tableView.tableHeaderView = imageView
        tableView.tableHeaderView?.frame.size.height = 135
        
        getToolBar()

        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        tableView.contentOffset = CGPoint(x: 0, y: 0)
        
        
        
        if let imageView = tableView.tableHeaderView as? UIImageView {
            let url = NSURL(string: "http://www.hjinfo-img.com/cncar-img/201506/08/09-06-45-69-1.jpg")!
            UIImage.imageWithURL(url, done: { (image) -> Void in
                imageView.image = image
            })
        }
    }
    
    func getToolBar() {
        let toolBarItem_0 = UIBarButtonItem(title: "地图导航", style: .Plain, target: self, action: #selector(CompanyViewController.navi))
        let toolBarItem_1 = UIBarButtonItem(title: "拨打电话", style: .Plain, target: self, action: #selector(CompanyViewController.call))
        
        let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        
        let toolBarItems = [toolBarItem_0, space, toolBarItem_1]
        self.navigationController?.toolbarHidden = false
        self.navigationController?.toolbar.tintColor = UIColor.themeColor()
        self.setToolbarItems(toolBarItems, animated: true)
    }
    
    func tableHeaderView() -> UIView {
        let contentView = UIView(frame: CGRectMake(0, 0, ScreenWidth, 40))
        contentView.backgroundColor = UIColor.whiteColor()
        let buttonWidth = ScreenWidth / 4
        
        let titles = ["简介", "服务", "产品", "留言"]
        
        for i in 0..<4 {
            let button = UIButton(type: .System)
            button.frame = CGRectMake(buttonWidth * CGFloat(i), 0, buttonWidth, 40)
            button.setTitle(titles[i], forState: .Normal)
            button.tintColor = UIColor.blackColor()
            button.tag = 100 + i
            button.addTarget(self, action: #selector(CompanyViewController.headerButtonTapped(_:)), forControlEvents: .TouchUpInside)
            contentView.addSubview(button)
        }
        
        let indicateLine = UIView(frame: CGRect(x: 0, y: contentView.frame.height - 2, width: buttonWidth, height: 2))
        indicateLine.backgroundColor = UIColor.themeColor()
        indicateLine.tag = 110
        contentView.addSubview(indicateLine)
        
        if let button = contentView.subviews[0] as? UIButton {
            button.tintColor = UIColor.themeColor()
        }
        
        return contentView
    }
    
    func quit() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func headerButtonTapped(sender: UIButton) {
        if sender.tintColor == UIColor.blackColor() {
            sender.tintColor = UIColor.themeColor()
            
            for i in 100..<110 {
                if i != sender.tag {
                    if let button = sectionHeardView.viewWithTag(i) as? UIButton {
                        button.tintColor = UIColor.blackColor()
                    }
                }
            }
            
        }
        
        sectionHeardView.viewWithTag(110)?.frame.origin.x = sender.frame.origin.x
        
        selectedIndex = sender.tag
        
        if selectedIndex == 100 {
            cellModel = [company]
            tableView.reloadData()
        }
        
        if selectedIndex == 101 {
            if company.modelss.isKindOfClass(NSArray) {
                services = company.modelss.flatMap({ $0 => Company_modelss.self })
            } else {
                let noResult = Company_modelss()
                noResult.models = "无数据"
                services = [noResult]
            }
            
        }
        
        if selectedIndex == 102 {
            if !company.items.isKindOfClass(NSArray) {
                let noResult = Company_items()
                noResult.item_name = "无数据"
                items = [noResult]
            } else {
                items = company.items.flatMap({ $0 => Company_items.self })
                
            }
        }
    }
    
    func navi() {
    }
    
    func call() {
        loadServices.call(self, number: company.telephone)
    }
}

extension CompanyViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch selectedIndex {
        case 100:
            return 4
            
        case 101:
            return services.count
            
        case 102:
            return items.count
            
        default:
            return 1
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        switch selectedIndex {
        case 100:
            if cellModel[0].isKindOfClass(Company) && indexPath.row == 0 {
                return detailHeight
            } else {
                return 44
            }
            
        default:
            return 44
        }
        
        
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return sectionHeardView
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch selectedIndex {
        case 100:
            let cell = UITableViewCell(style: .Value1, reuseIdentifier: nil)
            cell.selectionStyle = .None
            
            if cellModel[0].isKindOfClass(Company) && indexPath.row == 0 {
                cell.contentView.addSubview(detailWebView)
            } else {
                let titles = ["电话：", "电子邮件：", "联系人："]
                cell.textLabel?.text = titles[indexPath.row - 1]
                let details = [company.telephone, company.email, company.truename]
                cell.detailTextLabel?.text = details[indexPath.row - 1]
            }
            
            return cell
            
        case 101:
            let cell = UITableViewCell(style: .Value1, reuseIdentifier: nil)
            cell.textLabel?.text = services[indexPath.row].models
            cell.textLabel?.textColor = UIColor.themeColor()
            cell.detailTextLabel?.text = services[indexPath.row].models_itemid
            return cell
            
        case 102:
            let cell = UITableViewCell(style: .Value1, reuseIdentifier: nil)
            cell.textLabel?.text = items[indexPath.row].item_name
            cell.textLabel?.textColor = UIColor.themeColor()
            cell.detailTextLabel?.text = items[indexPath.row].item_value
            return cell
            
        default:
            let cell = UITableViewCell(style: .Value1, reuseIdentifier: nil)
            return cell
        }

    }
}

extension CompanyViewController: UIWebViewDelegate {
    
    func webViewDidFinishLoad(webView: UIWebView) {
        detailWebView.frame.size.height = detailWebView.scrollView.contentSize.height + 20
        
        let addressLabel = UILabel(frame: CGRectMake(10, detailWebView.frame.height, ScreenWidth - 20, 200))
            addressLabel.numberOfLines = 0
        addressLabel.font = UIFont.systemFontOfSize(16)
        let string_0 = NSMutableAttributedString(string: "经营配件车型 > \n\n提供服务 >\n\n" + "区域：\(company.areaname) \n地址：\(company.address)", attributes: [NSForegroundColorAttributeName: UIColor.blackColor()])
        let range = string_0.mutableString.rangeOfString("经营配件车型 > \n\n提供服务 >\n\n")
        string_0.addAttributes([NSForegroundColorAttributeName: UIColor.themeColor()], range: range)
        addressLabel.attributedText = string_0
        addressLabel.sizeToFit()
        detailHeight = detailWebView.frame.height + addressLabel.frame.height
        webView.addSubview(addressLabel)
        
        tableView.reloadData()
    }
}