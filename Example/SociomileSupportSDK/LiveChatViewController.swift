//
//  LiveChatViewController.swift
//  SociomileSDK Sample
//
//  Created by Meynisa on 16/05/24.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit
import WebKit

class LiveChatViewController: UIViewController, WKNavigationDelegate {
    var webview: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = ""
        view.backgroundColor = .cyan
        
        webview = WKWebView()
        webview.navigationDelegate = self
        view = webview
        let url = URL(string: "https://chat.sociomile.com/livechat/6641da56462edc69b0212951")!
        webview.load(URLRequest(url: url))
        webview.allowsBackForwardNavigationGestures = true
        
//        webview = WKWebView(frame: self.view.frame)
//        self.view.addSubview(webview)
//
//        if let url = URL(string: "https://chat.sociomile.com/livechat/6641da56462edc69b0212951") {
//            let request = URLRequest(url: url)
//            webview.load(request)
//        }

    }
}

class LiveChatRouter: BaseCoordinator{
    init(_ navigationController: UINavigationController?) {
        super.init(navigationController)
    }
    
    override func setup() -> UIViewController {
        let view = LiveChatViewController()
        self.currentNavigationController = view.navigationController
        return view
    }
    
    override func start() {
        let viewController = self.setup()
        self.parentNavigationController?.pushViewController(viewController, animated: true)
    }
}
