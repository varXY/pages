//
//  CarServiceListCell.swift
//  pages
//
//  Created by Bobo on 1/19/16.
//  Copyright © 2016 myname. All rights reserved.
//

import Foundation
import UIKit

class CarServiceListCell: UITableViewCell {
    
    let picView = UIImageView()
    let companyLabel = UILabel()
    let productLabel = UILabel()
    let dateLabel = UILabel()
    let priceLabel = UILabel()
    let noteLabel = UILabel()
    let statusLabel = UILabel()
    
    private let titleFont = UIFont.boldSystemFontOfSize(18)
    private let detailFont = UIFont.systemFontOfSize(15)

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
        
        dateLabel.frame = CGRect(x: productLabel.frame.origin.x, y: productLabel.frame.origin.y + productLabel.frame.height, width: productLabel.frame.width - 100, height: 35)
        dateLabel.text = "时间："
        dateLabel.font = detailFont
        contentView.addSubview(dateLabel)
        
        priceLabel.frame = CGRect(x: contentView.frame.width - 60 - 5, y: dateLabel.frame.origin.y, width: 60, height: 35)
        priceLabel.textColor = UIColor.orangeColor()
        priceLabel.textAlignment = .Right
        priceLabel.text = "¥"
        priceLabel.font = titleFont
        contentView.addSubview(priceLabel)
        
        noteLabel.frame = CGRect(x: dateLabel.frame.origin.x, y: dateLabel.frame.origin.y + dateLabel.frame.height, width: productLabel.frame.width - 100, height: 35)
        noteLabel.text = "备注："
        noteLabel.font = detailFont
        contentView.addSubview(noteLabel)
        
        statusLabel.frame = CGRect(x: contentView.frame.width - 100 - 5, y: noteLabel.frame.origin.y, width: 100, height: 35)
        statusLabel.font = titleFont
        statusLabel.textAlignment = .Right
        statusLabel.text = ""
        contentView.addSubview(statusLabel)
        
        let buttonsView = buttonsOfStatus(1)
        contentView.addSubview(buttonsView)
        
    }
    
    func buttonsOfStatus(status: Int) -> UIView {
        let contentView = UIView(frame: CGRect(x: 0, y: 145, width: self.contentView.frame.width, height: 55))
        
        let titles = status == 0 ? ["关闭订单", "查看评论"] : ["申请取消", "订单完成", "查看评论"]
        let buttonSize = CGSize(width: 100, height: 35)
        
        for i in 0..<titles.count {
            let x = (contentView.frame.width - 20) - (buttonSize.width * CGFloat(i)) - (10 * CGFloat(i))

            let button = UIButton(type: .System)
            button.frame = CGRect(x: x, y: 10, width: buttonSize.width, height: buttonSize.height)
            button.setTitle(titles[i], forState: .Normal)
            button.tintColor = UIColor.themeColor()
            button.layer.cornerRadius = 8
            button.layer.borderWidth = 0.5
            button.layer.borderColor = UIColor.grayColor().CGColor
            contentView.addSubview(button)
            
        }
        
        
        return contentView
    }
    
    func configureForCell() {
        companyLabel.text! += "汽车美容公司"
        picView.image = UIImage(named: "product4")
        productLabel.text! += "洗车"
        dateLabel.text! += "\(NSDate())"
        priceLabel.text! += "100"
        noteLabel.text! += "ddddfweeeeeeeeeeeeeegwaadaaaaaaaaaa"
        statusLabel.text! += "用户已关闭"
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}








