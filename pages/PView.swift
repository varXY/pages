//
//  PView.swift
//  pages
//
//  Created by Bobo on 15/12/31.
//  Copyright © 2015年 myname. All rights reserved.
//

import Foundation
import UIKit

typealias addTarget = (UIButton) -> Void

class PView: NSObject {
    
    let screenSize = CGSize(width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height)
    
    let screenCenter = CGPoint(x: UIScreen.mainScreen().bounds.width / 2, y: UIScreen.mainScreen().bounds.height / 2)
    
    let h0: CGFloat = 0.37
    let h1: CGFloat = 0.345
    let h2: CGFloat = 0.352
    let h3: CGFloat = 0.475
    
    let h0_1: CGFloat = 0.345
    let h1_1: CGFloat = 0.37
    let h2_1: CGFloat = 0.56
    
    var dragging = false
    var atTheEnd = false
    
    func getScrollingForTable(VC: ViewController_1) {
        var imageNames = [String]()

        switch VC.searchInfo.body[0] {
        case "1":
            VC.searchInfo.pid = "39"
        case "2":
            VC.searchInfo.pid = "40"
        case "3":
            VC.searchInfo.pid = "41"
        default:
            break
        }
            
            var searchInfo = SearchInfo()
            searchInfo.typeName = "ad"
            searchInfo.pid = VC.searchInfo.pid
            let search = Search()
            search.performSearchForText(searchInfo, completion: { (_) -> Void in
                
                switch search.state {
                case .Results(let strings):
                    for string in strings {
                        if string as! String != "" {
                            imageNames.append(string as! String)
                        }
                    }
                    print(imageNames)
                    
                    let frame = CGRect(x: 0, y: 40, width: self.screenSize.width, height: self.screenSize.height * 0.354 - 40)
                    let scrolling = self.scrollingImagesView(frame, imagesCount: imageNames.count, imageNames: imageNames)
                    scrolling.delegate = self
                    VC.contentView.addSubview(scrolling)
                    
                    print(VC.contentView.subviews.count)
                    
                    let timer = NSTimer(timeInterval: 3.0, target: self, selector: "movePic:", userInfo: scrolling, repeats: true)
                    NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSDefaultRunLoopMode)
                    
                default:
                    break
                }
                
            })
            
        

        
        
    }
    
    func getPageForTravel(VC: UIViewController) {
        let scrollView = UIScrollView(frame: VC.view.frame)
        let height = VC.view.frame.height * (h0_1 + h1_1 + h2_1)
        scrollView.contentSize = CGSize(width: 0, height: height)
        VC.view.addSubview(scrollView)
        
        let names = ["境外", "境内", "线路", "特惠", "民宿", "营地", "酒店", "景点"]
        let point_0 = CGPoint(x: 0, y: 0)
        let eightButton = eightButtonView(point_0, titles: names, imageNames: names)
        scrollView.addSubview(eightButton)
        addTarget(VC, view: eightButton)
        
        let imageNames = ["adbar1", "adbar2"]
        let frame_1 = CGRectMake(0, eightButton.frame.height, VC.view.frame.width, VC.view.frame.height * h1_1)
        let scrolling = scrollingImagesView(frame_1, imagesCount: 2, imageNames: imageNames)
        scrolling.delegate = self
        scrollView.addSubview(scrolling)
        addTarget(VC, view: scrolling)
        
        let timer = NSTimer(timeInterval: 3.0, target: self, selector: "movePic:", userInfo: scrolling, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSDefaultRunLoopMode)
        
        let frame_2 = CGRect(x: 0, y: scrolling.frame.origin.y + scrolling.frame.height, width: VC.view.frame.width, height: VC.view.frame.height * h2_1)
        let imageNames_1 = ["2_0", "2_1", "2_2", "2_3", "2_4", "2_5", "2_6"]
        let block = blockView(frame_2, imageNames: imageNames_1)
        scrollView.addSubview(block)
        addTarget(VC, view: block)
    }

    
    func getPageForCarServices(VC: UIViewController) {
        let scrollView = UIScrollView(frame: CGRectMake(0, 0, VC.view.frame.width, VC.view.frame.height - 64))
        let height = screenSize.height * (h0 + h1 + h2 + h3) + 20
        scrollView.contentSize = CGSizeMake(0, height)
        VC.view.addSubview(scrollView)
        
        let imageNames = ["scrollingImage_0", "scrollingImage_1", "scrollingImage_2"]
        let frame0 = CGRectMake(0, 0, VC.view.frame.width, VC.view.frame.height * h0)
        let scrolling = scrollingImagesView(frame0, imagesCount: 3, imageNames: imageNames)
        scrolling.delegate = self
        scrollView.addSubview(scrolling)
        addTarget(VC, view: scrolling)
        
        let timer = NSTimer(timeInterval: 3.0, target: self, selector: "movePic:", userInfo: scrolling, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSDefaultRunLoopMode)
        
        let names = ["汽车保养", "电脑解码", "轮胎轮毂", "故障维修", "电瓶电路", "玻璃换装", "空调水箱", "钣金油漆"]
        let point1 = CGPointMake(0, scrolling.frame.height)
        let eightButton = eightButtonView(point1, titles: names, imageNames: names)
        scrollView.addSubview(eightButton)
        addTarget(VC, view: eightButton)
        
        let news0 = ["新车主不可不知的汽车保养常识", "近几年来，在广大网友中渐渐形成一个消费习惯：就是在临近春节时买辆新车回家过年"]
        let news1 = ["如何辨别真假NGK火花塞", "更换汽车火花塞，不懂型号，不懂如何辨别品牌的真假，使用之后有可能导致仪表灯跟指针出现故障。"]
        let allNews = [news0, news1]
        let imageNames1 = ["news_0", "news_1"]
        let infoView = infomationView(point1.y + eightButton.frame.height + 10, allNews: allNews, imageNames: imageNames1)
        scrollView.addSubview(infoView)
        addTarget(VC, view: infoView)
        
        let names1 = ["车身贴膜", "美容养护", "音响改装", "车窗贴膜", "照明改装", "空力改装", "轮毂改装", "电子升级"]
        let point2 = CGPointMake(0, infoView.frame.origin.y + infoView.frame.height + 10)
        let serviceView = serviceButtonView(point2, names: names1)
        scrollView.addSubview(serviceView)
        addTarget(VC, view: serviceView)

    }
    
    func addTarget(VC: UIViewController, view: UIView) {
        for i in view.subviews {
            if let button = i as? UIButton {
                button.addTarget(VC, action: "openURL:", forControlEvents: .TouchUpInside)
            }
        }
    }
    
    func blockView(frame: CGRect, imageNames: [String]) -> UIView {
        let blockView = UIView(frame: frame)
        blockView.backgroundColor = UIColor.whiteColor()
        
        for i in 0..<7 {
            let button = blockButton(i, imageName: imageNames[i], size: blockView.frame.size)
            blockView.addSubview(button)
        }
        
        return blockView
    }
    
    func appointmentListButton(frame: CGRect) -> UIButton {
        let button = UIButton(frame: frame)
        button.setImage(UIImage(named: "预定按钮"), forState: .Normal)
        button.layer.cornerRadius = button.frame.width / 2
        
        return button
    }
    
    func blockButton(index: Int, imageName: String, size: CGSize) -> UIButton {
        var frame = CGRect.zero
        var imageFrame = CGRect.zero
        var titleFrame = CGRect.zero
        
        switch index {
        case 0:
            frame = CGRect(x: 0, y: 0, width: size.width / 2.5, height: size.height / 2)
            imageFrame = frame
        case 1:
            frame = CGRect(x: size.width / 2.5, y: 0, width: size.width * 3 / 5, height: size.height / 4)
            imageFrame = CGRect(x: -10, y: 0, width: frame.height, height: frame.height)
            titleFrame = CGRect(x: frame.height * 0.8, y: frame.height * 0.2, width: 150, height: 30)
        case 2:
            frame = CGRect(x: size.width / 2.5, y: size.height / 4, width: size.width * 3 / 5, height: size.height / 4)
            imageFrame = CGRect(x: -10, y: 0, width: frame.height, height: frame.height)
            titleFrame = CGRect(x: frame.height * 0.8, y: frame.height * 0.2, width: 150, height: 30)
        case 3:
            frame = CGRect(x: 0, y: size.height / 2, width: size.width * 3 / 4, height: size.height / 4)
            imageFrame = CGRect(x: -10, y: 0, width: frame.height, height: frame.height)
            titleFrame = CGRect(x: frame.height * 0.8, y: frame.height * 0.2, width: 150, height: 30)
        case 4:
            frame = CGRect(x: 0, y: size.height * 3 / 4, width: size.width * 3 / 8, height: size.height / 4)
            imageFrame = CGRect(x: -10, y: 0, width: frame.height, height: frame.height)
            titleFrame = CGRect(x: frame.height * 0.7, y: frame.height * 0.2, width: 150, height: 30)
        case 5:
            frame = CGRect(x: size.width * 3 / 8, y: size.height * 3 / 4, width: size.width * 3 / 8, height: size.height / 4)
            imageFrame = CGRect(x: -18, y: 0, width: frame.height, height: frame.height)
            titleFrame = CGRect(x: frame.height * 0.58, y: frame.height * 0.2, width: 150, height: 30)
        case 6:
            frame = CGRect(x: size.width * 6 / 8, y: size.height / 2, width: size.width / 4, height: size.height / 2)
            imageFrame = CGRect(x: 0, y: 0, width: frame.width, height: frame.width)
            titleFrame = CGRect(x: 10, y: frame.width, width: 150, height: 30)
        default:
            break
        }
        
        let button = UIButton(type: .System)
        button.frame = frame
        button.tag = 10112 + index
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        let imageView = UIImageView(frame: imageFrame)
        imageView.image = UIImage(named: imageName)
        imageView.contentMode = .ScaleAspectFit
        
        if index != 0 {
            imageView.transform = CGAffineTransformMakeScale(0.6, 0.6)
            
            let titles = blockButtonTitles(index)
            let titleLabelView = blockButtonTitleView(titleFrame, index: index, title: titles[0], subTitle: titles[1])
            button.addSubview(titleLabelView)
        }
        
        button.addSubview(imageView)
        
        return button
    }
    
    func blockButtonTitleView(frame: CGRect, index: Int, title: String, subTitle: String) -> UILabel {
        let titleLabel = UILabel()
        titleLabel.frame = frame
        titleLabel.text = title
        titleLabel.font = UIFont.boldSystemFontOfSize(12)
        titleLabel.numberOfLines = 0
        titleLabel.sizeToFit()
        
        let subTitleLabel = UILabel(frame: CGRect(x: 0, y: titleLabel.frame.height, width: 150, height: 30))
        subTitleLabel.text = subTitle
        subTitleLabel.textColor = UIColor.lightGrayColor()
        subTitleLabel.font = UIFont.italicSystemFontOfSize(11)
        titleLabel.addSubview(subTitleLabel)
        
        
        return titleLabel
    }
    
    func blockButtonTitles(index: Int) -> [String] {
        var titles = [String]()
        var title_0 = ""
        var title_1 = ""
        
        switch index {
        case 1:
            title_0 = "中国72条自驾经典线路"
            title_1 = "总有一条适合你"
        case 2:
            title_0 = "冬日钜惠！"
            title_1 = "火热冬季游"
        case 3:
            title_0 = "专属私人订制"
            title_1 = "私人线路，专属服务，贴心价格"
        case 4:
            title_0 = "火爆目的地"
            title_1 = "最火爆线路"
        case 5:
            title_0 = "特价酒店推荐"
            title_1 = "每日特价酒店"
        case 6:
            title_0 = "今日特惠！"
            title_1 = "每日特惠更新"
        default:
            break
        }
        
        titles.append(title_0)
        titles.append(title_1)
        
        return titles
    }
    
    // MARK: ScrollingImagesView
    
    func scrollingImagesView(frame: CGRect, imagesCount: Int, imageNames: [String]) -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.frame = frame
        scrollView.contentSize = CGSizeMake(screenSize.width * CGFloat(imagesCount), 0)
        scrollView.pagingEnabled = true
        
        for i in 0..<imagesCount {
            let buttonFrame = CGRectMake(frame.origin.x + (frame.width * CGFloat(i)), 0, frame.width, frame.height)
            let imageButton = imageButtonForScrolling(buttonFrame, imageName: imageNames[i])
            imageButton.tag = 10101 + i
            scrollView.addSubview(imageButton)
        }
        
        return scrollView
    }
    
    func imageButtonForScrolling(frame: CGRect, imageName: String) -> UIButton {
        let imageButton = UIButton()
        imageButton.frame = frame
        
        if imageName.containsString("http://") {
            let imageView = UIImageView(frame: imageButton.bounds)
            imageView.loadImageWithURl(NSURL(string: imageName)!)
            imageButton.addSubview(imageView)
//            imageButton.imageView?.loadImageWithURl(NSURL(string: imageName)!)
//            UIImage.imageWithURL(NSURL(string: imageName)!, done: { (image) -> Void in
//                imageButton.setImage(image, forState: .Normal)
//                print(image)
//            })

            
        } else {
            imageButton.setImage(UIImage(named: imageName), forState: .Normal)

        }
        
        return imageButton
    }
    
    // MARK: EightButtonView
    
    func eightButtonView(point: CGPoint, titles: [String], imageNames: [String]) -> UIView {
        let eightButtonView = UIView()
        eightButtonView.backgroundColor = UIColor.whiteColor()
        eightButtonView.frame.origin = point
        eightButtonView.frame.size = CGSizeMake(screenSize.width, screenSize.height * h1)
        
        for i in 0..<8 {
            let scale = i < 4 ? i : i - 4
            let height = i < 4 ? 10 : ((eightButtonView.frame.size.height - 20) / 2 + 10)
            let point = CGPointMake(((screenSize.width - 20) / 4) * CGFloat(scale) + 10, height)
            let smallTap = smallTapOneInEight(point, title: titles[i], image: imageNames[i], tag: i)
            smallTap.tag = 10104 + i
            eightButtonView.addSubview(smallTap)
        }
        
        return eightButtonView
    }
    
    
    func smallTapOneInEight(point: CGPoint, title: String, image: String, tag: Int) -> UIButton {
        let oneInEight = UIButton(type: .System)
        oneInEight.tag = tag
        oneInEight.frame.origin = point
        let oneInEightWidth = (screenSize.width - 20) / 4
        let oneInEightHeight = (screenSize.height * h1 - 20) / 2
        oneInEight.frame.size = CGSizeMake(oneInEightWidth, oneInEightHeight)
        
        let imageHeight = oneInEightHeight * 0.6
        let titleImageView = UIImageView(frame: CGRectMake((oneInEightWidth - imageHeight) / 2, 5, imageHeight, imageHeight))
        titleImageView.image = UIImage(named: image)
        oneInEight.addSubview(titleImageView)
        
        let labelHeight = oneInEightHeight * 0.2
        let titleLabel = UILabel(frame: CGRectMake(0, 10 + imageHeight, oneInEight.frame.size.width, labelHeight))
        titleLabel.textAlignment = .Center
        titleLabel.font = UIFont.systemFontOfSize(13)
        titleLabel.text = title
        oneInEight.addSubview(titleLabel)
        
        
        
        return oneInEight
    }
    
    // MARK: NewsView
    
    func infomationView(y: CGFloat, allNews: [[String]], imageNames: [String]) -> UIView {
        let infomationView = UIView(frame: CGRectMake(0, y, screenSize.width, screenSize.height * h2))
        infomationView.backgroundColor = UIColor.whiteColor()
        
        let point0 = CGPointMake(0, 0)
        let tView = titleView(point0, title: "资讯")
        infomationView.addSubview(tView)
        
        for i in 0..<allNews.count {
            let point = CGPointMake(0, 40 + ((screenSize.height * h2 - 40) / 2) * CGFloat(i))
            let newsView = genNewsButton(point, contents: allNews[i], imageName: imageNames[i])
            newsView.tag = 10112 + i
            infomationView.addSubview(newsView)
        }
        
        return infomationView
        
    }
    
    func titleView(point: CGPoint, title: String) -> UIView {
        let titleView = UIView()
        titleView.frame.origin = point
        titleView.frame.size = CGSizeMake(screenSize.width, 40)
        
        let redView = UIView(frame: CGRectMake(10, 10, 3, 20))
        redView.backgroundColor = UIColor.orangeColor()
        titleView.addSubview(redView)
        
        let titleLabel = UILabel(frame: CGRectMake(25, 5, titleView.frame.width, 30))
        titleLabel.text = title
        titleView.addSubview(titleLabel)
        
        let grayLine = UIView(frame: CGRectMake(0, titleView.frame.height - 0.5, titleView.frame.width, 0.5))
        grayLine.backgroundColor = UIColor.lightGrayColor()
        titleView.addSubview(grayLine)
        
        return titleView
    }
    
    func genNewsButton(point: CGPoint, contents: [String], imageName: String) -> UIButton {
        let newsButton = UIButton(type: .System)
        let buttonHeight = (screenSize.height * h2 - 40) / 2
        newsButton.frame.origin = point
        newsButton.frame.size = CGSizeMake(screenSize.width, buttonHeight)
        
        let titleLabel = UILabel(frame: CGRectMake(10, 0, (screenSize.width - 30) * 0.65, buttonHeight * 0.6))
        titleLabel.text = contents[0]
        titleLabel.textColor = UIColor.orangeColor()
        titleLabel.font = UIFont.systemFontOfSize(18)
        newsButton.addSubview(titleLabel)
        
        let contentLabel = UILabel(frame: CGRectMake(10, (buttonHeight * 0.6), (screenSize.width - 30) * 0.65, buttonHeight * 0.35))
        contentLabel.text = contents[1]
        contentLabel.textColor = UIColor.lightGrayColor()
        contentLabel.font = UIFont.systemFontOfSize(14)
        newsButton.addSubview(contentLabel)
        
        let imageView = UIImageView(frame: CGRectMake(10 + titleLabel.frame.width + 10, 5, (screenSize.width - 30) * 0.35, buttonHeight - 10))
        imageView.image = UIImage(named: imageName)
        imageView.contentMode = .ScaleAspectFit
        newsButton.addSubview(imageView)
        
        return newsButton
        
    }
    
    
    // MARK: ServicesView
    
    func serviceButtonView(point: CGPoint, names: [String]) -> UIView {
        let view = UIView()
        view.frame.origin = point
        view.frame.size = CGSizeMake(screenSize.width, screenSize.height * h3)
        view.backgroundColor = UIColor.whiteColor()
        
        let point0 = CGPointMake(0, 0)
        let tView = titleView(point0, title: "服务")
        view.addSubview(tView)
        
        for i in 0..<names.count {
            let scale = i < 4 ? i : i - 4
            let height = i < 4 ? 50 : (screenSize.height * h3 - 70) / 2 + 60
            let point = CGPointMake(((screenSize.width - 50) / 4 + 10) * CGFloat(scale) + 10, CGFloat(height))
            
            let button = serviceButton(point, name: names[i])
            button.tag = 10114 + i
            view.addSubview(button)
        }
        
        return view
    }
    
    func serviceButton(point: CGPoint, name: String) -> UIButton {
        let button = UIButton(type: .System)
        button.backgroundColor = UIColor.whiteColor()
        button.frame.origin = point
        button.frame.size = CGSizeMake((screenSize.width - 50) / 4, (screenSize.height * h3 - 70) / 2)
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        let imageView = UIImageView(frame: CGRectMake(0, 0, button.frame.width, button.frame.height * 0.7))
        imageView.image = UIImage(named: name)
        imageView.contentMode = .ScaleAspectFill
        imageView.clipsToBounds = true
        button.addSubview(imageView)
        
        let label = UILabel(frame: CGRectMake(0, imageView.frame.height, button.frame.width, button.frame.height * 0.28))
        label.text = name
        label.textAlignment = .Center
        label.font = UIFont.systemFontOfSize(12)
        button.addSubview(label)
        
        return button
    }
    
    
}


