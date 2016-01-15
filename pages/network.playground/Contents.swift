//: Playground - noun: a place where people can play

import Foundation
import XCPlayground
import UIKit

XCPlaygroundPage.currentPage.needsIndefiniteExecution = true

var data0: String?

func httpGet(request: NSURLRequest!, callback: (String, String?) -> Void) {
    let session = NSURLSession.sharedSession()
    let task = session.dataTaskWithRequest(request){
        (data, response, error) -> Void in
        if error != nil {
            callback("", error!.localizedDescription)
        } else {
            let result = NSString(data: data!, encoding:
                NSASCIIStringEncoding)!
            callback(result as String, nil)
        }
    }
    task.resume()
}

let request = NSURLRequest(URL: NSURL(string: "http://www.bing.com")!)
httpGet(request) { (data, error) -> Void in
    if error != nil {
        print(error)
    } else {
        print(data)
        data0 = data
    }
}


let lbl = UILabel(frame: CGRectMake(0, 0, 300, 100))
lbl.text = "Hello StackOverflow!"
lbl.backgroundColor = UIColor.whiteColor()




