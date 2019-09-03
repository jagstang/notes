//
//  FileNotebookTests.swift
//  NotesTests
//
//  Created by Jag Stang on 01/07/2019.
//  Copyright © 2019 JagStang. All rights reserved.
//

import XCTest
@testable import Notes

class FileNotebookTests: XCTestCase {

    func testAddAndRemove() {
        //add
        let note1 = Note(title: "note1", content: "content1", importance: .mid)
        let note2 = Note(title: "note2", content: "content2", importance: .mid)
        let note3 = Note(title: "note3", content: "content3", importance: .mid)
        let notebook = FileNotebook()
        notebook.add(note1)
        notebook.add(note2)
        notebook.add(note3)
        XCTAssertEqual(notebook.getList().count, 3)
        XCTAssertEqual(notebook.getList()[0].uid, note1.uid)
        XCTAssertEqual(notebook.getList()[1].uid, note2.uid)
        XCTAssertEqual(notebook.getList()[2].uid, note3.uid)
        
        notebook.add(note1)
        XCTAssertEqual(notebook.getList().count, 3)
        
        //remove
        notebook.remove(with: note1.uid)
        XCTAssertEqual(notebook.getList().count, 2)
        for note in notebook.getList() {
            XCTAssertNotEqual(note.uid, note1.uid)
        }
        
        let note4 = Note(title: "note4", content: "content4", importance: .mid)
        notebook.remove(with: note4.uid)
        XCTAssertEqual(notebook.getList().count, 2)
    }

    func testSaveAndLoad() {
        //save
        let note1 = Note(title: "note1", content: "content1", importance: .mid)
        let note2 = Note(title: "note2", content: "content2", importance: .mid)
        let note3 = Note(title: "note3", content: "content3", importance: .mid)
        let notebook = FileNotebook()
        notebook.add(note1)
        notebook.add(note2)
        notebook.add(note3)
        notebook.save()
        
        //load
        let notebookRestore = FileNotebook()
        notebookRestore.load()
        XCTAssertEqual(notebook.getList().count, 3)
        XCTAssertEqual(notebook.getList()[0].uid, note1.uid)
        XCTAssertEqual(notebook.getList()[1].uid, note2.uid)
        XCTAssertEqual(notebook.getList()[2].uid, note3.uid)
    }
}
