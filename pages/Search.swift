//
//  Search.swift
//  StoreSearch
//
//  Created by 文川术 on 15/8/28.
//  Copyright (c) 2015年 xiaoyao. All rights reserved.
//

import Foundation
import UIKit

typealias SearchComplete = (Bool) -> Void

struct SearchInfo {
    var typeName = ""
    var memberIndex = 1
    var CSKindID = -1
    var body = [String]()
    var addition = ""
    var itemID = ""
    
    var pid = ""
    
    var comment = ""
    var date = ""
    
    var userName = ""
}

class Search {

	enum State {
		case NotSearchedYet
		case Loading
		case NoResults
		case Results([AnyObject])
	}

	private(set) var state: State = .NotSearchedYet
	private var dataTask: NSURLSessionDataTask? = nil


    func performSearchForText(searchInfo: SearchInfo, completion: SearchComplete) {
        dataTask?.cancel()

        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        state = .Loading

        let url = urlWithSearchText(searchInfo)
        print(url)
        let session = NSURLSession.sharedSession()
        dataTask = session.dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in

            self.state = .NotSearchedYet
            var success = false

            if let error = error {
                if error.code == -999 { return }
            } else if let httpResponse = response as? NSHTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    if let dictionary = self.parseJOSN(data!) {
                        let searchResults = self.parseDictionary(searchInfo.typeName, dictionary: dictionary)
                        if searchResults.isEmpty {
                            self.state = .NoResults
                        } else {
                            self.state = .Results(searchResults)
                        }
                        success = true
                    }
                } else {
                    print(httpResponse.statusCode)
                }
            }

            dispatch_async(dispatch_get_main_queue()) {
					UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                completion(success)
            }
        })

        dataTask?.resume()
		
	}

	// MARK: - Networking

    private func urlWithSearchText(searchInfo: SearchInfo) -> NSURL {
        var urlString = ""
        var url = NSURL()
        
        switch searchInfo.typeName {
        case "member":
            let string = "\(searchInfo.memberIndex)"
            urlString = String(format: "http://www.cncar.net/api/app/member.php?username=13971244139&type=%@&distance=10", string)
            
        case "personInfo":
            urlString = String(format: "http://dreamcar.cncar.net/appFCLoadPersonInfo.do?channelId=%@", searchInfo.body[0])
            
        case "carService":
            urlString = String(format: "http://www.cncar.net/api/app/server/serverList.php?servicetype=%@&lon=%@&lat=%@&page=%@&rows=%@", searchInfo.body[0], searchInfo.body[1], searchInfo.body[2], searchInfo.body[3], searchInfo.body[4])
            
            if searchInfo.CSKindID != 0 {
                urlString += "&kindId=\(searchInfo.CSKindID)"
            }
            
            urlString += searchInfo.addition
            
        case "item":
            urlString = String(format: "http://www.cncar.net/api/app/server/content.php?itemid=%@", searchInfo.itemID)
            
        case "ad":
            urlString = String(format: "http://www.cncar.net/api/app/ad/ad.php?pid=%@", searchInfo.pid)
            
        case "subscribe":
            urlString = String(format: "http://www.cncar.net/api/app/server/saveapply.php?itemid=%@&username=15927284689&applycontent=%@&servertime=%@", searchInfo.itemID, searchInfo.comment, searchInfo.date).URLEncodedString()!
            
        case "applyItem":
            urlString = String(format: "http://www.cncar.net/api/app/server/applylist.php?username=%@&identity=%@&page=%@&rows=%@", searchInfo.userName, "1", 1, 30).URLEncodedString()!
        default:
            break
        }
        
        url = NSURL(string: urlString)!
		return url
	}

	private func parseJOSN(data: NSData) -> [String: AnyObject]?  {
		// var error: NSError?

		do {
			let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0)) as? [String: AnyObject]
			return json
		} catch let error as NSError {
			print("JSON Error: \(error)")
		} catch {
			print("Unknown JSON Error")
		}

		return nil
	}

	// MARK: - ParseDictionary

    private func parseDictionary(type: String, dictionary: [String: AnyObject]) -> [AnyObject] {

		var searchResults = [SearchResult]()
        var CSResults = [CSResult]()
        var appleItems = [ApplyItem]()

        
        if type == "item" {
            let body = dictionary["body"]  as! NSNumber as Float
            if body == 1 {
                let csItem = CSItem()
                csItem.itemID = dictionary["itemid"] as! NSString as String
                csItem.title = dictionary["title"] as! NSString as String
                csItem.titleIntact = dictionary["titleintact"] as! NSString as String
                csItem.subHeading = dictionary["subheading"] as! NSString as String
                csItem.price = dictionary["price"] as! NSString as String
                csItem.thumb = dictionary["thumb"] as! NSString as String
                csItem.thumb1 = dictionary["thumb1"] as! NSString as String
                csItem.thumb2 = dictionary["thumb2"] as! NSString as String
                csItem.thumb3 = dictionary["thumb3"] as! NSString as String
                csItem.thumb4 = dictionary["thumb4"] as! NSString as String
//                csItem.comid = dictionary["comid"] as! NSString as String
                csItem.company = dictionary["company"] as! NSString as String
                csItem.address = dictionary["address"] as! NSString as String
                csItem.telephone = dictionary["telephone"] as! NSString as String
                csItem.longitude = dictionary["longitude"] as! NSString as String
                csItem.latitude = dictionary["latitude"] as! NSString as String
                csItem.content = dictionary["content"] as! NSString as String
                csItem.star = dictionary["star"] as! NSNumber as Float
                csItem.qstar = dictionary["qstar"] as! NSNumber as Float
                csItem.astar = dictionary["astar"] as! NSNumber as Float
                
                return [csItem]
            } else {
                let csItem = CSItem()
                return [csItem]
            }

        }
        
        if type == "subscribe" {
            let body = dictionary["body"] as! NSString as String
                let csItem = CSItem()
                csItem.title = body
                return [csItem]

            
        }
        
		if let array: AnyObject = dictionary["rows"] {

			for resultDict in array as! [AnyObject] {
				if let resultDict = resultDict as? [String: AnyObject] {
                    switch type {
                    case "member":
                        let searchResult = SearchResult()
                        searchResult.username = resultDict["username"] as! NSString as String
                        searchResult.name = resultDict["name"] as! NSString as String
                        searchResult.mobile = resultDict["mobile"] as! NSString as String
                        searchResult.image = resultDict["image"] as! NSString as String
                        searchResult.obd_status = resultDict["obd_status"] as! NSString as String
                        searchResult.huanxinid = resultDict["huanxinid"] as! NSString as String
                        searchResult.chexing = resultDict["chexing"] as! NSString as String
                        searchResult.me = resultDict["me"] as! NSString as String
                        searchResult.typename = resultDict["typename"] as! NSString as String
                        // searchResult.distance = resultDict["distance"] as! NSString as String
                        searchResult.longitude = resultDict["longitude"] as! NSString as String
                        searchResult.latitude = resultDict["latitude"] as! NSString as String
                        searchResults.append(searchResult)
                        
                    case "carService":
                        let csResult = CSResult()
                        csResult.itemid = resultDict["itemid"] as! NSString as String
                        csResult.title = resultDict["title"] as! NSString as String
                        csResult.price = resultDict["price"] as! NSString as String
                        csResult.thumb = resultDict["thumb"] as! NSString as String
                        csResult.distance = resultDict["distance"] as! NSNumber as Float
                        csResult.address = resultDict["address"] as! NSString as String
                        csResult.company = resultDict["company"] as! NSString as String
                        csResult.star = resultDict["star"] as! NSNumber as Float
                        CSResults.append(csResult)
                        
                    case "ad":
                        var imageURLs = [String]()
                        imageURLs.append(resultDict["image_src"] as! NSString as String)
                        imageURLs.append(resultDict["image_url"] as! NSString as String)
                        imageURLs.append(resultDict["image_alt"] as! NSString as String)
                        return imageURLs
                        
                    case "applyItem":
                        let applyItem = ApplyItem()
                        applyItem.itemid = resultDict["itemid"] as! NSString as String
                        applyItem.title = resultDict["title"] as! NSString as String
                        applyItem.price = resultDict["price"] as! NSString as String
                        applyItem.thumb = resultDict["thumb"] as! NSString as String
                        applyItem.company = resultDict["company"] as! NSString as String
                        applyItem.servertime = resultDict["servertime"] as! NSString as String
                        applyItem.note = resultDict["note"] as! NSString as String
                        applyItem.status = resultDict["status"] as! NSString as String
                        applyItem.status_note = resultDict["status_note"] as! NSString as String
                        applyItem.mallid = resultDict["mallid"] as! NSString as String
                        applyItem.comfirm_time = resultDict["comfirm_time"] as! NSString as String
                        applyItem.comfirm_note = resultDict["comfirm_note"] as! NSString as String
                        applyItem.evaluation = resultDict["evaluation"] as! NSString as String
                        appleItems.append(applyItem)
                        
                    default:
                        break
                    }
					
					

				} else {
					print("Expected a dictionary")
				}
			}

        } else {
			print("Expected 'results' array")
        }
        
        
        if let array: AnyObject = dictionary["body"] {
            if let resultDict = array as? [String: AnyObject] {
                    let searchResult = SearchResult()
                
                if let path = resultDict["head%5fpath"] as? NSString as? String {
                    let decodedPath = path.URLDecodeString()
                    let urlPath = "http://dreamcar.cncar.net/" + decodedPath!
                    
                    searchResult.image = urlPath
                }
                
                if let path = resultDict["cust%5fname"] as? NSString as? String {
                    let decodedPath = path.URLDecodeString()
                    
                    searchResult.name = decodedPath!
                }
                
                searchResults.append(searchResult)

                
            } else {
                print("Expected a dictionary")
            }
        
            
        }
        
        if type == "carService" {
            return CSResults
        } else if type == "member" {
            return searchResults
        } else if type == "applyItem" {
            return appleItems
        } else {
            return searchResults
        }
        
    }
    
    
}