//
//  SubscribeView.swift
//  pages
//
//  Created by Bobo on 1/15/16.
//  Copyright © 2016 myname. All rights reserved.
//

import Foundation
import UIKit

protocol SubscribeViewDelegate: class {
    
}


class SubscribeView: UIView {
    
    var companyName: String?
    var serviceType: String?
    
    var detailLabels: [UILabel]?
    
    weak var delegate: SubscribeViewDelegate?
    
    init(frame: CGRect, info: [String]) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.backgroundColor()
        
        setupSubviews()
        
        if info.count == 2 && detailLabels?.count == 2 {
            for i in 0..<2 {
                detailLabels![i].text = info[i]
            }
        }
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        let discribleLabel_titles = ["商户名称：", "服务名称：", "服务时间：", "服务备注："]
        let discribleLabel_width = (self.frame.width - 20) / 4
        
        let detailLabel_x = discribleLabel_width + 10
        let detailLabel_width = self.frame.width - 20 - 10 - discribleLabel_width
        
        let height: CGFloat = 50
        
        let contentView = UIView(frame: CGRectMake(10, 10, self.frame.width - 20 , height * 4))
        contentView.backgroundColor = UIColor.whiteColor()
        self.addSubview(contentView)
        
        for i in 0..<4 {
            let discribleLabel_y = height * CGFloat(i)
            let discribleLabel = UILabel(frame: CGRectMake(0, discribleLabel_y, discribleLabel_width, height))
            discribleLabel.text = discribleLabel_titles[i]
            contentView.addSubview(discribleLabel)
        }
        
        for i in 0..<2 {
            let detailLabel_y = height * CGFloat(i)
            let detailLabel = UILabel(frame: CGRectMake(detailLabel_x, detailLabel_y, detailLabel_width, height))
            detailLabels?.append(detailLabel)
            contentView.addSubview(detailLabel)
            
        }
        
        let timeButton = UIButton(frame: CGRectMake(detailLabel_x, height * 2, detailLabel_width, height))
        timeButton.addTarget(self, action: "selectTime:", forControlEvents: .TouchUpInside)
        contentView.addSubview(timeButton)
        
        let timeLabel = UILabel(frame: timeButton.bounds)
        timeButton.addSubview(timeLabel)
    }
    
    func selectTime(button: UIButton) {
        button.enabled = false
        
        let pickerView = UIDatePicker(frame: CGRectMake(0, self.frame.height - 250, self.frame.width, 250))
        pickerView.tag = 110
        self.addSubview(pickerView)
    }
    

}