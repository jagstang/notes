//
//  GalleryRouter.swift
//  Notes
//
//  Created by Jag Stang on 24/08/2019.
//  Copyright © 2019 JagStang. All rights reserved.
//

import UIKit

class GalleryRouter: GalleryRouterProtocol {
    
    let imagePicker = UIImagePickerController()
    weak var viewController: UIViewController?
    
    static func assemble() -> UIViewController {
        let view = GalleryViewController(collectionViewLayout: UICollectionViewFlowLayout())
        let presenter = GalleryPresenter()
        let interactor = GalleryInteractor()
        let router = GalleryRouter()
        
        view.presenter = presenter
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        
        interactor.presenter = presenter
        
        router.viewController = view
        
        return view
    }
    
    func presentImagePicker(delegate: ImagePickerDelegate) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = delegate

        viewController?.present(imagePicker, animated: true, completion: nil)
    }
    
    func dismissImagePicker() {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func presentImagePreview(images: [UIImage], path: IndexPath) {
        let imagePreview = ImagePreviewRouter.assemble(images: images, selectedIndex: path.row)
        viewController?.navigationController?.pushViewController(imagePreview, animated: true)
    }
}
