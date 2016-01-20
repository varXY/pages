//
//  CarServiceListCell.swift
//  pages
//
//  Created by Bobo on 1/19/16.
//  Copyright © 2016 myname. All rights reserved.
//

import Foundation
import UIKit

protocol ActionEvent: class {
    func actionSended(itemID: String, buttonTitle: String)
}

class CarServiceListCell: UITableViewCell {
    
    let picView = UIImageView()
    let companyLabel = UILabel()
    let productLabel = UILabel()
    let dateLabel = UILabel()
    let priceLabel = UILabel()
    let noteLabel = UILabel()
    let statusLabel = UILabel()
    
    var itemID = ""
    
    weak var delegate: ActionEvent?
    
    private let titleFont = UIFont.boldSystemFontOfSize(18)
    private let detailFont = UIFont.systemFontOfSize(15)
    private let statusFont = UIFont.italicSystemFontOfSize(14)

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor.backgroundColor()
        
        let contentView = UIView(frame: CGRectMake(0, 5, UIScreen.mainScreen().bounds.width, 195))
        contentView.backgroundColor = UIColor.whiteColor()
        self.contentView.addSubview(contentView)
        
        companyLabel.frame = CGRect(x: 5, y: 5, width: contentView.frame.width - 10, height: 40)
        companyLabel.text = "预约商户："
        companyLabel.font = titleFont
        contentView.addSubview(companyLabel)
        
        let imageViewSize = CGSize(width: (contentView.frame.width - 10) / 3, height: 105)
        picView.frame = CGRect(x: 5, y: companyLabel.frame.origin.y + companyLabel.frame.height, width: imageViewSize.width, height: imageViewSize.height)
        picView.backgroundColor = UIColor.backgroundColor()
        contentView.addSubview(picView)
        
        productLabel.frame = CGRect(x: 5 + imageViewSize.width + 5, y: picView.frame.origin.y, width: imageViewSize.width * 2 - 5 , height: 35)
        productLabel.text = "项目："
        productLabel.font = detailFont
        contentView.addSubview(productLabel)
        
        dateLabel.frame = CGRect(x: productLabel.frame.origin.x, y: productLabel.frame.origin.y + productLabel.frame.height, width: productLabel.frame.width - 65, height: 35)
        dateLabel.text = "时间："
        dateLabel.textColor = UIColor.lightGrayColor()
        dateLabel.adjustsFontSizeToFitWidth = true
        dateLabel.font = detailFont
        contentView.addSubview(dateLabel)
        
        priceLabel.frame = CGRect(x: contentView.frame.width - 60 - 5, y: dateLabel.frame.origin.y, width: 60, height: 35)
        priceLabel.textColor = UIColor.orangeColor()
        priceLabel.textAlignment = .Right
        priceLabel.text = ""
        priceLabel.adjustsFontSizeToFitWidth = true
        priceLabel.font = titleFont
        contentView.addSubview(priceLabel)
        
        noteLabel.frame = CGRect(x: dateLabel.frame.origin.x, y: dateLabel.frame.origin.y + dateLabel.frame.height, width: productLabel.frame.width - 100, height: 35)
        noteLabel.text = "备注："
        noteLabel.font = detailFont
        contentView.addSubview(noteLabel)
        
        statusLabel.frame = CGRect(x: contentView.frame.width - 100 - 5, y: noteLabel.frame.origin.y, width: 100, height: 35)
        statusLabel.font = statusFont
        statusLabel.textAlignment = .Right
        statusLabel.adjustsFontSizeToFitWidth = true
        statusLabel.text = ""
        statusLabel.textColor = UIColor.lightGrayColor()
        contentView.addSubview(statusLabel)
        
        
    }
    
    func buttonsOfStatus(status: String) -> UIView {
        let contentView = UIView(frame: CGRect(x: 0, y: 145, width: self.contentView.frame.width, height: 55))
        var titles = [String]()
        
        switch status {
        case "0": titles = ["关闭"]
        case "1": titles = ["完成", "申请取消"]
        case "2": titles = ["删除", "评价"]
        case "3": titles = [""]
        case "4": titles = ["删除"]
        case "5": titles = ["删除"]
        case "6": titles = ["删除"]
        default: break
        }
        
        let buttonSize = CGSize(width: (contentView.frame.width - 20) / 4, height: 35)
        
        for i in 0..<titles.count {
            let x = (contentView.frame.width - 10) - (buttonSize.width * CGFloat(i + 1)) - (10 * CGFloat(i))

            let button = UIButton(type: .System)
            button.frame = CGRect(x: x, y: 10, width: buttonSize.width, height: buttonSize.height)
            button.setTitle(titles[i], forState: .Normal)
            button.tintColor = UIColor.themeColor()
            button.layer.cornerRadius = 8
            button.layer.borderWidth = 0.5
            button.tag = 1000 + i
            button.addTarget(self, action: "actionButtonTapped:", forControlEvents: .TouchUpInside)
            button.layer.borderColor = UIColor.grayColor().CGColor
            contentView.addSubview(button)
            
        }
        
        
        return contentView
    }
    
    func actionButtonTapped(sender: UIButton) {
        self.delegate?.actionSended(self.itemID, buttonTitle: (sender.titleLabel?.text)!)
    }
    
    func configureForCell(item: ApplyItem) {
        
        self.itemID = item.itemid
        
        companyLabel.text! += item.company
        picView.loadImageWithURl(NSURL(string: item.thumb)!)
        productLabel.text! += item.title
        dateLabel.text! += item.servertime
        priceLabel.text = item.price == "0.01" ? "面议" : "¥\(item.price)"
        
        if item.note == "" {
            noteLabel.text! += "无"
        } else {
            noteLabel.text! += item.note
        }
        
        switch item.status {
        case "0": statusLabel.text! += "等待商家确认"
        case "1": statusLabel.text! += "商家已确认"
        case "2": statusLabel.text! += "服务已完成"
        case "3": statusLabel.text! += "已申请取消"
        case "4": statusLabel.text! += "已取消"
        case "5": statusLabel.text! += "预约者关闭"
        case "6": statusLabel.text! += "商家关闭"
        default: break
        }
        
        let buttons = buttonsOfStatus(item.status)
        self.contentView.addSubview(buttons)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}








