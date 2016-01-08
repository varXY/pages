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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.lightGrayColor()
        
        pView.getPageForCarServices(self)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

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
        
        return numbers
    }
    
    func openURL(sender: UIButton) {
        print(sender.tag - 10101)
        let index = sender.tag - 10101
        if  index > 2 &&  index < 11 {
            let numbers = indexToKindID(index)
            var searchInfo = SearchInfo()
            
            searchInfo.typeName = "carService"
            searchInfo.body = ["\(numbers[0] as! Int)", "30.12164", "140.121654", "1", "30",]
            searchInfo.CSKindID = numbers[1] as! Int
            
            let VC = ViewController_1()
            VC.searchInfo = searchInfo
            VC.title = "汽车维修"
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

