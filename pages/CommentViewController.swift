//
//  CommentViewController.swift
//  pages
//
//  Created by Bobo on 1/21/16.
//  Copyright © 2016 myname. All rights reserved.
//itemid
//预约记录id
//对应车服务预约列表中itemid
//不可空

//mallid
//被评论的车服务id
//对应车服务预约列表中mallid
//不可空

//username
//登录app账号-手机号
//
//不可控

//seller_star
//服务与描述相符
//满分5分
//不可空

//seller_qstar
//服务质量评分
//满分5分
//不可空

//seller_astar
//服务态度评分
//满分5分
//不可空

//seller_comment
//评价详情
//
//可空

//isAnonymous
//是否匿名
//0-不匿名  1-匿名
//可空

import Foundation
import UIKit

class CommentViewController: UIViewController {
    
    var itemid: String!
    var mallid: String!
    var username: String!
    
    var tableView: UITableView!
    var switchControl: UISwitch!
    
    var pickerVisble = false
    var inputting = false
    
    var indexForPicker = 0
    
    var stars = [-1, -1, -1]
    
    var comment = ""
    
    private let titles = ["服务与描述相符：", "服务质量评分：", "服务态度评分：", "评价：", "匿名："]
    private let starTitles = ["⭐️⭐️⭐️⭐️⭐️", "⭐️⭐️⭐️⭐️", "⭐️⭐️⭐️", "⭐️⭐️", "⭐️"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        self.title = "评价"
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "cancel")
        self.navigationItem.leftBarButtonItem = cancelButton
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "done")
        self.navigationItem.rightBarButtonItem = doneButton
        self.navigationItem.rightBarButtonItem?.enabled = false

        tableView = UITableView(frame: self.view.bounds, style: .Grouped)
        tableView.frame.size.height -= 64
        tableView.dataSource = self
        tableView.delegate = self
        self.view.addSubview(tableView)
        
        switchControl = UISwitch()
        switchControl.frame.origin = CGPoint(x: self.view.frame.width - 60, y: 5)
    }
    
    func cancel() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func done() {
        
        let stringStars = ["5", "4", "3", "2", "1"]
        
        var searchInfo = SearchInfo()
        searchInfo.typeName = "comment"
        searchInfo.itemID = self.itemid
        searchInfo.mallID = self.mallid
        searchInfo.userName = self.username
        searchInfo.stars = [stringStars[stars[0]], stringStars[stars[1]], stringStars[stars[2]]]
        searchInfo.comment = self.comment
        searchInfo.isAnonymous = switchControl.on ? "1" : "0"
        
        let search = Search()
        search.performSearchForText(searchInfo) { (_) -> Void in
            switch search.state {
            case .Results(let results):
                if let item = results[0] as? CSItem {
                    print(item.title)
                    if item.title == "1" {
                        
                        dispatch_async(dispatch_get_main_queue()) {
                            
                            self.tableView.userInteractionEnabled = false
                            let hudView = HudView.hudInView(self.view, animated: true)
                            hudView.text = "评论成功"
                            
                            delay(seconds: 0.7, completion: { () -> () in
                                hudView.removeFromSuperview()
                                self.tableView.userInteractionEnabled = true
                                self.cancel()
                            })
                        }
                        
                    } else {
                        let hudView = HudView.hudInView(self.view, animated: true)
                        hudView.text = "评论失败"
                        
                        delay(seconds: 0.7, completion: { () -> () in
                            hudView.removeFromSuperview()
                            self.view.userInteractionEnabled = true
                        })
                    }
                }
            default:
                break
            }
        }
    }
    
    func checkForContent() {
        
        if stars[0] != -1 && stars[1] != -1 && stars [2] != -1 {
            if self.view.viewWithTag(101) == nil {
                self.navigationItem.rightBarButtonItem?.enabled = true
            } else {
                self.navigationItem.rightBarButtonItem?.enabled = false
            }
        }
    }
    
    // MARK: - PickerView
    
    func showPicker(index: Int) {
        pickerVisble = true
        indexForPicker = index + 1
        
        let indexPathCommentRow = NSIndexPath(forRow: 3, inSection: 0)
        
        if let commentRow = tableView.cellForRowAtIndexPath(indexPathCommentRow) {
            if let textField = commentRow.viewWithTag(101) as? UITextField {
                textField.resignFirstResponder()
            }
        }
        
        let selectedRow = NSIndexPath(forRow: index, inSection: 0)
        let indexPathPicker = NSIndexPath(forRow: index + 1, inSection: 0)

        tableView.insertRowsAtIndexPaths([indexPathPicker], withRowAnimation: .Fade)
        
        if let selectedCell = tableView.cellForRowAtIndexPath(selectedRow) {
            if stars[index] != -1 {
                selectedCell.detailTextLabel?.text = starTitles[stars[index]]
            } else {
                stars[index] = 0
                selectedCell.detailTextLabel?.text = starTitles[stars[index]]
            }
        }
        
        if let datePickerCell = tableView.cellForRowAtIndexPath(indexPathPicker) {
            datePickerCell.textLabel?.text = nil
            datePickerCell.detailTextLabel?.text = nil
            let picker = UIPickerView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 216))
            picker.dataSource = self
            picker.delegate = self
            picker.selectRow(stars[index], inComponent: 0, animated: true)
            picker.tag = 100 + index
            datePickerCell.contentView.addSubview(picker)
        }
    }
    
    
    
    func hidePicker(index: Int) {
        if pickerVisble {
            pickerVisble = false
            
            let indexPathPicker = NSIndexPath(forRow: index + 1, inSection: 0)
            
            
            if let datePickerCell = tableView.cellForRowAtIndexPath(indexPathPicker) {
                datePickerCell.contentView.viewWithTag(100 + index)?.removeFromSuperview()
            }
            
            tableView.deleteRowsAtIndexPaths([indexPathPicker], withRowAnimation: .Fade)
        }
        
    }
    
    // MARK: - TextField
    
    func startInput(index: Int) {
        inputting = true
        self.checkForContent()
        
        self.tableView.alpha = 0.1
        self.tableView.userInteractionEnabled = false
        
        let textView = UITextView(frame: CGRect(x: 5, y: 10, width: self.view.frame.width - 10, height: 170))
        textView.backgroundColor = UIColor.whiteColor()
        textView.tag = 101
        textView.font = UIFont.systemFontOfSize(16)
        textView.delegate = self
        
        textView.layer.cornerRadius = 3
        textView.layer.borderWidth = 2
        textView.layer.borderColor = UIColor.themeColor().CGColor
        textView.text = self.comment
        textView.becomeFirstResponder()
        self.view.addSubview(textView)
        
        let doneButton = UIButton(type: .System)
        doneButton.frame = CGRect(x: self.view.frame.width - 5 - 100, y: textView.frame.origin.y + textView.frame.height + 5, width: 100, height: 40)
        doneButton.backgroundColor = UIColor.themeColor()
        doneButton.setTitle("完成", forState: .Normal)
        doneButton.tintColor = UIColor.whiteColor()
        
        doneButton.layer.cornerRadius = 3
        
        doneButton.addTarget(self, action: "quitInput", forControlEvents: .TouchUpInside)
        doneButton.tag = 102
        self.view.addSubview(doneButton)
        
//        let indexPathCommentRow = NSIndexPath(forRow: index, inSection: 0)
//        let indexPathTextFieldRow = NSIndexPath(forRow: index + 1, inSection: 0)
//        
//        if let CommentCell = tableView.cellForRowAtIndexPath(indexPathCommentRow) {
//            CommentCell.detailTextLabel?.text = self.comment
//        }
//        
//        if let textFieldCell = tableView.cellForRowAtIndexPath(indexPathTextFieldRow) {
//            textFieldCell.textLabel?.text = nil
//            textFieldCell.detailTextLabel?.text = nil
//            
//            let textView = UITextView(frame: CGRect(x: 5, y: 5, width: tableView.frame.width - 10, height: 40))
//            textView.text = comment
//            textView.textAlignment = .Right
//            textView.returnKeyType = .Done
//            textView.tag = 101
//            textView.delegate = self
//            textView.becomeFirstResponder()
//            textFieldCell.contentView.addSubview(textView)
//
//        }
    }
    
    func quitInput() {
        if inputting == true {
            inputting = false
            
            self.tableView.alpha = 1.0
            self.tableView.userInteractionEnabled = true
            
            let indexPathCommentRow = NSIndexPath(forRow: 3, inSection: 0)
            
            if let commentCell = tableView.cellForRowAtIndexPath(indexPathCommentRow) {
                
                if self.comment == "" {
                    commentCell.detailTextLabel?.text = "请输入"
                } else {
                    commentCell.detailTextLabel?.text = self.comment
                }
                
            }
            
            if let textView = self.view.viewWithTag(101) as? UITextView {
                textView.removeFromSuperview()
            }
            
            if let doneButton = self.view.viewWithTag(102) as? UIButton {
                doneButton.removeFromSuperview()
            }
            
//            let indexPathTextFieldRow = NSIndexPath(forRow: index + 1, inSection: 0)
//            
//            if let commentCell = tableView.cellForRowAtIndexPath(indexPathCommentRow) {
//
//                if self.comment == "" {
//                    commentCell.detailTextLabel?.text = "请输入"
//                } else {
//                    commentCell.detailTextLabel?.text = self.comment
//                }
//                    
//            }
//            
//            if let textViewCell = tableView.cellForRowAtIndexPath(indexPathTextFieldRow) {
//                
//                if let textView = textViewCell.contentView.viewWithTag(101) as? UITextView {
//                    textView.resignFirstResponder()
//                    textView.removeFromSuperview()
//                }
//            }
        }
        
        self.checkForContent()
        
    }
    
    func editChanged(textField: UITextField) {
        self.comment = textField.text!
        checkForContent()
    }
}


