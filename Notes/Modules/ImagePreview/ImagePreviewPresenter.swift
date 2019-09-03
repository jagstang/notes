//
//  ImagePreviewPresenter.swift
//  Notes
//
//  Created by Jag Stang on 25/08/2019.
//  Copyright © 2019 JagStang. All rights reserved.
//

import UIKit

class ImagePreviewPresenter: ImagePreviewPresenterProtocol {
    
    weak var view: ImagePreviewViewProtocol?
    var router: ImagePreviewRouterProtocol!
    
    var images: [UIImage]
    var selectedIndex: Int
    
    init(images: [UIImage], selectedIndex: Int) {
        self.images = images
        self.selectedIndex = selectedIndex
    }
    
    func viewDidLoad() {
        view?.setupViews()
        view?.showImages(images, selectedIndex: selectedIndex)
    }
}
