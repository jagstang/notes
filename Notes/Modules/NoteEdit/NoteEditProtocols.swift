//
//  NoteEditProtocols.swift
//  Notes
//
//  Created by Jag Stang on 25/08/2019.
//  Copyright © 2019 JagStang. All rights reserved.
//

import UIKit

protocol NoteEditRouterProtocol {
    
    static func assemble(
        note: Note,
        token: String,
        gistId: String?,
        notebook: Notebook
    ) -> UIViewController
    
    func presentColorPicker(color: UIColor)
    func dismiss()
}

protocol NoteEditViewProtocol: class {
    
    func setupViews()
    func load(note: Note)
    func getCurrentCustomColor() -> UIColor
    func updateCustomColor(_ color: UIColor)
}

protocol NoteEditPresenterProtocol: ColorPickerDelegate {
    
    func viewDidLoad()
    func showSaved()
    func didTapOpenCustomColor()
    func didTapSaveNote(title: String, content: String, color: UIColor?, date: Date?)
    func didTapCancel()
}

protocol NoteEditInteractorProtocol {
    
    func getNote() -> Note
    func saveNote(title: String, content: String, color: UIColor?, date: Date?)
}
