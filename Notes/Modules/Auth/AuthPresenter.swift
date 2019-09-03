//
//  AuthPresenter.swift
//  Notes
//
//  Created by Jag Stang on 24/08/2019.
//  Copyright © 2019 JagStang. All rights reserved.
//

import Foundation
import WebKit

class AuthPresenter: NSObject, AuthPresenterProtocol {
    
    weak var view: AuthViewProtocol?
    var interactor: AuthInteractorProtocol!
    var router: AuthRouterProtocol!
    
    func viewDidLoad() {
        view?.setupViews(configuration: interactor.getWebViewConfiguration())
        interactor.start()
    }
    
    func openPage(with request: URLRequest, delegate: WKNavigationDelegate) {
        view?.load(request: request, with: delegate)
    }
    
    func didReceive(token: String?) {
        router.presentNotesTable(with: token)
    }
}
