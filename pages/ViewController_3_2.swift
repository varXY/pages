//
//  ViewController_1_2.swift
//  pages
//
//  Created by Bobo on 1/11/16.
//  Copyright © 2016 myname. All rights reserved.
//

import Foundation
import UIKit

class ViewController_3_2: UIViewController {
    
    var request = NSURLRequest()
    var webView = UIWebView()
    
    var pageControl = UIPageControl()
    
    var item = ProductDetail()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = item.title
        self.view.backgroundColor = UIColor.whiteColor()
        
        let quitButton = UIBarButtonItem(image: UIImage(named: "back"), style: .Plain, target: self, action: #selector(ViewController_3_2.quit))
        self.navigationItem.leftBarButtonItem = quitButton
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.hidesBarsOnSwipe = false
        self.navigationController?.hidesBarsOnTap = false
        
        getScrollView()
        getSlider()
        getToolBar()
        getDetailView("¥" + item.price, stars: ["\(Int(item.star))"])
        getWebView(request)
        
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.hidesBarsOnSwipe = false
        self.navigationController?.hidesBarsOnTap = false
    }
    
    func quit() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func getScrollView() {
        let scrollView = UIScrollView(frame: self.view.bounds)
        scrollView.backgroundColor = UIColor.whiteColor()
        scrollView.delegate = self
        scrollView.pagingEnabled = false
        //        scrollView.contentSize = CGSize(width: 0, height: scrollView.frame.height * 1.4 + 130)
        
        scrollView.contentSize = self.view.bounds.size
        self.view = scrollView
    }
    
