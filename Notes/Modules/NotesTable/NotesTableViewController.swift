//
//  NotesTableViewController.swift
//  Notes
//
//  Created by Jag Stang on 19/07/2019.
//  Copyright © 2019 JagStang. All rights reserved.
//

import UIKit
import CoreData

class NotesTableViewController: UITableViewController {
    
    var presenter: NotesTablePresenterProtocol!

    var notes = [Note]()
    
    private let cellIdentifier = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter.viewWillAppear()
    }
    
    @objc public func tapAdd() {
        presenter.didTapCreateNote()
    }
    
    @objc public func tapEdit() {
        tableView.isEditing = !tableView.isEditing
    }
}

extension NotesTableViewController: NotesTableViewProtocol {
    func setupViews() {
        initNavBar()
        initTableView()
    }
    
    func show(notes: [Note]) {
        self.notes = notes
        tableView.reloadData()
    }
    
    private func initNavBar() {
        self.title = "Заметки"
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(tapAdd))
        let edit = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(tapEdit))
        navigationItem.rightBarButtonItem = add
        navigationItem.leftBarButtonItem = edit
    }
    
    private func initTableView() {
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.register(NotesTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.register(UINib(nibName: "NotesTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
    }
}

// Mark: - data source
extension NotesTableViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! NotesTableViewCell
        let note = getNote(by: indexPath)
        
        cell.noteTitleLabel.text = note.title
        cell.noteContentLabel.text = note.content
        cell.noteColorView.backgroundColor = note.color
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    private func getNote(by indexPath: IndexPath) -> Note {
        return notes[notes.count - indexPath.row - 1]
    }
}

// Mark: - delegate
extension NotesTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectNote(getNote(by: indexPath))
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let note = getNote(by: indexPath)
            notes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            presenter.didDeleteNote(note)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
