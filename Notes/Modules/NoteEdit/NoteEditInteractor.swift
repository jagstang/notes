//
//  NoteEditInteractor.swift
//  Notes
//
//  Created by Jag Stang on 25/08/2019.
//  Copyright © 2019 JagStang. All rights reserved.
//

import Foundation
import UIKit

class NoteEditInteractor: NoteEditInteractorProtocol {
    
    weak var presenter: NoteEditPresenterProtocol?
    
    let note: Note
    let notebook: Notebook
    let gistToken: String
    let gistId: String?
    let backendQueue: OperationQueue
    let dbQueue: OperationQueue
    let commonQueue: OperationQueue
    
    init(
        note: Note,
        notebook: Notebook,
        gistToken: String,
        gistId: String?,
        backendQueue: OperationQueue,
        dbQueue: OperationQueue,
        commonQueue: OperationQueue
    ) {
        self.note = note
        self.notebook = notebook
        self.gistToken = gistToken
        self.gistId = gistId
        self.backendQueue = backendQueue
        self.dbQueue = dbQueue
        self.commonQueue = commonQueue
    }
    
    func getNote() -> Note {
        return note
    }
    
    func saveNote(title: String, content: String, color: UIColor?, date: Date?) {
        let note = Note(
            title: title,
            content: content,
            importance: self.note.importance,
            uid: self.note.uid,
            color: color,
            selfDestructionDate: date
        )
        
        let saveOperation = SaveNoteOperation(
            note: note,
            notebook: notebook,
            backendQueue: backendQueue,
            dbQueue: dbQueue,
            token: gistToken,
            gistId: gistId
        )
        let updateUiOperation = BlockOperation {
            self.presenter?.showSaved()
        }
        updateUiOperation.addDependency(saveOperation)
        commonQueue.addOperation(saveOperation)
        OperationQueue.main.addOperation(updateUiOperation)
    }
}
