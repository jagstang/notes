//
//  ColorPickerPresenter.swift
//  Notes
//
//  Created by Jag Stang on 25/08/2019.
//  Copyright © 2019 JagStang. All rights reserved.
//

import UIKit

class ColorPickerPresenter: ColorPickerPresenterProtocol {
    
    weak var view: ColorPickerViewProtocol?
    var router: ColorPickerRouterProtocol!
    
    var color: UIColor
    
    init(color: UIColor) {
        self.color = color
    }
    
    func viewDidLoad() {
        view?.setupViews(color: color)
    }
    
    func viewDidAppear() {
        view?.initAimPosition(color: color)
    }
    
    func didTapDone(color: UIColor) {
        router.dismiss(with: color)
    }
}