    func getToolBar() {
        let toolBarItem_0 = UIBarButtonItem(title: "地图导航", style: .Plain, target: self, action: #selector(ViewController_3_2.navi))
        let toolBarItem_1 = UIBarButtonItem(title: "拨打电话", style: .Plain, target: self, action: #selector(ViewController_3_2.call))
//        let toolBarItem_2 = UIBarButtonItem(title: "查看评论", style: .Plain, target: self, action: "seeComment")
        
        let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        
        let toolBarItems = [toolBarItem_0, space, toolBarItem_1]
        self.navigationController?.toolbarHidden = false
        self.navigationController?.toolbar.tintColor = UIColor.themeColor()
        self.setToolbarItems(toolBarItems, animated: true)
    }
    
    func getSlider() {
        
        var thumbs = [item.thumb, item.thumb1, item.thumb2, item.thumb3, item.thumb4]
        var imageURLs = [String]()
        
        for i in 0..<thumbs.count {
            if thumbs[i] != "" {
                imageURLs.append(thumbs[i])
            }
        }
        
        let scrollView = UIScrollView()
        scrollView.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height * 0.4)
        scrollView.contentSize = CGSizeMake(self.view.frame.width * CGFloat(imageURLs.count), 0)
        scrollView.backgroundColor = UIColor.backgroundColor()
        scrollView.pagingEnabled = true
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        
        for i in 0..<imageURLs.count {
            let frame = CGRectMake(scrollView.frame.origin.x + (scrollView.frame.width * CGFloat(i)), 0, scrollView.frame.width, scrollView.frame.height)
            let imageView = UIImageView(frame: frame)
            imageView.loadImageWithURl(NSURL(string: imageURLs[i])!)
            imageView.contentMode = .Center
            imageView.contentMode = .ScaleAspectFit
            scrollView.addSubview(imageView)
        }
        
        pageControl.frame = CGRect(x: scrollView.frame.width / 2 - scrollView.frame.width / 4, y: scrollView.frame.height - 20, width: scrollView.frame.width / 2, height: 20)
        pageControl.numberOfPages = imageURLs.count
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = UIColor.grayColor()
        pageControl.currentPageIndicatorTintColor = UIColor.lightGrayColor()
        
        if pageControl.numberOfPages == 1 || pageControl.numberOfPages == 0 {
            pageControl.hidden = true
        }
        
        self.view.addSubview(scrollView)
        self.view.addSubview(pageControl)
    }
    
    func getDetailView(price: String, stars: [String]) {
        let contentView = UIView(frame: CGRectMake(0, self.view.frame.height * 0.4, self.view.frame.width, 130))
        self.view.addSubview(contentView)
        
        let priceLabel = UILabel(frame: CGRectMake(10, 10, (contentView.frame.width - 20) / 2, (contentView.frame.height-20) / 2))
        priceLabel.text = price == "¥0.01" || price == "¥0.00" ? "价格面议" : price
//        priceLabel.textAlignment = .Center
        priceLabel.textColor = UIColor.themeColor()
        priceLabel.font = UIFont.boldSystemFontOfSize(20)
        contentView.addSubview(priceLabel)
        
//        let button = UIButton(frame: CGRectMake(priceLabel.frame.width + 10, 10, priceLabel.frame.width, priceLabel.frame.height))
//        button.backgroundColor = UIColor.themeColor()
//        button.tintColor = UIColor.whiteColor()
//        button.layer.cornerRadius = 7
//        button.setTitle("立即预约", forState: .Normal)
//        button.addTarget(self, action: "MakeAppointment", forControlEvents: .TouchUpInside)
//        contentView.addSubview(button)
        
        let width = (contentView.frame.width - 10)
        let labelText = ["综合评分：", "服务评分：", "服务态度："]
        let starTitle_0 = UILabel(frame: CGRectMake(10, 75, width + 5, 45))
//        let starTitle_1 = UILabel(frame: CGRectMake(10 + width, 75, width * 2, 45))
//        let starTitle_2 = UILabel(frame: CGRectMake(10 + width * 3, 75, width * 2, 45))
        
        let starTitles = ["⭐️", "⭐️", "⭐️⭐️", "⭐️⭐️⭐️", "⭐️⭐️⭐️⭐️", "⭐️⭐️⭐️⭐️⭐️"]
        let stringTitle = starTitles[Int(item.star)]
        
        let starTitleLabels = [starTitle_0]
        
        for i in 0..<starTitleLabels.count {
            
            let string = NSMutableAttributedString(string: labelText[i] + stringTitle, attributes: [NSForegroundColorAttributeName: UIColor.themeColor()])
            let range = string.mutableString.rangeOfString(labelText[i])
            string.addAttributes([NSForegroundColorAttributeName: UIColor.blackColor()], range: range)
            
            starTitleLabels[i].attributedText = string
//            starTitleLabels[i].textAlignment = .Center
            contentView.addSubview(starTitleLabels[i])
        }
        
    }
    
    func getWebView(request: NSURLRequest) {
        let y = 130 + self.view.frame.height * 0.4
        webView = UIWebView(frame: CGRectMake(0, y, self.view.frame.width, self.view.frame.height - y))
        webView.delegate = self
        //        self.view.userInteractionEnabled = false
        webView.userInteractionEnabled = false
        webView.alpha = 0.0
        //        let url = NSURL(string: "http://www.cncar.net/jq/carservice-index.html")
        webView.loadHTMLString(item.content, baseURL: nil)
        webView.scrollView.contentMode = .ScaleAspectFit
        self.view.addSubview(webView)
        
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        indicator.startAnimating()
        indicator.frame = CGRectMake(0, y, self.view.frame.width, webView.frame.height - 100)
        indicator.tag = 98765
        self.view.addSubview(indicator)
    }
    
    
}


extension ViewController_3_2 : UIWebViewDelegate {
    
