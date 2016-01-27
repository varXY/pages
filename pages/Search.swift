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

typealias SearchDone = (Search) -> Void

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
    var applyStatus = -1
    var action = ""
    
    var mallID = ""
    var stars = [String]()
    var isAnonymous = "0"
    var page = "1"
    
    var productKindID = "0"
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
    
    
    class func performSearchForText(searchInfo: SearchInfo, completion: SearchDone) {
        let search = Search()
        
        search.dataTask?.cancel()
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        search.state = .Loading
        
        let url = search.urlWithSearchText(searchInfo)
        print(url)
        let session = NSURLSession.sharedSession()
        search.dataTask = session.dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
            
            search.state = .NotSearchedYet
            
            if let error = error {
                if error.code == -999 { return }
            } else if let httpResponse = response as? NSHTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    if let dictionary = search.parseJOSN(data!) {
                        let searchResults = search.parseDictionary(searchInfo.typeName, dictionary: dictionary)
                        if searchResults.isEmpty {
                            search.state = .NoResults
                        } else {
                            search.state = .Results(searchResults)
                        }
                    }
                } else {
                    print(httpResponse.statusCode)
                }
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                completion(search)
            }
        })
        
        search.dataTask?.resume()
        
    }


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
            urlString = String(format: "http://www.cncar.net/api/app/member.php?username=13971244139&type=%@&distance=10", string).URLEncodedString()!
            
        case "personInfo":
            urlString = String(format: "http://dreamcar.cncar.net/appFCLoadPersonInfo.do?channelId=%@", searchInfo.body[0]).URLEncodedString()!
            
        case "carService":
            urlString = String(format: "http://www.cncar.net/api/app/server/serverList.php?servicetype=%@&lon=%@&lat=%@&page=%@&rows=%@", searchInfo.body[0], searchInfo.body[1], searchInfo.body[2], searchInfo.body[3], searchInfo.body[4]).URLEncodedString()!
            
            if searchInfo.CSKindID != 0 {
                urlString += "&kindId=\(searchInfo.CSKindID)"
            }
            
            urlString += searchInfo.addition
            
        case "item":
            urlString = String(format: "http://www.cncar.net/api/app/server/content.php?itemid=%@", searchInfo.itemID).URLEncodedString()!
            
        case "ad":
            urlString = String(format: "http://www.cncar.net/api/app/ad/ad.php?pid=%@", searchInfo.pid).URLEncodedString()!
            
        case "subscribe":
            urlString = String(format: "http://www.cncar.net/api/app/server/saveapply.php?itemid=%@&username=15927284689&applycontent=%@&servertime=%@", searchInfo.itemID, searchInfo.comment, searchInfo.date).URLEncodedString()!
            
        case "applyItem":
            urlString = String(format: "http://www.cncar.net/api/app/server/applylist.php?username=%@&identity=%@&page=%@&rows=%@", searchInfo.userName, "1", searchInfo.page, "60").URLEncodedString()!
            if searchInfo.applyStatus != -1 {
                urlString += "&status=\(searchInfo.applyStatus)"
            }
            
        case "dealWithApply":
            urlString = String(format: "http://www.cncar.net/api/app/server/applymanage.php?username=%@&itemid=%@&identity=%@&action=%@", searchInfo.userName, searchInfo.itemID, "1", searchInfo.action).URLEncodedString()!
            
        case "comment":
            urlString = String(format: "http://www.cncar.net/api/app/server/savecomment.php?itemid=%@&mallid=%@&username=%@&seller_star=%@&seller_qstar=%@&seller_astar=%@&seller_comment=%@&isanonymous=%@", searchInfo.itemID, searchInfo.mallID, searchInfo.userName, searchInfo.stars[0], searchInfo.stars[1], searchInfo.stars[2], searchInfo.comment, searchInfo.isAnonymous).URLEncodedString()!
            
        case "commentList":
            urlString = String(format: "http://www.cncar.net/api/app/server/commentList.php?itemid=%@&page=%@&rows=%@", searchInfo.itemID, "1", "60").URLEncodedString()!
            
        case "products":
            urlString = String(format: "http://www.cncar.net/api/app/product/productList.php?kindId=%@&page=%@&rows=%@", searchInfo.productKindID, "1", "30").URLEncodedString()!
            
            urlString += searchInfo.addition.URLEncodedString()!
            
        default:
            break
        }
        
        url = NSURL(string: urlString)!
		return url
	}

	private func parseJOSN(data: NSData) -> [String: AnyObject]?  {

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
        var imageURLs = [String]()
        var appleItems = [ApplyItem]()
        var reviews = [Review]()
        var products = [Product]()
        
        if type == "item" {
            var csItem = CSItem()
            let anyObject = dictionary as AnyObject
            csItem = (anyObject => CSItem.self)!
            return [csItem]
        }
        
        if type == "subscribe" {
            let body = dictionary["body"] as! NSString as String
                let csItem = CSItem()
                csItem.title = body
                return [csItem]

        }
        
        if type == "dealWithApply" {
            let body = dictionary["body"] as! NSString as String
            let csItem = CSItem()
            csItem.title = body
            return [csItem]
        }
        
        if type == "comment" {
            let body = dictionary["body"] as! NSString as String
            let csItem = CSItem()
            csItem.title = body
            return [csItem]
        }
        
		if let array: AnyObject = dictionary["rows"] {
            
            if let theArray = array as? [AnyObject] {
                switch type {
                case "carService":
                    CSResults = theArray.flatMap({ $0 => CSResult.self })
                case "applyItem":
                    appleItems = theArray.flatMap({ $0 => ApplyItem.self })
                case "commentList":
                    reviews = theArray.flatMap({ $0 => Review.self })
                case "products":
                    products = theArray.flatMap({ $0 => Product.self })
                default:
                    break
                }
                
            }
            

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
                        
                    case "ad":
                        imageURLs.append(resultDict["image_src"] as! NSString as String)
                    
                    default:
                        break
                    }
					
					

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

                
            }
            
        }
        
        if type == "carService" {
            return CSResults
        } else if type == "member" {
            return searchResults
        } else if type == "applyItem" {
            return appleItems
        } else if type == "commentList" {
            return reviews
        } else if type == "ad" {
            return imageURLs
        } else if type == "products" {
            return products
        } else {
            return searchResults
        }
        
    }
    
    
}