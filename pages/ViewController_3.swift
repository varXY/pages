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
    
    func openURL(sender: UIButton) {
        print(sender.tag)
    }
}