//
//  FilterView.swift
//  pages
//
//  Created by Bobo on 1/7/16.
//  Copyright © 2016 myname. All rights reserved.
//

import Foundation
import UIKit

typealias filterBigButtonTapped = (UIButton) -> Void

class FilterView: UIView {
    
    var title: String?
    
    var sender: filterBigButtonTapped?
    
    let type_titles_0 = ["全部", "故障维修", "底盘养护", "电脑解码", "轮胎轮毂", "电瓶电路", "发动机", "变速箱", "玻璃换装", "空调水箱", "钣金油漆", "汽车保养"]
    let type_titles_1 = ["全部", "车身贴膜", "内饰改装", "美容养护", "音响改装", "外饰加装", "车窗贴膜", "电子升级", "照明改装", "轮毂改装", "空力改装"]
    let type_titles_2 = ["全部", "加油服务", "车务代办", "车辆租凭", "车辆救援", "车辆保险", "车辆代驾"]
    
    let price_titles = ["价格不限", "500元以下", "500-1000元", "1000-1500元", "1500-3000元", "自定义"]
    let distance_titles = ["距离不限", "1公里以内", "5公里以内", "10公里以内", "20公里以内", "自定义"]
    let order_titles = ["默认排序", "价格升序", "价格降序", "距离升序", "距离降序"]
    
    
    var selectedTitles = [String]()
    
    var subButtons_0 = UIView()
    
    init(title: String, type: String) {
        super.init(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 40))
        
        self.title = title
        self.backgroundColor = UIColor.whiteColor()
        
        addButtons(title)
        
        if title != "全部" {
            for titles in [type_titles_0, type_titles_1, type_titles_2] {
                if let _ = titles.indexOf(title) {
                    self.selectedTitles = titles
                }
            }
        } else {
            switch type {
            case "1": self.selectedTitles = type_titles_1
            case "2": self.selectedTitles = type_titles_0
            case "3": self.selectedTitles = type_titles_2
            default: break
            }
        }
        

    }
    
    func addButtons(title: String) {
        
        let width_0 = self.frame.width * 0.35
        let width_1 = (self.frame.width - width_0) / 3
        
        let button_0 = UIButton(type: .System)
        button_0.frame = CGRectMake(0, 0, width_0, 40)
        button_0.setTitle(title, forState: .Normal)
        button_0.tag = 200
        self.addSubview(button_0)

        let titles = ["价格", "距离", "排序"]

        for i in 0..<3 {
            let rect = CGRectMake(width_0 + width_1 * CGFloat(i), 0, width_1, 40)
            let button = UIButton(type: .System)
            button.frame = rect
            button.setTitle(titles[i], forState: .Normal)
            button.tag = 201 + i
            self.addSubview(button)
        }
        
        for button in self.subviews {
            let imageView = UIImageView(image: UIImage(named: "下拉"))
            imageView.frame = CGRectMake(button.frame.width - 15, 17.5, 8, 5)
            button.tintColor = UIColor.blackColor()
            button.layer.borderWidth = 0.5
            button.layer.borderColor = UIColor.lightGrayColor().CGColor
            
            if let btn = button as? UIButton {
                btn.addTarget(self, action: #selector(FilterView.topButtonTapped(_:)), forControlEvents: .TouchUpInside)
            }
            
            button.addSubview(imageView)
        }
        
        
    }
    
    func topButtonTapped(sender: UIButton) {
        
        self.sender!(sender)
        
        if let imageView = sender.subviews[0] as? UIImageView {
            
            if imageView.image == UIImage(named: "下拉") {
                imageView.image = UIImage(named: "收起")
                
                for view in self.subviews {
                    if let btn = view as? UIButton {
                        if btn != sender {
                            FilterView.changeButtonsImage(btn)
                        }
                    }
                }
                
            } else {
                imageView.image = UIImage(named: "下拉")
                
                for view in self.subviews {
                    if let btn = view as? UIButton {
                        if btn != sender {
                            FilterView.changeButtonsImage(btn)
                        }
                    }
                }

            }
        
        }
    }
    
    class func changeButtonsImage(sender: UIButton) {
        if let imageView = sender.subviews[0] as? UIImageView {
            
            if imageView.image == UIImage(named: "收起") {
                imageView.image = UIImage(named: "下拉")
            }
            
        }
    }
    
    func ButtonsView_0(viewController: ViewController_1) -> UIView {
        let contentView = UIView(frame: CGRectMake(0, 40, self.frame.width, 170))
        contentView.backgroundColor = UIColor.whiteColor()
        contentView.alpha = 0.95
        
        var factor: CGFloat = 0
        var y: CGFloat = 0
        let width = (self.frame.width - 20) / 4
        let height: CGFloat = 50
        
        for i in 0..<selectedTitles.count {
            
            if i <= 3 { factor = CGFloat(i); y = 10 }
            if i >= 4 && i <= 7 { factor = CGFloat(i) - 4; y = 60 }
            if i >= 8 && i <= 11 { factor = CGFloat(i) - 8; y = 110 }
                        
            let button = UIButton(type: .System)
            button.frame = CGRectMake(10 + width * factor, y, width, height)
            button.setTitle(selectedTitles[i], forState: .Normal)
            button.tintColor = UIColor.blackColor()
            button.layer.borderWidth = 0.5
            button.layer.borderColor = UIColor.lightGrayColor().CGColor
            button.tag = 210 + i
			button.addTarget(viewController, action: #selector(ViewController_1.smallFilterTapped(_:)), forControlEvents: .TouchUpInside)
            contentView.addSubview(button)
        
        }
        
        for view in contentView.subviews {
            if let button = view as? UIButton {
                if button.titleLabel?.text == viewController.filterTitle {
                    button.layer.borderColor = UIColor.orangeColor().CGColor
                    
                    let imageView = UIImageView(frame: CGRectMake(button.frame.width - 9, button.frame.height - 12, 9, 12))
                    imageView.image = UIImage(named: "选中")
                    button.addSubview(imageView)
                }
            }
        }
        
        return contentView
    }
    
    func buttonsView_123(index: Int, viewController: UIViewController) -> UIView {
        
        var titles = [String]()
        let factor = 220 + (10 * index)
        
        switch index {
        case 1: titles = price_titles
        case 2: titles = distance_titles
        case 3: titles = order_titles
        default: break
        }
        
        let contentView = UIView(frame: CGRectMake(0, 40, self.frame.width, 20 + CGFloat(titles.count * 50)))
        contentView.backgroundColor = UIColor.whiteColor()
        contentView.alpha = 0.95
        
        
        for i in 0..<titles.count {
            let button = UIButton(type: .System)
            button.frame = CGRectMake(0, 10 + 50 * CGFloat(i), contentView.frame.width, 50)
            button.setTitle(titles[i], forState: .Normal)
            button.tintColor = UIColor.blackColor()
            button.tag = factor + i
            button.addTarget(viewController, action: #selector(ViewController_1.smallFilterTapped(_:)), forControlEvents: .TouchUpInside)
            contentView.addSubview(button)

        }
        
        for view in contentView.subviews {
            if let button = view as? UIButton {
                if button.titleLabel?.text == self.title {
                    button.tintColor = UIColor.orangeColor()
                    button.backgroundColor = UIColor.lightGrayColor()
                }
            }
        }
        
        return contentView
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}