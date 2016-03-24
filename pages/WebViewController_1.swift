//
//  WebViewController_1.swift
//  pages
//
//  Created by Bobo on 1/13/16.
//  Copyright © 2016 myname. All rights reserved.
//

import Foundation
import UIKit

class WebViewController_1: UIViewController {
    
    var url = NSURL()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fd_interactivePopDisabled = true
                
        let quitButton = UIBarButtonItem(barButtonSystemItem: .Stop, target: self, action: #selector(quit))
        self.navigationItem.rightBarButtonItem = quitButton
        
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
    
    func quit() {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

extension WebViewController_1: UIWebViewDelegate {
    
    func webViewDidFinishLoad(webView: UIWebView) {
        print(webView.request?.URL)
    }
}