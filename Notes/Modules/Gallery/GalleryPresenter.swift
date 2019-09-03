//
//  GalleryPresenter.swift
//  Notes
//
//  Created by Jag Stang on 24/08/2019.
//  Copyright © 2019 JagStang. All rights reserved.
//

import UIKit

class GalleryPresenter: GalleryPresenterProtocol {

    weak var view: GalleryViewProtocol?
    var interactor: GalleryInteractorProtocol!
    var router: GalleryRouterProtocol!
    
    func viewDidLoad() {
        view?.setupViews()
        interactor.loadImages()
    }

    func showImages(_ images: [UIImage]) {
        view?.showImages(images)
    }

    func addImage(_ image: UIImage?) {
        if let image = image {
            view?.addImage(image)
        }
        router.dismissImagePicker()
    }
    
    func didTapAddImage() {
        router.presentImagePicker(delegate: interactor)
    }
    
    func didSelect(path: IndexPath, in images: [UIImage]) {
        router.presentImagePreview(images: images, path: path)
    }
}
