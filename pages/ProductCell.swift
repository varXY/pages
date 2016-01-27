//
//  carServiceCell.swift
//  pages
//
//  Created by Bobo on 1/6/16.
//  Copyright © 2016 myname. All rights reserved.
//

import Foundation
import UIKit

class ProductCell : UITableViewCell {
    
    
    var picView = UIImageView()
    var titleLabel = UILabel()
    var starLabel = UILabel()
    
    var brandLabel = UILabel()
    var priceLabel = UILabel()
    var companyLabel = UILabel()
    var locationLabel = UILabel()
    
    weak var delegate: CompanySelected?
    
    var downloadTask: NSURLSessionDownloadTask?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.backgroundColor()
        
        let contentView = UIView(frame: CGRectMake(0, 5, UIScreen.mainScreen().bounds.width, 130))
        contentView.backgroundColor = UIColor.whiteColor()
        
        picView.frame = CGRect(x: 5, y: 5, width: 110, height: 110)
        picView.contentMode = .ScaleAspectFill
        picView.clipsToBounds = true
        
        titleLabel.frame = CGRect(x: 15 + picView.frame.width, y: 5, width: contentView.frame.width - 15 - picView.frame.width, height: 35)
        
        starLabel.frame = CGRect(x: titleLabel.frame.origin.x, y: titleLabel.frame.height, width: titleLabel.frame.width - 100, height: 15)
        starLabel.textColor = UIColor.lightGrayColor()
        starLabel.font = UIFont.italicSystemFontOfSize(12)
        
        brandLabel.frame = CGRectMake(titleLabel.frame.origin.x, titleLabel.frame.height + starLabel.frame.height + 10, 180, 15)
        brandLabel.textColor = UIColor.lightGrayColor()
        brandLabel.font = UIFont.italicSystemFontOfSize(13)
        
        priceLabel.frame = CGRectMake(contentView.frame.width - 110, starLabel.frame.origin.y, 100, 30)
        priceLabel.textColor = UIColor.themeColor()
        priceLabel.textAlignment = .Right
        
        companyLabel.frame = CGRectMake(titleLabel.frame.origin.x, brandLabel.frame.origin.y + brandLabel.frame.height + 10, titleLabel.frame.width - 100, 10)
        companyLabel.textColor = UIColor.lightGrayColor()
        companyLabel.font = UIFont.italicSystemFontOfSize(12)
        

        
//        let companyButton = UIButton(frame: CGRectMake(titleLabel.frame.origin.x, roundPic.frame.origin.y + roundPic.frame.height + 10, contentView.frame.width - contentView.frame.height - 100, 10))
//        //        companyButton.addTarget(self, action: "companySelected:", forControlEvents: .TouchUpInside)
//        companyButton.addSubview(companyLabel)
        
        
        locationLabel.frame = CGRectMake(titleLabel.frame.origin.x, companyLabel.frame.origin.y + companyLabel.frame.height + 20, titleLabel.frame.width, 10)
        locationLabel.textColor = UIColor.lightGrayColor()
        locationLabel.font = UIFont.italicSystemFontOfSize(12)
        
        
        contentView.addSubview(picView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(starLabel)
        contentView.addSubview(brandLabel)
        contentView.addSubview(companyLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(locationLabel)
        
        self.contentView.addSubview(contentView)
    }
    
    func configureForCell(result: Product) {
        
        if let url = NSURL(string: result.thumb) {
            picView.loadImageWithURl(url)
        }
        
        titleLabel.text = result.title
        let star = round(result.star)
        starLabel.text = "综合评分：" + "\(star)" + "星"
        
        brandLabel.text = result.brand
        
        if let range = result.price.rangeOfString(".00") {
            result.price.removeRange(range)
        }
        priceLabel.text = result.price == "0.01" || result.price == "0" ? "面议" : "¥" + result.price
        
        companyLabel.text = result.company
        companyLabel.sizeToFit()
        
        let roundPic = UIImageView(image: UIImage(named: "companyicon"))
        roundPic.frame = CGRectMake(companyLabel.frame.origin.x + companyLabel.frame.width + 5, companyLabel.frame.origin.y, 20, 20)
        self.contentView.addSubview(roundPic)
        
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