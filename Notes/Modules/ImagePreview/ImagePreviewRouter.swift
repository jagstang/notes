//
//  ImagePreviewRouter.swift
//  Notes
//
//  Created by Jag Stang on 24/08/2019.
//  Copyright © 2019 JagStang. All rights reserved.
//

import UIKit

class ImagePreviewRouter: ImagePreviewRouterProtocol {
    
    weak var viewController: UIViewController?
    
    static func assemble(images: [UIImage], selectedIndex: Int) -> UIViewController {
        let view = ImagePreviewController()
        let presenter = ImagePreviewPresenter(images: images, selectedIndex: selectedIndex)
        let router = ImagePreviewRouter()
        
        view.presenter = presenter
        
        presenter.view = view
        presenter.router = router
        
        router.viewController = view
        
        return view
    }
}
