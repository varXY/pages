//
//  CommentCell.swift
//  pages
//
//  Created by Bobo on 1/21/16.
//  Copyright © 2016 myname. All rights reserved.
//

import Foundation
import UIKit

class CommentCell: UITableViewCell {
    
    let userLabel = UILabel()
    let starLabel_0 = UILabel()
    let starLabel_1 = UILabel()
    let starLabel_2 = UILabel()
    let commentLabel = UILabel()
    
    var top5Labels = [UILabel]()
    
    let dateLabel = UILabel()
    
    private let stars = ["⭐️", "⭐️⭐️", "⭐️⭐️⭐️", "⭐️⭐️⭐️⭐️", "⭐️⭐️⭐️⭐️⭐️"]
    private let stringStars = ["1", "2", "3", "4", "5"]
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let commonSize = CGSize(width: self.frame.width - 10, height: 30)
        
        let contentView = UIView(frame: CGRect(x: 0, y: 5, width: UIScreen.mainScreen().bounds.width, height: 195))
        contentView.backgroundColor = UIColor.whiteColor()
        self.contentView.addSubview(contentView)
        
        for i in 0..<5 {
            let origin = CGPoint(x: 5, y: 30 * CGFloat(i))
            
            let label = UILabel(frame: CGRect(origin: origin, size: commonSize))
            label.textColor = UIColor.lightGrayColor()
            top5Labels.append(label)
            contentView.addSubview(label)
            
        }
        
        contentView.addSubview(dateLabel)
        
    }
    
    func configureForCell(review: Review, heightForCommentLabel: CGFloat) {
        top5Labels[0].text = review.isAnonymous == "0" ? review.buyer : "匿名用户"
        top5Labels[1].text = "服务与描述相符：\(stringToStars(review.seller_star))"
        top5Labels[2].text = "服务质量评分：\(stringToStars(review.seller_qstar))"
        top5Labels[3].text = "服务态度评分：\(stringToStars(review.seller_astar))"
        
        top5Labels[4].frame.size.height = heightForCommentLabel
        top5Labels[4].numberOfLines = 0
        top5Labels[4].textColor = UIColor.blackColor()
        top5Labels[4].text = review.seller_comment
        
        
        dateLabel.frame = CGRect(x: 0, y: top5Labels[4].frame.origin.y + heightForCommentLabel, width: self.contentView.frame.width, height: 30)
        dateLabel.text = review.seller_ctime
        dateLabel.textColor = UIColor.lightGrayColor()
        
    }
    
    func stringToStars(string: String) -> String {
        if let index = stringStars.indexOf(string) {
            return stars[index]
        } else {
            return ""
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}