//
//  NotebookProtocol.swift
//  Notes
//
//  Created by Jag Stang on 17/08/2019.
//  Copyright © 2019 JagStang. All rights reserved.
//

import Foundation

protocol Notebook {
    func getList() -> [Note]
    func add(_ note: Note)
    func remove(with uid: String)
    func update(by notes: [Note])
    func save()
    func load()
}
