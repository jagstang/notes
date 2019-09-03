//
//  NoteEditPresenter.swift
//  Notes
//
//  Created by Jag Stang on 25/08/2019.
//  Copyright © 2019 JagStang. All rights reserved.
//

import UIKit

class NoteEditPresenter: NoteEditPresenterProtocol {
    
    weak var view: NoteEditViewProtocol?
    var interactor: NoteEditInteractorProtocol!
    var router: NoteEditRouterProtocol!
    
    func viewDidLoad() {
        view?.setupViews()
        view?.load(note: interactor.getNote())
    }
    
    func didTapOpenCustomColor() {
        if let color = view?.getCurrentCustomColor() {
            router.presentColorPicker(color: color)
        }
    }
    
    func didTapSaveNote(title: String, content: String, color: UIColor?, date: Date?) {
        interactor.saveNote(title: title, content: content, color: color, date: date)
    }
    
    func didTapCancel() {
        router.dismiss()
    }
    
    func showSaved() {
        router.dismiss()
    }
}

extension NoteEditPresenter: ColorPickerDelegate {
    func colorDidChange(new color: UIColor) {
        view?.updateCustomColor(color)
    }
}