extension PView: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        dragging = true
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        dragging = false
    }
    
    func movePic(timer: NSTimer) {
        let scrollingImages = timer.userInfo as! UIScrollView
        let onePic = scrollingImages.contentSize.width == scrollingImages.frame.size.width
                
        if dragging == false && onePic == false {
            let atStartPoint = scrollingImages.contentOffset.x == 0
            let atEndPoint = scrollingImages.contentOffset.x == scrollingImages.contentSize.width - scrollingImages.frame.width
            if atStartPoint { atTheEnd = false }
            if atEndPoint { atTheEnd = true }
            atTheEnd ? moveRight(scrollingImages) : moveLeft(scrollingImages)
        }
        
    }
    
    func moveRight(scrollView: UIScrollView) {
        let duration = Double(scrollView.frame.width / 640)
        UIView.animateWithDuration(duration, delay: 0.0, usingSpringWithDamping: 0.95, initialSpringVelocity: 0.5, options: [], animations: { () -> Void in
            scrollView.contentOffset.x -= scrollView.frame.width
        }, completion: nil)
        
    }
    
    func moveLeft(scrollView: UIScrollView) {
        let duration = Double(scrollView.frame.width / 640)
        UIView.animateWithDuration(duration, delay: 0.0, usingSpringWithDamping: 0.95, initialSpringVelocity: 0.5, options: [], animations: { () -> Void in
            scrollView.contentOffset.x += scrollView.frame.width
        }, completion: nil)
    }
}