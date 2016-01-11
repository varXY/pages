//
//  ViewController_2.swift
//  pages
//
//  Created by Bobo on 1/11/16.
//  Copyright © 2016 myname. All rights reserved.
//

import Foundation
import UIKit

class ViewController_2: UIViewController {
    
    var request = NSURLRequest()
    var webView = UIWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "产品详情"
        self.view.backgroundColor = UIColor.whiteColor()
        
        getScrollView()
        getToolBar()
        getSlider()
        getDetailView("¥100", stars: ["4", "4", "5"])
        getWebView(request)
//        getWebView(NSURLRequest(URL: NSURL(string: "http://www.sina.com")!))
    }
    
    func getScrollView() {
        let scrollView = UIScrollView(frame: self.view.bounds)
        scrollView.backgroundColor = UIColor.whiteColor()
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: 0, height: scrollView.frame.height * 1.4 + 130)
        self.view = scrollView
    }
    
    func getToolBar() {
        let toolBarItem_0 = UIBarButtonItem(title: "地图导航", style: .Plain, target: self, action: "navi")
        let toolBarItem_1 = UIBarButtonItem(title: "拨打电话", style: .Plain, target: self, action: "call")
        let toolBarItem_2 = UIBarButtonItem(title: "查看评论", style: .Plain, target: self, action: "seeComment")
        
        let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        
        let toolBarItems = [toolBarItem_0, space, toolBarItem_1,space, toolBarItem_2]
        self.navigationController?.toolbarHidden = false
        self.navigationController?.toolbar.tintColor = UIColor.themeColor()
        self.setToolbarItems(toolBarItems, animated: true)
    }
    
    func getSlider() {
        let scrollView = UIScrollView()
        scrollView.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height * 0.4)
        scrollView.contentSize = CGSizeMake(self.view.frame.width * CGFloat(3), 0)
        scrollView.backgroundColor = UIColor.backgroundColor()
        scrollView.pagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        
        for i in 0..<3 {
            let frame = CGRectMake(scrollView.frame.origin.x + (scrollView.frame.width * CGFloat(i)), 0, scrollView.frame.width, scrollView.frame.height)
            let imageView = UIImageView(frame: frame)
            imageView.image = UIImage(named: "增值服务2")
            imageView.contentMode = .Center
            imageView.contentMode = .ScaleAspectFit
            scrollView.addSubview(imageView)
        }
        
        self.view.addSubview(scrollView)
    }
    
    func getDetailView(price: String, stars: [String]) {
        let contentView = UIView(frame: CGRectMake(0, self.view.frame.height * 0.4, self.view.frame.width, 130))
        self.view.addSubview(contentView)
        
        let priceLabel = UILabel(frame: CGRectMake(10, 10, (contentView.frame.width - 20) / 2, (contentView.frame.height-20) / 2))
        priceLabel.text = price
        priceLabel.textColor = UIColor.themeColor()
        priceLabel.font = UIFont.boldSystemFontOfSize(20)
        contentView.addSubview(priceLabel)
        
        let button = UIButton(frame: CGRectMake(priceLabel.frame.width + 10, 10, priceLabel.frame.width, priceLabel.frame.height))
        button.backgroundColor = UIColor.themeColor()
        button.tintColor = UIColor.whiteColor()
        button.layer.cornerRadius = 7
        button.setTitle("立即预约", forState: .Normal)
        contentView.addSubview(button)
        
        let width = (contentView.frame.width - 10) / 5
        let labelText = ["关注：", "服务评分：", "服务态度："]
        let starTitle_0 = UILabel(frame: CGRectMake(5, 75, width + 5, 45))
        let starTitle_1 = UILabel(frame: CGRectMake(10 + width, 75, width * 2, 45))
        let starTitle_2 = UILabel(frame: CGRectMake(10 + width * 3, 75, width * 2, 45))
        
        let starTitleLabels = [starTitle_0, starTitle_1, starTitle_2]
        
        for i in 0..<starTitleLabels.count {

            let string = NSMutableAttributedString(string: labelText[i] + stars[i], attributes: [NSForegroundColorAttributeName: UIColor.themeColor()])
            let range = string.mutableString.rangeOfString(labelText[i])
            string.addAttributes([NSForegroundColorAttributeName: UIColor.blackColor()], range: range)
            
            starTitleLabels[i].attributedText = string
            starTitleLabels[i].textAlignment = .Center
            contentView.addSubview(starTitleLabels[i])
        }
        
        

    }
    
    func getWebView(request: NSURLRequest) {
        webView = UIWebView(frame: CGRectMake(0, 130 + self.view.frame.height * 0.4, self.view.frame.width, self.view.frame.height))
        webView.delegate = self
        webView.userInteractionEnabled = false
        webView.loadRequest(request)
        
        self.view.addSubview(webView)
    }
    
    
}


extension ViewController_2 : UIWebViewDelegate {
    
    func webViewDidFinishLoad(webView: UIWebView) {
        print(webView.scrollView.contentSize.height)
        if webView.scrollView.contentSize.height <= webView.frame.height {
            webView.frame.size.height = webView.scrollView.contentSize.height
            self.view.frame.size.height -= (webView.frame.size.height - webView.scrollView.contentSize.height)
        }
    }
}

extension ViewController_2 : UIScrollViewDelegate {
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if scrollView == self.view {
            webView.userInteractionEnabled = scrollView.contentOffset.y == 465 ? true : false
        }
    }
}


extension ViewController_2 {
    
    func navi() {
        
    }
    
    func call() {
        
    }
    
    func seeComment() {
        
    }
}