//
//  PModel.swift
//  pages
//
//  Created by Bobo on 15/12/31.
//  Copyright © 2015年 myname. All rights reserved.
//

import Foundation

let ScreenBounds = UIScreen.mainScreen().bounds
let ScreenWidth = ScreenBounds.width
let ScreenHeight = ScreenBounds.height

let BarHeight = UIApplication.sharedApplication().statusBarFrame.height

class PModel {
    
    var titles = ["汽车维修", "汽车美容" ,"增值服务", "产品资讯"]
    
    func getURL(index: Int) -> NSURL? {
        var url = NSURL()
        var string = ""
        
        switch index {
        case 0:
            string = ""
        case 1:
            string = "http://www.cncar.net/project/linechoose/list.php?username=15623413370"
        case 2:
            string = "http://www.cncar.net/project/linechoose/clubsls.php"
        case 3:
            string = "http://www.cncar.net/jq/carservice-servicelist.html?type=2&type2=436&title=汽车维修"
        case 4:
            string = "http://www.cncar.net/jq/carservice-servicelist.html?type=2&type2=348&title=汽车维修"
        case 5:
            string = "http://www.cncar.net/jq/carservice-servicelist.html?type=2&type2=349&title=汽车维修"
        case 6:
            string = "http://www.cncar.net/jq/carservice-servicelist.html?type=2&type2=346&title=汽车维修"
        case 7:
            string = "http://www.cncar.net/jq/carservice-servicelist.html?type=2&type2=350&title=汽车维修"
        case 8:
            string = "http://www.cncar.net/jq/carservice-servicelist.html?type=2&type2=353&title=汽车维修"
        case 9:
            string = "http://www.cncar.net/jq/carservice-servicelist.html?type=2&type2=354&title=汽车维修"
        case 10:
            string = "http://www.cncar.net/jq/carservice-servicelist.html?type=2&type2=355&title=汽车维修"
        case 11:
            string = "http://www.cncar.net/jq/carlife-info_detail.html?id=31&tail=爱车"
        case 12:
            string = "http://www.cncar.net/jq/carlife-info_detail.html?id=30&tail=正品识别"
        case 13:
            string = "http://www.cncar.net/jq/carservice-servicelist.html?type=1&type2=336&title=汽车美容"
        case 14:
            string = "http://www.cncar.net/jq/carservice-servicelist.html?type=1&type2=338&title=汽车美容"
        case 15:
            string = "http://www.cncar.net/jq/carservice-servicelist.html?type=1&type2=339&title=汽车美容"
        case 16:
            string = "http://www.cncar.net/jq/carservice-servicelist.html?type=1&type2=341&title=汽车美容"
        case 17:
            string = "http://www.cncar.net/jq/carservice-servicelist.html?type=1&type2=343&title=汽车美容"
        case 18:
            string = "http://www.cncar.net/jq/carservice-servicelist.html?type=1&type2=345&title=汽车美容"
        case 19:
            string = "http://www.cncar.net/jq/carservice-servicelist.html?type=1&type2=344&title=汽车美容"
        case 20:
            string = "http://www.cncar.net/jq/carservice-servicelist.html?type=1&type2=342&title=汽车美容"
        default:
            string = "http://www.cncar.net/jq/carservice-index.html"
        }
        
        if string == "" {
            return nil
        } else {
            let escapedString = URLEncodedString(string)
            url = NSURL(string: escapedString!)!
            return url
        }
        
    }
    
    func getURL_Travel(index: Int) -> NSURL? {
        var url = NSURL()
        var string = ""
        
        switch index {
        case 0:
            string = "http://www.cncar.net/project/linechoose/list.php?username=15623413370"
        case 1:
            string = "http://www.cncar.net/project/linechoose/clubsls.php"
        case 2:
            string = ""
        case 3:
            string = "http://www.cncar.net/jq/carlife-travel-search.html?type=3&type2=-1&title=境外游"
        case 4:
            string = "http://www.cncar.net/jq/carlife-travel-search.html?type=2&type2=-1&title=国内游"
        case 5:
            string = "http://www.cncar.net/jq/carlife-route.html"
        case 6:
            string = "http://www.cncar.net/jq/carlife-special.html?type=3&title=特惠"
        case 7:
            string = "http://www.cncar.net/jq/carlife-homestay.html"
        case 8:
            string = "http://www.cncar.net/jq/carlife-camplist.html"
        case 9:
            string = "http://www.cncar.net/jq/carlife-hotel.html"
        case 10:
            string = "http://www.cncar.net/jq/carlife-spot.html"
        case 11:
            string = "http://www.cncar.net/project/linechoose/list.php?username=15623413370"
        case 12:
            string = "http://www.cncar.net/jq/carlife-route.html"
        case 13:
            string = "http://www.cncar.net/jq/carlife-travel-search.html?type=2&type2=-1&title=国内游"
        case 14:
            string = "http://www.cncar.net/jq/carlife-travel-search.html?type=-1&type2=1&title=专属定制"
        case 15:
            string = "http://www.cncar.net/jq/carlife-travel-search.html?type=2&type2=-1&title=国内游"
        case 16:
            string = "http://www.cncar.net/jq/carlife-hotel.html"
        case 17:
            string = "http://www.cncar.net/jq/carlife-special.html?type=3&title=特惠"
        default:
            string = "http://www.cncar.net/jq/carlife-travel.html"
        }
        
        if string == "" {
            return nil
        } else {
            let escapedString = URLEncodedString(string)
            url = NSURL(string: escapedString!)!
            return url
        }
        
    }
    
    func getRequest(index: Int) -> NSURLRequest {
        let type = [3, 2, 2]
        let type2 = -1
        var url = NSURL()
        
        if index == 0 {
            url = NSURL(string: "http://www.cncar.net/jq/carservice-index.html")!
        }
        
        if index > 0 && index < 4 {
            let title = titles[index - 1].stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            let typeA = "\(type[index - 1])"
            let typeB = "\(type2)"
            let string = String(format: "http://www.cncar.net/jq/carservice-servicelist.html?type=%@&type2=%@&title=%@", typeA, typeB, title!)
            url = NSURL(string: string)!
        }
        
        if index == 4 {
            url = NSURL(string: "http://www.cncar.net/jq/carservice-infoindex.html")!
        }
        
        let request = NSURLRequest(URL: url)
        
        return request
        
    }
    
    func URLEncodedString(string: String) -> String? {
        let customAllowedSet =  NSCharacterSet.URLQueryAllowedCharacterSet()
        let escapedString = string.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)
        return escapedString
    }
}