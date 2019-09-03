//
//  AuthInteractor.swift
//  Notes
//
//  Created by Jag Stang on 24/08/2019.
//  Copyright © 2019 JagStang. All rights reserved.
//

import Foundation
import WebKit

class AuthInteractor: NSObject, AuthInteractorProtocol {
    weak var presenter: AuthPresenterProtocol?
    
    func getWebViewConfiguration() -> WKWebViewConfiguration {
        let configuration = WKWebViewConfiguration()
//        configuration.websiteDataStore = .nonPersistent()
        
        return configuration
    }
    
    func start() {
        guard let request = codeGetRequest else { return }
        presenter?.openPage(with: request, delegate: self)
    }
    
    private var codeGetRequest: URLRequest? {
        guard var components = URLComponents(string: Config.GistApi.Url.auth.rawValue) else { return nil }
        
        components.queryItems = [
            URLQueryItem(name: "client_id", value: Config.GistApi.clientId.rawValue),
            URLQueryItem(name: "scope", value: "gist")
        ]
        
        guard let url = components.url else { return nil }
        
        return URLRequest(url: url)
    }
    
    private func tokenGetRequest(code: String) -> URLRequest? {
        guard var urlComponents = URLComponents(string: Config.GistApi.Url.token.rawValue) else { return nil }
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Config.GistApi.clientId.rawValue),
            URLQueryItem(name: "client_secret", value: Config.GistApi.clientSecret.rawValue),
            URLQueryItem(name: "code", value: code),
        ]
        
        guard let url = urlComponents.url else { return nil }
        
        return URLRequest(url: url)
    }
}

extension AuthInteractor: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url,
            url.scheme == Config.GistApi.redirectScheme.rawValue
        {
            let targetString = url.absoluteString.replacingOccurrences(of: "#", with: "?")
            
            guard let components = URLComponents(string: targetString) else { return }
            if let code = components.queryItems?.first(where: { $0.name == "code" })?.value {
                
                guard var request = tokenGetRequest(code: code) else { return }
                request.setValue("application/json", forHTTPHeaderField: "Accept")
                
                let task = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
                    guard let self = self else { return }
                    guard error == nil,
                        let data = data else {
                            self.passToken(token: nil)
                            return
                    }
                    
                    do {
                        let token = try JSONDecoder().decode(Token.self, from: data)
                        self.passToken(token: token.access_token)
                    } catch let error as NSError {
                        print("Error while decode token: \(error)")
                        self.passToken(token: nil)
                    }
                }
                task.resume()
            }
        }
        decisionHandler(.allow)
    }
    
    private func passToken(token: String?) {
        DispatchQueue.main.async {
            self.presenter?.didReceive(token: token)
        }
    }
}

