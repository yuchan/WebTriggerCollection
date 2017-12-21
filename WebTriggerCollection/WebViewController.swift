//
//  WebViewController.swift
//  WebTriggerCollection
//
//  Created by Yusuke Ohashi on 2017/12/20.
//  Copyright © 2017 Yusuke Ohashi. All rights reserved.
//

import UIKit

var jshandler: String = ""

class WebViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        do {
            jshandler = try String(contentsOfFile: Bundle.main.path(forResource: "ajaxHandler", ofType: "js")!, encoding: String.Encoding.utf8)
        } catch {
        }

        let webView = UIWebView(frame: CGRect.zero)
        webView.delegate = self
        self.view.addSubview(webView)
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        let paddingConstant:CGFloat = 0.0;
        webView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: paddingConstant).isActive = true
        webView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -paddingConstant).isActive = true
        webView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: paddingConstant).isActive = true
        webView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -paddingConstant).isActive = true
        let url = URL(string: "http://localhost:5000/")
        let request = URLRequest(url: url!)
        webView.loadRequest(request)
    }

}

extension WebViewController: UIWebViewDelegate {

    func webViewDidStartLoad(_ webView: UIWebView) {
    }

    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if request.url?.scheme == "mpajaxhandler" {
            return false
        }
        return true
    }

}
