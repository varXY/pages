//
//  SubscribeTableView.swift
//  pages
//
//  Created by Bobo on 1/15/16.
//  Copyright © 2016 myname. All rights reserved.
//

import Foundation
import UIKit

class SubscribeTableView: UITableView {
    
    var info: [String]!
    
    var datePickerVisble = false
    var dueDate = NSDate()
    var imputting = false
    
    private let discribe_titles = ["商户名称：", "服务名称：", "服务时间：", "服务备注："]
    
    init(frame: CGRect, info: [String]) {
        super.init(frame: frame, style: .Grouped)
        self.dataSource = self
        self.delegate = self
        
        self.info = info
        self.info.append("请选择")
        self.info.append("请输入")
        
        let doneButton = UIButton(frame: CGRect(x: 10, y: 0, width: self.frame.width - 20, height: 50))
        doneButton.backgroundColor = UIColor.themeColor()
        doneButton.layer.cornerRadius = 10
        doneButton.setTitle("确定", forState: .Normal)
        doneButton.addTarget(self, action: "done", forControlEvents: .TouchUpInside)
        
        let contentView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 50))
        contentView.addSubview(doneButton)
        self.tableFooterView = contentView
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showDatePicker() {
        datePickerVisble = true
        
        let indexPathDateRow = NSIndexPath(forRow: 2, inSection: 0)
        let indexPathDatePicker = NSIndexPath(forRow: 3, inSection: 0)
        
//        let indexPathCommentRow = NSIndexPath(forRow: 3, inSection: 0)
//        
//        if let commentRow = self.cellForRowAtIndexPath(indexPathCommentRow) {
//            let x = (commentRow.textLabel?.frame.width)! + (commentRow.textLabel?.frame.origin.x)!
//            let textField = UITextField(frame: CGRect(x: x, y: 5, width: self.frame.width - x, height: 40))
//            commentRow.addSubview(textField)
//            textField.becomeFirstResponder()
//        }
    
        self.insertRowsAtIndexPaths([indexPathDatePicker], withRowAnimation: .Fade)
        
        if let dateCell = self.cellForRowAtIndexPath(indexPathDateRow) {
            dateCell.detailTextLabel?.text = dateToText(dueDate)
//            let label = UILabel(frame: CGRect(x: self.frame.width / 2 - 85, y: 5, width: 170, height: 34))
//            label.text = dateToText(dueDate)
//            label.tag = 99
//            dateCell.contentView.addSubview(label)
        }
        
        if let datePickerCell = self.cellForRowAtIndexPath(indexPathDatePicker) {
            datePickerCell.textLabel?.text = nil
            datePickerCell.detailTextLabel?.text = nil
            let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: 320, height: 216))
            datePicker.tag = 100
            datePicker.date = dueDate
            datePicker.addTarget(self, action: Selector("dateChanged:"), forControlEvents: .ValueChanged)
            datePickerCell.contentView.addSubview(datePicker)
        }
    }
    
    func hideDatePicker() {
        if datePickerVisble {
            datePickerVisble = false
            
//            let indexPathDateRow = NSIndexPath(forRow: 2, inSection: 0)
            let indexPathDatePicker = NSIndexPath(forRow: 3, inSection: 0)
            
//            if let dateCell = self.cellForRowAtIndexPath(indexPathDateRow) {
//                dateCell.contentView.viewWithTag(99)?.removeFromSuperview()
//                dateCell.detailTextLabel?.text = dateToText(dueDate)
//            }
            
            if let datePickerCell = self.cellForRowAtIndexPath(indexPathDatePicker) {
                datePickerCell.contentView.viewWithTag(100)?.removeFromSuperview()
            }
            
            self.deleteRowsAtIndexPaths([indexPathDatePicker], withRowAnimation: .Fade)
        }
    }
    
    func dateChanged(datePicker: UIDatePicker) {
        dueDate = datePicker.date
        
        let indexPathDateRow = NSIndexPath(forRow: 2, inSection: 0)
        
        if let dateCell = self.cellForRowAtIndexPath(indexPathDateRow) {
            dateCell.detailTextLabel!.text = self.dateToText(datePicker.date)
            dueDate = datePicker.date
        }
    }
    
    func dateToText(date: NSDate) -> String {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .ShortStyle
        formatter.timeStyle = .ShortStyle
        return formatter.stringFromDate(date)
    }
    
    func done() {
        
    }
    
    func startInput() {
        imputting = true
        let indexPathCommentRow = NSIndexPath(forRow: 3, inSection: 0)
        
        if let commentRow = self.cellForRowAtIndexPath(indexPathCommentRow) {
            commentRow.detailTextLabel?.text = nil
            
            let x = (commentRow.textLabel?.frame.width)! + (commentRow.textLabel?.frame.origin.x)!
            let textField = UITextField(frame: CGRect(x: x, y: 5, width: self.frame.width - x - 10, height: 40))
            commentRow.addSubview(textField)
            textField.textAlignment = .Right
            textField.tag = 101
            textField.delegate = self
            textField.becomeFirstResponder()
        }
    }
    
    func quitInput() {
        if imputting == true {
            imputting = false
            
            let indexPathCommentRow = NSIndexPath(forRow: 3, inSection: 0)
            
            if let commentRow = self.cellForRowAtIndexPath(indexPathCommentRow) {
                if let textField = commentRow.viewWithTag(101) as? UITextField {
                    
                    if textField.text == "" {
                        commentRow.detailTextLabel?.text = "请输入"
                    }
                    
                    textField.resignFirstResponder()
//                    textField.removeFromSuperview()
                }
            }
        }
        
    }
}

extension SubscribeTableView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if datePickerVisble {
            return 5
        } else {
            return 4
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if datePickerVisble && indexPath.row == 3 {
            return 217
        } else {
            return 50
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Value1, reuseIdentifier: "cell")
        cell.tintColor = UIColor.themeColor()
        cell.textLabel?.text = discribe_titles[indexPath.row]
        cell.detailTextLabel?.text = info[indexPath.row]
        
        if indexPath.row == 2 {
            
        }
        return cell
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if indexPath.row == 2 {
            return indexPath
        } else if indexPath.row == 3 && !datePickerVisble {
            return indexPath
        } else if indexPath.row == 4 && datePickerVisble {
            return indexPath
        } else {
            return nil
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        if indexPath.row == 2 {
            datePickerVisble ? hideDatePicker() : showDatePicker()
        } else if indexPath.row == 3 && !datePickerVisble {
            imputting ? quitInput() : startInput()
        } else if indexPath.row == 4 && datePickerVisble {
            hideDatePicker()
            imputting ? quitInput() : startInput()
        } else {
            
        }
    }
}


extension SubscribeTableView: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}