extension CommentViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pickerVisble || inputting ? 6 : 5
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if pickerVisble && indexPath.row == indexForPicker {
            return 217
        } else {
            return 44
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Value1, reuseIdentifier: "cell")
        cell.textLabel?.text = titles[indexPath.row]
        
        if indexPath.row < 3 { cell.detailTextLabel?.text = "请评分" }
        if indexPath.row == 3 { cell.detailTextLabel?.text = "请输入" }
        if indexPath.row == 4 { cell.contentView.addSubview(switchControl) }
        return cell
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        
        if pickerVisble {
            let selectedIndexPath = NSIndexPath(forRow: indexForPicker - 1, inSection: 0)
            return selectedIndexPath
        } else if inputting {
            let selectedIndexPath = NSIndexPath(forRow: 3, inSection: 0)
            return selectedIndexPath
        } else {
            return indexPath
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row < 3 {
//            if inputting { quitInput(3) }
            pickerVisble ? hidePicker(indexPath.row) : showPicker(indexPath.row)
        } else if indexPath.row == 3 {
//            if pickerVisble { hidePicker(indexForPicker - 1) }
            inputting ? quitInput() : startInput(indexPath.row)
        } else {
            
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)

    }
    
}


extension CommentViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 5
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return starTitles[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let index = pickerView.tag - 100
        stars[index] = row
        checkForContent()
        
        let selectedIndex = indexForPicker - 1
        let indexPath = NSIndexPath(forRow: selectedIndex, inSection: 0)
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            cell.detailTextLabel?.text = starTitles[row]
        }
        
    }
}

extension CommentViewController: UITextViewDelegate {
    
    func textViewDidChange(textView: UITextView) {
        self.comment = textView.text
        print(textView.text)
    }
}

extension CommentViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        quitInput()
        return true
    }
    
}



















