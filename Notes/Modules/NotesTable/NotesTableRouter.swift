//
//  NotesTableRouter.swift
//  Notes
//
//  Created by Jag Stang on 24/08/2019.
//  Copyright © 2019 JagStang. All rights reserved.
//

import UIKit
import CoreData

class NotesTableRouter: NotesTableRouterProtocol {
    
    weak var viewController: UIViewController?
    
    let token: String
    let notebook: Notebook
    
    init(token: String, notebook: Notebook) {
        self.token = token
        self.notebook = notebook
    }
    
    static func assemble(token: String, context: NSManagedObjectContext) -> UIViewController {
        let view = NotesTableViewController()
        let presenter = NotesTablePresenter()
        let notebook = DBNotebook(context: context)
        let interactor = NotesTableInteractor(
            notebook: notebook,
            gistToken: token,
            backendQueue: OperationQueue(),
            dbQueue: OperationQueue(),
            commonQueue: OperationQueue()
        )
        let router = NotesTableRouter(token: token, notebook: notebook)
        
        view.presenter = presenter
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        
        interactor.presenter = presenter
        
        router.viewController = view
        
        return view
    }
    
    func presentEdit(note: Note, gistId: String?) {
        let edit = NoteEditRouter.assemble(note: note, token: token, gistId: gistId, notebook: notebook)
        viewController?.navigationController?.pushViewController(edit, animated: true)
    }
}
