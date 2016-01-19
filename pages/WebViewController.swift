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
        webView.frame.size.height -= 64
        webView.loadRequest(NSURLRequest(URL: url))
        webView.delegate = self
        view.addSubview(webView)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setToolbarHidden(true, animated: true)
        
        self.navigationController?.hidesBarsOnSwipe = false
        self.navigationController?.hidesBarsOnTap = false
    }
}

extension WebViewController: UIWebViewDelegate {
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return true
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
    }
}