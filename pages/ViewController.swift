//
//  ViewController.swift
//  pages
//
//  Created by Bobo on 15/12/31.
//  Copyright © 2015年 myname. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let pView = PView()
    let pModel = PModel()
    
    var segmentControl = UISegmentedControl()


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.backgroundColor()
        
        segmentControl = UISegmentedControl(items: pModel.titles)
        for i in 0..<4 { segmentControl.setWidth(75, forSegmentAtIndex: i) }
        segmentControl.selectedSegmentIndex = UISegmentedControlNoSegment
        segmentControl.addTarget(self, action: "segmentSelected:", forControlEvents: UIControlEvents.AllEvents)
        self.navigationItem.titleView = segmentControl
        
        pView.getPageForCarServices(self)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    func segmentSelected(sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex != -1 {
            var numbers = [AnyObject]()
            
            switch sender.selectedSegmentIndex {
            case 0:
                numbers = [2, -1, "汽车维修"]
            case 1:
                numbers = [1, -1, "汽车美容"]
            case 2:
                numbers = [3, -1, "增值服务"]
            case 3:
                let newsVC = ViewController_3()
                newsVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(newsVC, animated: true)
//                let webVC = WebViewController()
//                let url = NSURL(string: "http://www.cncar.net/jq/carservice-infoindex.html")!
//                webVC.url = url
//                webVC.title = "行业资讯"
//                webVC.hidesBottomBarWhenPushed = true
//                navigationController?.pushViewController(webVC, animated: true)
            default:
                break
            }
            
            if numbers.count != 0 { segmentJump(numbers) }
            
        }
        
        segmentControl.selectedSegmentIndex = UISegmentedControlNoSegment
    }
    
    func segmentJump(numbers: AnyObject) {
        
        var searchInfo = SearchInfo()
        searchInfo.typeName = "carService"
        searchInfo.body = ["\(numbers[0] as! Int)", "114.22329534", "30.55964711", "1", "30",]
        searchInfo.userName = "15927284689"
//        searchInfo.CSKindID = numbers[1] as! Int
        searchInfo.CSKindID = 0
        
        let VC = ViewController_1()
        VC.searchInfo = searchInfo
        VC.title = numbers[2] as? String
        VC.filterTitle = "全部"
        VC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    func indexToKindID(index: Int) -> [AnyObject]{
        var numbers = [AnyObject]()
        
        if index > 2 && index < 11 {
            numbers.append(2)
            switch index {
            case 3:
                numbers.append(436)
                numbers.append("汽车保养")
            case 4:
                numbers.append(348)
                numbers.append("电脑解码")
            case 5:
                numbers.append(349)
                numbers.append("轮胎轮毂")
            case 6:
                numbers.append(346)
                numbers.append("故障维修")
            case 7:
                numbers.append(350)
                numbers.append("电瓶电路")
            case 8:
                numbers.append(353)
                numbers.append("玻璃换装")
            case 9:
                numbers.append(354)
                numbers.append("空调水箱")
            case 10:
                numbers.append(355)
                numbers.append("钣金油漆")
            default: break
            }
        }
        
        if index > 12 && index < 21 {
            numbers.append(1)
            switch index {
            case 13:
                numbers.append(336)
                numbers.append("车身贴膜")
            case 14:
                numbers.append(338)
                numbers.append("美容养护")
            case 15:
                numbers.append(339)
                numbers.append("音响改装")
            case 16:
                numbers.append(341)
                numbers.append("车窗贴膜")
            case 17:
                numbers.append(343)
                numbers.append("照明改装")
            case 18:
                numbers.append(345)
                numbers.append("空力改装")
            case 19:
                numbers.append(344)
                numbers.append("轮胎轮毂")
            case 20:
                numbers.append(342)
                numbers.append("电子升级")
            default: break
            }
        }
        
        return numbers
    }
    
    func openURL(sender: UIButton) {
        print(sender.tag - 10101)
        let index = sender.tag - 10101
        
        if  index > 2 &&  index < 11 {
            let numbers = indexToKindID(index)
            var searchInfo = SearchInfo()
            
            searchInfo.typeName = "carService"
            searchInfo.userName = "15927284689"
            searchInfo.body = ["\(numbers[0] as! Int)", "114.22329534", "30.55964711", "1", "30",]
            searchInfo.CSKindID = numbers[1] as! Int
            
            let VC = ViewController_1()
            VC.searchInfo = searchInfo
            VC.title = "汽车维修"
            VC.filterTitle = numbers[2] as! String
            VC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(VC, animated: true)
            
        } else if index > 12 && index < 21 {
            let numbers = indexToKindID(index)
            var searchInfo = SearchInfo()
            
            searchInfo.typeName = "carService"
            searchInfo.body = ["\(numbers[0] as! Int)", "114.22329534", "30.55964711", "1", "30",]
            searchInfo.CSKindID = numbers[1] as! Int
            
            let VC = ViewController_1()
            VC.searchInfo = searchInfo
            VC.title = "汽车美容"
            VC.filterTitle = numbers[2] as! String
            VC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(VC, animated: true)
            
        } else {
            let webVC = WebViewController()
            if let url = pModel.getURL(sender.tag - 10101) {
                webVC.url = url
                webVC.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(webVC, animated: true)
            }
        }
        
    }

}

