//
//  ColorPickerProtocols.swift
//  Notes
//
//  Created by Jag Stang on 25/08/2019.
//  Copyright © 2019 JagStang. All rights reserved.
//

import UIKit

protocol ColorPickerRouterProtocol {
    
    static func assemble(color: UIColor, delegate: ColorPickerDelegate?) -> UIViewController
    func dismiss(with newColor: UIColor)
}

protocol ColorPickerViewProtocol: class {
    func setupViews(color: UIColor)
    func initAimPosition(color: UIColor)
}

protocol ColorPickerPresenterProtocol: class {
    
    func viewDidLoad()
    func viewDidAppear()
    func didTapDone(color: UIColor)
}

protocol ColorPickerDelegate: class {
    
    func colorDidChange(new color: UIColor)
}
