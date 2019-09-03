//
//  TabPresenter.swift
//  Notes
//
//  Created by Jag Stang on 24/08/2019.
//  Copyright © 2019 JagStang. All rights reserved.
//

class TabPresenter: TabPresenterProtocol {
    weak var view: TabViewProtocol?
    var router: TabRouterProtocol!
    
    func viewDidLoad() {
        view?.show(controllers: router.getViewControllers())
    }
}
