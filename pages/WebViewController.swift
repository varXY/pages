//
//  WebViewController.swift
//  pages
//
//  Created by Bobo on 12/31/15.
//  Copyright © 2015 myname. All rights reserved.
//

import Foundation
import UIKit

class WebViewController: UIViewController {
    
    var url = NSURL()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fd_interactivePopDisabled = true
        
        let webView = UIWebView(frame: view.bounds)
        webView.loadRequest(NSURLRequest(URL: url))
        view.addSubview(webView)
    }
}