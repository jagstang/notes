//
//  TabRouter.swift
//  Notes
//
//  Created by Jag Stang on 24/08/2019.
//  Copyright © 2019 JagStang. All rights reserved.
//

import UIKit
import CoreData

class TabRouter: TabRouterProtocol {
    
    weak var viewController: UIViewController?
    private var context: NSManagedObjectContext?
    private var token: String?
    
    init(token: String?, context: NSManagedObjectContext) {
        self.token = token
        self.context = context
    }
    
    static func assemble(token: String?, context: NSManagedObjectContext) -> UIViewController {
        let view = TabViewController()
        let presenter = TabPresenter()
        
        let router = TabRouter(token: token, context: context)
        
        view.presenter = presenter
        
        presenter.view = view
        presenter.router = router
        
        router.viewController = view
        
        presenter.viewDidLoad()
        
        return view
    }
    
    func getViewControllers() -> [UIViewController] {
        guard let context = self.context else { return [] }
        
        let token = self.token ?? ""
        let notesVC = NotesTableRouter.assemble(token: token, context: context)
        let notesNavigation = UINavigationController(rootViewController: notesVC)
        let galleryVC = GalleryRouter.assemble()
        let galleryNavigation = UINavigationController(rootViewController: galleryVC)
        
        return [notesNavigation, galleryNavigation]
    }
    
}
