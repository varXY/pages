//
//  carServiceCell.swift
//  pages
//
//  Created by Bobo on 1/6/16.
//  Copyright © 2016 myname. All rights reserved.
//

import Foundation
import UIKit

class CarServiceCell: UITableViewCell {
    
    
    var picView = UIImageView()
    var titleLabel = UILabel()
    var starLabel = UILabel()
    
    var distanceLabel = UILabel()
    var priceLabel = UILabel()
    var companyLabel = UILabel()
    var locationLabel = UILabel()
    
    var downloadTask: NSURLSessionDownloadTask?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.lightGrayColor()
        
        let contentView = UIView(frame: CGRectMake(0, 5, UIScreen.mainScreen().bounds.width, 120))
        contentView.backgroundColor = UIColor.whiteColor()
        
        picView.frame = CGRect(x: 5, y: 5, width: 110, height: 110)
        picView.contentMode = .ScaleAspectFill
        picView.clipsToBounds = true
        
        titleLabel.frame = CGRect(x: 15 + picView.frame.width, y: 5, width: contentView.frame.width - 15 - picView.frame.width, height: 35)
        
        starLabel.frame = CGRect(x: titleLabel.frame.origin.x, y: titleLabel.frame.height, width: titleLabel.frame.width, height: 15)
        starLabel.textColor = UIColor.lightGrayColor()
        starLabel.font = UIFont.italicSystemFontOfSize(12)
        
        let roundPic = UIImageView(image: UIImage(named: "距离"))
        roundPic.frame = CGRectMake(titleLabel.frame.origin.x, 5 + starLabel.frame.origin.y + starLabel.frame.height, 20, 20)
        
        distanceLabel.frame = CGRectMake(roundPic.frame.origin.x + 25, roundPic.frame.origin.y + 5, 180, 10)
        distanceLabel.textColor = UIColor.lightGrayColor()
        distanceLabel.font = UIFont.italicSystemFontOfSize(12)
        
        priceLabel.frame = CGRectMake(contentView.frame.width - 110, roundPic.frame.origin.y - 5, 100, 30)
        priceLabel.textColor = UIColor.orangeColor()
        priceLabel.textAlignment = .Right
        
        companyLabel.frame = CGRectMake(titleLabel.frame.origin.x, roundPic.frame.origin.y + roundPic.frame.height + 10, contentView.frame.width - contentView.frame.height - 110, 10)
        companyLabel.textColor = UIColor.lightGrayColor()
        companyLabel.font = UIFont.italicSystemFontOfSize(12)
        
        locationLabel.frame = CGRectMake(titleLabel.frame.origin.x, companyLabel.frame.origin.y + companyLabel.frame.height + 10, titleLabel.frame.width, 10)
        locationLabel.textColor = UIColor.lightGrayColor()
        locationLabel.font = UIFont.italicSystemFontOfSize(12)
        
//        self.addSubview(picView)
//        self.addSubview(titleLabel)
//        self.addSubview(starLabel)
//        self.addSubview(roundPic)
//        self.addSubview(distanceLabel)
//        self.addSubview(priceLabel)
//        self.addSubview(companyLabel)
//        self.addSubview(locationLabel)
        
        contentView.addSubview(picView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(starLabel)
        contentView.addSubview(roundPic)
        contentView.addSubview(distanceLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(companyLabel)
        contentView.addSubview(locationLabel)
        
        self.contentView.addSubview(contentView)
    }
    
    func configureForCell(result: CSResult) {
        let url = NSURL(string: result.thumb)
        downloadTask = picView.loadImageWithURl(url!)
        
        titleLabel.text = result.title
        let star = round(result.star)
        starLabel.text = "服务星级：" + "\(star)" + "星"
        
        distanceLabel.text = "距离" + "\(result.distance)" + "公里"
        
        if let range = result.price.rangeOfString(".00") {
            result.price.removeRange(range)
        }
        priceLabel.text = "¥" + result.price
        
        companyLabel.text = result.company
        
        locationLabel.text = result.address
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}