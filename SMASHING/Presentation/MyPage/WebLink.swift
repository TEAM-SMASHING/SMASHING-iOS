//
//  WebLink.swift
//  SMASHING
//
//  Created by 이승준 on 3/19/26.
//

import UIKit
import WebKit

class PrivacyWebVC: UIViewController {
    
    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView = WKWebView(frame: view.bounds)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(webView)
        
        if let termsURL = URL(string: "https://elated-piccolo-63b.notion.site/30b4556d60d18092b22ad0e23a84eee2?pvs=143") {
            let request = URLRequest(url: termsURL)
            webView.load(request)
        }
    }
}

class TermsOfUseWebVC: UIViewController {
    
    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView = WKWebView(frame: view.bounds)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(webView)
        
        if let termsURL = URL(string: "https://elated-piccolo-63b.notion.site/30b4556d60d18092b22ad0e23a84eee2") {
            let request = URLRequest(url: termsURL)
            webView.load(request)
        }
    }
}
