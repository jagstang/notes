//
//  AuthRouter.swift
//  Notes
//
//  Created by Jag Stang on 23/08/2019.
//  Copyright © 2019 JagStang. All rights reserved.
//

import UIKit
import CoreData

class AuthRouter: AuthRouterProtocol {
    
    weak var viewController: UIViewController?
    private var context: NSManagedObjectContext?
    
    static func assemble(context: NSManagedObjectContext) -> UIViewController {
        let view = AuthViewController()
        let presenter = AuthPresenter()
        let interactor = AuthInteractor()
        let router = AuthRouter()
        router.context = context
        
        view.presenter = presenter
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        
        interactor.presenter = presenter
        
        router.viewController = view
        
        return view
    }
    
    func presentNotesTable(with token: String?) {
        guard let context = context else { return }
        
        let tabViewController = TabRouter.assemble(token: token, context: context)
        viewController?.present(tabViewController, animated: false, completion: nil)
    }
}
