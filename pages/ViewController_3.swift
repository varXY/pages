//
//  ViewController_1_3.swift
//  pages
//
//  Created by Bobo on 1/16/16.
//  Copyright © 2016 myname. All rights reserved.
//

import Foundation
import UIKit

class ViewController_3: UIViewController {
    
    let customView = PView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "产品资讯"
        self.view.backgroundColor = UIColor.backgroundColor()
        
        let quitButton = UIBarButtonItem(image: UIImage(named: "back"), style: .Plain, target: self, action: "quit")
        self.navigationItem.leftBarButtonItem = quitButton
        
        customView.getPageForCSNews(self)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setToolbarHidden(true, animated: true)
    }
    
//    0—全部
//    10—外饰件
//    1—内饰件
//    230---电子类
//    39---改装类
//    13---护理类
    
    func quit() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func openURL(sender: UIButton) {
        print(sender.tag)
        
        let kindID = kindIDForButtonIndex(sender.tag)
        
        var searchInfo = SearchInfo()
        searchInfo.typeName = "products"
        searchInfo.body = ["1", "1", "1", "1"]
        searchInfo.productKindID = String(kindID)
        
        let VC_3_1 = ViewController_3_1()
        VC_3_1.searchInfo = searchInfo
        VC_3_1.title = titleForButtonIndex(sender.tag)
        
        self.navigationController?.pushViewController(VC_3_1, animated: true)
    }
    
    func titleForButtonIndex(index: Int) -> String {
        switch index {
        case 10104:
            return "保养件"
        case 10105:
            return "维修件"
        case 10106:
            return "外饰件"
        case 10107:
            return "内饰件"
        case 10108:
            return "电子类"
        case 10109:
            return "户外类"
        case 10110:
            return "改装类"
        case 10111:
            return "内饰件"
        default:
            return "产品详情"
        }
    }
    
    
    func kindIDForButtonIndex(index: Int) -> Int {
        switch index {
        case 10106:
            return 10
        case 10107:
            return 1
        case 10108:
            return 230
        case 10110:
            return 39
        case 10111:
            return 13
        default:
            return 0
        }
    }
}