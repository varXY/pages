//
//  carServiceCell.swift
//  pages
//
//  Created by Bobo on 1/6/16.
//  Copyright © 2016 myname. All rights reserved.
//

import Foundation
import UIKit

protocol CompanySelected: class {
    func companySelected(name: String)
}

class CarServiceCell : UITableViewCell {
    
    
    var picView = UIImageView()
    var titleLabel = UILabel()
    var starLabel = UILabel()
    
    var distanceLabel = UILabel()
    var priceLabel = UILabel()
    var companyLabel = UILabel()
    var locationLabel = UILabel()
    
    weak var delegate: CompanySelected?
    
    var items: [CSResult]?
    
    var downloadTask: NSURLSessionDownloadTask?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.backgroundColor()
        
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
        priceLabel.textColor = UIColor.themeColor()
        priceLabel.textAlignment = .Right
        
        companyLabel.frame = CGRectMake(0, 0, contentView.frame.width - contentView.frame.height - 100, 10)
        companyLabel.textColor = UIColor.lightGrayColor()
        companyLabel.font = UIFont.italicSystemFontOfSize(12)
        
        let companyButton = UIButton(frame: CGRectMake(titleLabel.frame.origin.x, roundPic.frame.origin.y + roundPic.frame.height + 10, contentView.frame.width - contentView.frame.height - 100, 10))
        companyButton.addTarget(self, action: "companySelected:", forControlEvents: .TouchUpInside)
        companyButton.addSubview(companyLabel)
        
        
        locationLabel.frame = CGRectMake(titleLabel.frame.origin.x, companyButton.frame.origin.y + companyButton.frame.height + 10, titleLabel.frame.width, 10)
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
        contentView.addSubview(companyButton)
        contentView.addSubview(locationLabel)
        
        self.contentView.addSubview(contentView)
    }
    
    func configureForCell(result: CSResult) {
        self.items?.append(result)
        
        if let url = NSURL(string: result.thumb) {
            downloadTask = picView.loadImageWithURl(url)
        }
        
        titleLabel.text = result.title
        let star = round(result.star)
        starLabel.text = "服务星级：" + "\(star)" + "星"
        
        distanceLabel.text = "距离" + "\(result.distance)" + "公里"
        
        if let range = result.price.rangeOfString(".00") {
            result.price.removeRange(range)
        }
        priceLabel.text = result.price != "0.01" ? "¥" + result.price : "面议"
        
        companyLabel.text = result.company
        
        locationLabel.text = result.address
    }
    
    func companySelected(button: UIButton) {
        if let label = button.subviews[0] as? UILabel {
            delegate?.companySelected(label.text!)
            //                if item.company == label.text {
            //                    let urlString = String(format: "http://www.cncar.net/jq/carservice-companydetail.html?itemid=%@&name=%@", item.itemid, item.company).URLEncodedString()
            //                    let url = NSURL(string: urlString!)
            //
            //                    delegate?.companySelected(url!)
            //                }
            
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}