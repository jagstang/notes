//
//  ColorPickerRouter.swift
//  Notes
//
//  Created by Jag Stang on 25/08/2019.
//  Copyright © 2019 JagStang. All rights reserved.
//

import UIKit

class ColorPickerRouter: ColorPickerRouterProtocol {
    
    weak var viewController: UIViewController?
    weak var delegate: ColorPickerDelegate?
    
    static func assemble(color: UIColor, delegate: ColorPickerDelegate?) -> UIViewController {
        let view = ColorPickerViewController()
        let presenter = ColorPickerPresenter(color: color)
        let router = ColorPickerRouter()
        
        view.presenter = presenter
        
        presenter.view = view
        presenter.router = router
        
        router.viewController = view
        router.delegate = delegate
        
        return view
    }
    
    func dismiss(with newColor: UIColor) {
        delegate?.colorDidChange(new: newColor)
        viewController?.navigationController?.popViewController(animated: true)
    }
}
