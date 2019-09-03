//
//  ImagePreviewProtocols.swift
//  Notes
//
//  Created by Jag Stang on 25/08/2019.
//  Copyright © 2019 JagStang. All rights reserved.
//

import UIKit

protocol ImagePreviewRouterProtocol {
    
    static func assemble(images: [UIImage], selectedIndex: Int) -> UIViewController
}

protocol ImagePreviewViewProtocol: class {
    
    func setupViews()
    func showImages(_ images: [UIImage], selectedIndex: Int)
}

protocol ImagePreviewPresenterProtocol: class {
    
    func viewDidLoad()
}
