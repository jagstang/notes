//
//  NoteExtensionsTests.swift
//  NotesTests
//
//  Created by Jag Stang on 01/07/2019.
//  Copyright © 2019 JagStang. All rights reserved.
//

import XCTest
@testable import Notes

class NoteExtensionsTests: XCTestCase {

    func testNoteParse() {
        XCTAssertNil(Note.parse(json: [:]))
        XCTAssertNil(Note.parse(json: [
            "title": "Some title",
            "content": "..."
        ]))
        
        let uid = "111-222-333"
        let title = "Some title"
        let content = "Some content"
        var json: [String: Any] = [
            "uid": uid,
            "title": title,
            "content": content
        ]
        let note = Note.parse(json: json)!
        XCTAssertEqual(note.uid, uid)
        XCTAssertEqual(note.title, title)
        XCTAssertEqual(note.content, content)
        
        json["importance"] = Importance.high.rawValue
        json["color"] = "#FF0000FF"
        let date = Date()
        json["date"] = date.timeIntervalSince1970
        let note2 = Note.parse(json: json)!
        XCTAssertEqual(note2.uid, uid)
        XCTAssertEqual(note2.title, title)
        XCTAssertEqual(note2.content, content)
        XCTAssertEqual(note2.importance, Importance.high)
        XCTAssertTrue(note2.color.hex == UIColor.red.hex)
        XCTAssertEqual(note2.selfDestructionDate!.timeIntervalSince1970, date.timeIntervalSince1970)
    }
    
    func testNoteToJson() {
        let uid = "111-222-333"
        let title = "Some title"
        let content = "Some content"
        let date = Date()
        let note = Note(
            title: title,
            content: content,
            importance: .high,
            uid: uid,
            color: .red,
            selfDestructionDate: date
        )
        let json = note.json
        XCTAssertEqual(json["uid"] as! String, uid)
        XCTAssertEqual(json["title"] as! String, title)
        XCTAssertEqual(json["content"] as! String, content)
        XCTAssertEqual(json["date"] as! TimeInterval, date.timeIntervalSince1970)
        XCTAssertEqual(json["uid"] as! String, uid)
        XCTAssertEqual(json["importance"] as! String, Importance.high.rawValue)
        XCTAssertEqual(json["color"] as! String, UIColor.red.hex)
        
        let note2 = Note(
            title: title,
            content: content,
            importance: .mid,
            color: .white,
            selfDestructionDate: nil)
        let json2 = note2.json
        XCTAssertNil(json2["importance"])
        XCTAssertNil(json2["color"])
        XCTAssertNil(json2["date"])
    }
    
    func testUIColorInit() {
        XCTAssertNil(UIColor(hex: "SOME_WRONG"))
        XCTAssertNil(UIColor(hex: ""))
        XCTAssertNil(UIColor(hex: "#"))
        XCTAssertNil(UIColor(hex: "#jxk"))
        XCTAssertNil(UIColor(hex: "#jxklukxchlvibuharngb"))
        XCTAssertNil(UIColor(hex: "#FFAADD"))
        
        let whiteHex = UIColor(hex: "#FFFFFFFF")
        XCTAssertTrue(
            getColorComponents(color: whiteHex!) == getColorComponents(color: .white),
            "Colors must by equal with constant"
        )
        
        let whiteHexWrongAlpha = UIColor(hex: "#FFFFFF55")
        XCTAssertFalse(
            getColorComponents(color: whiteHexWrongAlpha!) == getColorComponents(color: .white),
            "Colors must by different with different alpha"
        )
    }
    
    func testUIColorToHex() {
        let whiteConst = UIColor.white
        XCTAssertEqual(whiteConst.hex, "#FFFFFFFF")
        
        let color = UIColor(
            red: 251.0 / 255,
            green: 203.0 / 255,
            blue: 153.0 / 255,
            alpha: 255.0 / 255
        )
        XCTAssertEqual(color.hex, "#FBCB99FF")
    }
    
    private func getColorComponents(color: UIColor) -> (CGFloat, CGFloat, CGFloat, CGFloat) {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        return (r, g, b, a)
    }
}
