//
//  SearchResult.swift
//  StoreSearch
//
//  Created by 文川术 on 15/8/8.
//  Copyright (c) 2015年 xiaoyao. All rights reserved.
//

import Foundation


func < (lhs: SearchResult, rhs: SearchResult) -> Bool {
	return lhs.name.localizedStandardCompare(rhs.name) == NSComparisonResult.OrderedAscending
}

//"body": 1,
//"userid": "1452",
//"company": "河北邢台九龙峡旅游区自驾车房车露营地",
//"areaname": "河北邢台市",
//"address": "河北省邢台县浆水镇营房台村",
//"content": " 企业简介",
//"thumb": "http://www.hjinfo-img.com/cncar-img/201601/08/11-42-05-25-1452.jpg",
//"longitude": null,
//"latitude": null,
//"telephone": "0319-3661078",
//"modelss": [
//{
//"models": "国内车",
//"models_itemid": "东风本田CRV,上海大众,大海大众奥迪,"
//},
//{
//"models": "进口车",
//"models_itemid": "进口车1,进口车2,进口车5,"
//}
//],
//"items": [
//{
//"item_name": "服务项目",
//"item_value": "测试1,测试2,测试3"
//}
//]

class Company_modelss: NSObject {
    var models = ""
    var models_itemid = ""
}

class Company_items: NSObject {
    var item_name = ""
    var item_value = ""
}

class Company: NSObject {
    
    var body: Float = 0.0
    var userid = ""
    var company = ""
    var areaname = ""
    var truename = ""
    var address = ""
    var content = ""
    var thumb = ""
    var email = ""
    var longitude: AnyObject?
    var latitude: AnyObject?
    var telephone = ""
    var modelss = NSArray()
    var items = NSArray()
    
}

class Product: NSObject {
    
    var itemid = ""
    var title = ""
    var price = ""
    var brand = ""
    var thumb = ""
    var subheading = ""
    var areaname = ""
    var address = ""
    var userid = ""
    var company = ""
    var star: Float = 0.0
    
}

class Review: NSObject {
    
    var seller_star = ""
    var seller_qstar = ""
    var seller_astar = ""
    var seller_comment = ""
    var buyer = ""
    var fromid = ""
    var seller_ctime = ""
    var isAnonymous = ""
    
}

class ApplyItem: NSObject {
    
    var itemid = ""
    var title = ""
    var price = ""
    var thumb = ""
    var company = ""
    var servertime = ""
    var note = ""
    var status = ""
    var status_note = ""
    var mallid = ""
    var comfirm_time = ""
    var comfirm_note = ""
    var evaluation = ""
    
}

class CSItem: NSObject {
    
    var body: Float = 0.0
    var itemID = ""
    var title = ""
    var titleIntact = ""
    var subHeading = ""
    var price = ""
    var thumb = ""
    var thumb1 = ""
    var thumb2 = ""
    var thumb3 = ""
    var thumb4 = ""
//    var comid = ""
    var company = ""
    var address = ""
    var telephone = ""
    var longitude = ""
    var latitude = ""
    var content = ""
    var star: Float = 0.0
    var qstar: Float = 0.0
    var astar: Float = 0.0
    
}

class CSResult: NSObject {
    
    var itemid = ""
    var title = ""
    var price = ""
    var thumb = ""
    var distance: Float = 0.0
    var address = ""
    var company = ""
    var chexing = ""
    var userid = ""
    var star: Float = 0.0
}

class SearchResult: NSObject, NSCoding {
	var username = ""
	var name = ""
	var mobile = ""
	var image = ""
	var storeURL = ""
	var obd_status = ""
	var huanxinid = ""
	var chexing = ""
	var groupid = ""
    var me = ""
    var typename = ""
    var distance = ""
    var longitude = ""
    var latitude = ""
    var friends = [String]()
    
    override init() {
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(username, forKey: "Username")
        aCoder.encodeObject(name, forKey: "Name")
        aCoder.encodeObject(mobile, forKey: "Mobile")
        aCoder.encodeObject(image, forKey: "Image")
        aCoder.encodeObject(storeURL, forKey: "StoreURL")
        aCoder.encodeObject(obd_status, forKey: "Obd_status")
        aCoder.encodeObject(huanxinid, forKey: "Huanxinid")
        aCoder.encodeObject(chexing, forKey: "Chexing")
        aCoder.encodeObject(groupid, forKey: "Groupid")
        aCoder.encodeObject(me, forKey: "Me")
        aCoder.encodeObject(typename, forKey: "Typename")
        aCoder.encodeObject(distance, forKey: "Distance")
        aCoder.encodeObject(longitude, forKey: "Longitude")
        aCoder.encodeObject(latitude, forKey: "Latitude")
        aCoder.encodeObject(friends, forKey: "Friends")
    }
    
    required init?(coder aDecoder: NSCoder) {
        username = aDecoder.decodeObjectForKey("Username") as! String
        name = aDecoder.decodeObjectForKey("Name") as! String
        mobile = aDecoder.decodeObjectForKey("Mobile") as! String
        image = aDecoder.decodeObjectForKey("Image") as! String
        storeURL = aDecoder.decodeObjectForKey("StoreURL") as! String
        obd_status = aDecoder.decodeObjectForKey("Obd_status") as! String
        huanxinid = aDecoder.decodeObjectForKey("Huanxinid") as! String
        chexing = aDecoder.decodeObjectForKey("Chexing") as! String
        groupid = aDecoder.decodeObjectForKey("Groupid") as! String
        me = aDecoder.decodeObjectForKey("Me") as! String
        typename = aDecoder.decodeObjectForKey("Typename") as! String
        distance = aDecoder.decodeObjectForKey("Distance") as! String
        longitude = aDecoder.decodeObjectForKey("Longitude") as! String
        latitude = aDecoder.decodeObjectForKey("Latitude") as! String
        friends = aDecoder.decodeObjectForKey("Friends") as! [String]
        super.init()
    }

}
