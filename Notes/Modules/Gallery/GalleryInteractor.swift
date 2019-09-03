//
//  GalleryInteractor.swift
//  Notes
//
//  Created by Jag Stang on 24/08/2019.
//  Copyright © 2019 JagStang. All rights reserved.
//

import UIKit

class GalleryInteractor: NSObject, GalleryInteractorProtocol {
    
    weak var presenter: GalleryPresenterProtocol?
    
    func loadImages() {
        presenter?.showImages([
            UIImage(named: "one")!,
            UIImage(named: "two")!,
            UIImage(named: "three")!,
            UIImage(named: "four")!,
            UIImage(named: "five")!
        ])
    }
}

extension GalleryInteractor: ImagePickerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        presenter?.addImage(pickedImage)
    }
}
