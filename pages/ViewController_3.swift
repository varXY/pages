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
        
        self.title = "行业资讯"
        self.view.backgroundColor = UIColor.lightGrayColor()
        
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
    
    func openURL(sender: UIButton) {
        print(sender.tag)
        
        let kindID = kindIDForButtonIndex(sender.tag)
        
        var searchInfo = SearchInfo()
        searchInfo.typeName = "products"
        searchInfo.productKindID = String(kindID)
        
        let VC_3_1 = ViewController_3_1()
        VC_3_1.searchInfo = searchInfo
        
        self.navigationController?.pushViewController(VC_3_1, animated: true)
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
        default:
            return 0
        }
    }
}