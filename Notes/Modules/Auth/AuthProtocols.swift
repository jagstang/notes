//
//  AuthProtocols.swift
//  Notes
//
//  Created by Jag Stang on 23/08/2019.
//  Copyright © 2019 JagStang. All rights reserved.
//

import UIKit
import WebKit
import CoreData

protocol AuthRouterProtocol {
    
    static func assemble(context: NSManagedObjectContext) -> UIViewController
    func presentNotesTable(with token: String?)
}

protocol AuthViewProtocol: class {
    
    func setupViews(configuration: WKWebViewConfiguration)
    func load(request: URLRequest, with delegate: WKNavigationDelegate)
}

protocol AuthPresenterProtocol: class {
    
    func viewDidLoad()
    func openPage(with request: URLRequest, delegate: WKNavigationDelegate)
    func didReceive(token: String?)
}

protocol AuthInteractorProtocol {
    
    func getWebViewConfiguration() -> WKWebViewConfiguration
    func start()
}
