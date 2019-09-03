//
//  NotesTableProtocols.swift
//  Notes
//
//  Created by Jag Stang on 24/08/2019.
//  Copyright © 2019 JagStang. All rights reserved.
//

import UIKit
import CoreData

protocol NotesTableRouterProtocol {
    
    static func assemble(token: String, context: NSManagedObjectContext) -> UIViewController
    func presentEdit(note: Note, gistId: String?)
}

protocol NotesTableViewProtocol: class {
    
    func setupViews()
    func show(notes: [Note])
}

protocol NotesTablePresenterProtocol: class {
    
    func viewDidLoad()
    func viewWillAppear()
    func show(notes: [Note])
    func didTapCreateNote()
    func didSelectNote(_ note: Note)
    func didDeleteNote(_ note: Note)
}

protocol NotesTableInteractorProtocol {
    
    func loadNotes()
    func deleteNote(_ note: Note)
    func getGistId() -> String?
}
