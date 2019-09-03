//
//  NotesTablePresenter.swift
//  Notes
//
//  Created by Jag Stang on 24/08/2019.
//  Copyright © 2019 JagStang. All rights reserved.
//

import UIKit

class NotesTablePresenter: NotesTablePresenterProtocol {

    weak var view: NotesTableViewProtocol?
    var interactor: NotesTableInteractorProtocol!
    var router: NotesTableRouterProtocol!
    
    func viewDidLoad() {
        view?.setupViews()
    }
    
    func viewWillAppear() {
        interactor.loadNotes()
    }
    
    func show(notes: [Note]) {
        view?.show(notes: notes)
    }
    
    func didTapCreateNote() {
        let note = Note(title: "", content: "", importance: .mid)
        router.presentEdit(note: note, gistId: interactor.getGistId())
    }
    
    func didSelectNote(_ note: Note) {
        router.presentEdit(note: note, gistId: interactor.getGistId())
    }
    
    func didDeleteNote(_ note: Note) {
        interactor.deleteNote(note)
    }
}