    func webViewDidFinishLoad(webView: UIWebView) {
        if let indicator = self.view.viewWithTag(98765) as? UIActivityIndicatorView {
            indicator.removeFromSuperview()
        }
        
        webView.alpha = 1.0
        self.webView.frame.size.height = webView.scrollView.contentSize.height
        if let scrollView = self.view as? UIScrollView {
            let cioncideHeight = self.view.frame.height * 0.6 - 130
            scrollView.contentSize.height += (self.webView.frame.size.height - cioncideHeight - 40)
        }
        
    }
}

extension ViewController_3_2 : UIScrollViewDelegate {
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if scrollView == self.view.subviews[0] as? UIScrollView {
            let width = scrollView.bounds.size.width
            pageControl.currentPage = Int((scrollView.contentOffset.x + width / 2) / width)
        }
        
        if scrollView == self.view {
            let aboveHeight = 130 + self.view.frame.height * 0.4
            scrollView.contentSize.height = self.webView.scrollView.contentSize.height + aboveHeight + 20
            
        }
        
    }
}


extension ViewController_3_2 {
    
    func MakeAppointment() {
        
        let subscribeVC = SubscribeViewController()
        subscribeVC.title = "预约"
//        subscribeVC.info = [item.itemID, item.company, item.title]
        self.navigationController?.pushViewController(subscribeVC, animated: true)
        
        //        let string = String(format: "http://www.cncar.net/jq/carservice-servicelist-reserve.html?itemid=%@&itemname=%@&company=%@", item.itemID, item.title, item.company).URLEncodedString()
        //        let webVC = WebViewController_1()
        //        print(string)
        //
        //        if let url = NSURL(string: string!) {
        //            webVC.url = url
        //        }
        //        webVC.title = "预约"
        //        let webVC_Navi = MainNavigationController(rootViewController: webVC)
        //        self.presentViewController(webVC_Navi, animated: true, completion: nil)
    }
    
    func navi() {
        let searchResult = SearchResult()
        searchResult.latitude = item.latitude
        searchResult.longitude = item.longitude
        searchResult.name = item.company
        
        loadServices.useAppleMap(searchResult)
    }
    
    func call() {
        loadServices.call(self, number: item.telephone)
    }
    
    func seeComment() {
        
        var searchInfo = SearchInfo()
        searchInfo.typeName = "commentList"
//        searchInfo.itemID = item.itemID
        
        //        let search = Search()
        Search.performSearchForText(searchInfo) { (search) -> Void in
            print(search.state)
            
            switch search.state {
            case .Results(let results):
                if let reviews = results as? [Review] {
                    let reviewVC = ReviewListTableViewController()
                    reviewVC.reviews = reviews
                    self.navigationController?.pushViewController(reviewVC, animated: true)
                }
                
            case .NoResults:
                
                let hudView = HudView.hudInView(self.view, animated: true)
                hudView.text = "没有评论"
                
                delay(seconds: 0.7, completion: { () -> () in
                    hudView.removeFromSuperview()
                    self.view.userInteractionEnabled = true
                    
                    //                    let review = Review()
                    //                    review.seller_star = "3"
                    //                    review.seller_qstar = "4"
                    //                    review.seller_astar = "2"
                    //                    review.seller_comment = "这是一个评论"
                    //                    review.fromid = "2"
                    //                    review.seller_ctime = "2016-01-20 14:01:53"
                    //                    review.isAnonymous = "0"
                    //
                    //                    let reviewVC = ReviewListTableViewController()
                    //                    reviewVC.reviews = [review]
                    //                    self.navigationController?.pushViewController(reviewVC, animated: true)
                })
                
                
            default:
                let hudView = HudView.hudInView(self.view, animated: true)
                hudView.text = "连接失败"
                
                delay(seconds: 0.7, completion: { () -> () in
                    hudView.removeFromSuperview()
                    self.view.userInteractionEnabled = true
                })
            }
        }
        
        
        //        let string = String(format: "http://www.cncar.net/jq/carservice-evaluatelist.html?busiId=786&serviceId=292").URLEncodedString()
        //        let webVC = WebViewController()
        //        webVC.title = "评论"
        //        if let url = NSURL(string: string!) {
        //            webVC.url = url
        //        }
        //        
        //        self.navigationController?.pushViewController(webVC, animated: true)
        
    }
}