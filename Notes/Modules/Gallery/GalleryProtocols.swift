//
//  GalleryProtocols.swift
//  Notes
//
//  Created by Jag Stang on 24/08/2019.
//  Copyright © 2019 JagStang. All rights reserved.
//

import UIKit

protocol GalleryRouterProtocol {
    
    static func assemble() -> UIViewController
    func presentImagePicker(delegate: ImagePickerDelegate)
    func dismissImagePicker()
    func presentImagePreview(images: [UIImage], path: IndexPath)
}

protocol GalleryViewProtocol: class {
    
    func setupViews()
    func showImages(_ images: [UIImage])
    func addImage(_ image: UIImage)
}

protocol GalleryPresenterProtocol: class {
    
    func viewDidLoad()
    func showImages(_ images: [UIImage])
    func addImage(_ image: UIImage?)
    func didTapAddImage()
    func didSelect(path: IndexPath, in images: [UIImage])
}

protocol GalleryInteractorProtocol: ImagePickerDelegate {
    func loadImages()
}

protocol ImagePickerDelegate: UIImagePickerControllerDelegate, UINavigationControllerDelegate {}
