//
//  NoteEditRouter.swift
//  Notes
//
//  Created by Jag Stang on 25/08/2019.
//  Copyright © 2019 JagStang. All rights reserved.
//

import UIKit
import CoreData

class NoteEditRouter: NoteEditRouterProtocol {
    
    weak var viewController: UIViewController?
    weak var pickerDelegate: ColorPickerDelegate?
    
    static func assemble(
        note: Note,
        token: String,
        gistId: String?,
        notebook: Notebook
    ) -> UIViewController {
        let view = NoteEditViewController()
        let presenter = NoteEditPresenter()
        let interactor = NoteEditInteractor(
            note: note,
            notebook: notebook,
            gistToken: token,
            gistId: gistId,
            backendQueue: OperationQueue(),
            dbQueue: OperationQueue(),
            commonQueue: OperationQueue()
        )
        let router = NoteEditRouter()
        
        view.presenter = presenter
        router.pickerDelegate = presenter
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        
        interactor.presenter = presenter
        
        router.viewController = view
        
        return view
    }
    
    func presentColorPicker(color: UIColor) {
        let colorPicker = ColorPickerRouter.assemble(color: color, delegate: pickerDelegate)
        viewController?.navigationController?.pushViewController(colorPicker, animated: true)
    }
    
    func dismiss() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
