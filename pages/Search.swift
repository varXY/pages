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
        var url = NSURL()
        
        switch searchInfo.typeName {
        case "member":
            let string = "\(searchInfo.memberIndex)"
            let urlString = String(format: "http://www.cncar.net/api/app/member.php?username=13971244139&type=%@&distance=10", string)
            url = NSURL(string: urlString)!
        case "personInfo":
            let urlString = String(format: "http://dreamcar.cncar.net/appFCLoadPersonInfo.do?channelId=%@", searchInfo.body[0])
            url = NSURL(string: urlString)!
        case "carService":
            var urlString = String(format: "http://www.cncar.net/api/app/server/serverList.php?servicetype=%@&lon=%@&lat=%@&page=%@&rows=%@", searchInfo.body[0], searchInfo.body[1], searchInfo.body[2], searchInfo.body[3], searchInfo.body[4])
            
            if searchInfo.CSKindID != 0 {
                urlString += "&kindId=\(searchInfo.CSKindID)"
            }
            
            urlString += searchInfo.addition
            
            url = NSURL(string: urlString)!
        default:
            break
        }
        
        
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
                        
                        print(searchResult.longitude)
                    
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
        
            
        } else {
            print("Expected 'results' array")
        }
        
        if type == "carService" {
            return CSResults
        } else {
            return searchResults
        }
    }
    
    
}