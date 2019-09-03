//
//  AuthViewController.swift
//  Notes
//
//  Created by Jag Stang on 10/08/2019.
//  Copyright © 2019 JagStang. All rights reserved.
//

import UIKit
import WebKit

struct Token: Decodable {
    let access_token: String
}

class AuthViewController: UIViewController {

    var presenter: AuthPresenterProtocol!
    
    private var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
    }
}

extension AuthViewController: AuthViewProtocol {
    func setupViews(configuration: WKWebViewConfiguration) {
        view.backgroundColor = .white
        
        webView = WKWebView(frame: view.frame, configuration: configuration)
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }
    
    func load(request: URLRequest, with delegate: WKNavigationDelegate) {
        webView.load(request)
        webView.navigationDelegate = delegate
    }
}
