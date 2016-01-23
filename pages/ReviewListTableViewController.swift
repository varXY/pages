//
//  ReviewListTableViewController.swift
//  pages
//
//  Created by Bobo on 1/21/16.
//  Copyright © 2016 myname. All rights reserved.
//

import Foundation
import UIKit

class ReviewListTableViewController: UITableViewController {
    
    var reviews = [Review]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "评论"
        
        let quitButton = UIBarButtonItem(image: UIImage(named: "back"), style: .Plain, target: self, action: "quit")
        self.navigationItem.leftBarButtonItem = quitButton
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setToolbarHidden(true, animated: true)
    }
    
    func quit() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func getCommentLabelHeight(review: Review) -> CGFloat {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width - 10, height: 100))
        label.numberOfLines = 0
        label.text = review.seller_comment
        label.sizeToFit()
        
        return label.frame.height
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count == 0 ? 1 : reviews.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 200 + getCommentLabelHeight(reviews[indexPath.row]) - 30
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if reviews.count != 0 {
            let cell = CommentCell(style: .Default, reuseIdentifier: "cell")
            return cell
        } else {
            let cell = UITableViewCell(style: .Default, reuseIdentifier: "cell")
            cell.frame = CGRectMake(0, 0, self.tableView.frame.width, 200)
            cell.textLabel?.text = "无结果"
            cell.textLabel?.textAlignment = .Center
            tableView.userInteractionEnabled = true
            return cell
        }
        
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if let commentCell = cell as? CommentCell {
            let height = getCommentLabelHeight(reviews[indexPath.row])
            commentCell.configureForCell(reviews[indexPath.row], heightForCommentLabel: height)
        }
    }
}