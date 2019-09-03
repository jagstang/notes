//
//  NotesTableInteractor.swift
//  Notes
//
//  Created by Jag Stang on 24/08/2019.
//  Copyright © 2019 JagStang. All rights reserved.
//

import CoreData

class NotesTableInteractor: NotesTableInteractorProtocol {
    
    weak var presenter: NotesTablePresenterProtocol?
    
    let notebook: Notebook
    let gistToken: String
    let backendQueue: OperationQueue
    let dbQueue: OperationQueue
    let commonQueue: OperationQueue
    
    private var gistId: String?
    
    init(
        notebook: Notebook,
        gistToken: String,
        backendQueue: OperationQueue,
        dbQueue: OperationQueue,
        commonQueue: OperationQueue
    ) {
        self.notebook = notebook
        self.gistToken = gistToken
        self.backendQueue = backendQueue
        self.dbQueue = dbQueue
        self.commonQueue = commonQueue
    }
    
    func loadNotes() {
        let loadOperation = LoadNotesOperation(
            notebook: notebook,
            backendQueue: backendQueue,
            dbQueue: dbQueue,
            token: gistToken
        )
        loadOperation.completionBlock = { [unowned self, unowned loadOperation] in
            self.gistId = loadOperation.gistId
        }
        let updateUiOperation = BlockOperation {
            self.presenter?.show(notes: self.notebook.getList())
        }
        updateUiOperation.addDependency(loadOperation)
        commonQueue.addOperation(loadOperation)
        OperationQueue.main.addOperation(updateUiOperation)
    }
    
    func deleteNote(_ note: Note) {
        let removeOperation = RemoveNoteOperation(
            note: note,
            notebook: notebook,
            backendQueue: backendQueue,
            dbQueue: dbQueue,
            token: gistToken,
            gistId: gistId
        )
        let updateUiOperation = BlockOperation {
            self.presenter?.show(notes: self.notebook.getList())
        }
        updateUiOperation.addDependency(removeOperation)
        commonQueue.addOperation(removeOperation)
        OperationQueue.main.addOperation(updateUiOperation)
    }
    
    func getGistId() -> String? {
        return gistId
    }
}
