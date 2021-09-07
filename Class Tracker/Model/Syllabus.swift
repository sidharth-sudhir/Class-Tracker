//
//  Syllabus.swift
//  Class Tracker
//
//  Created by Sidharth Sudhir on 2021-09-05.
//

import Foundation
import RealmSwift

class Syllabus: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var weight: Float = 0.0
    @objc dynamic var syllabusGrade: Float = 0.0
    let grades = List<Grade>()
    var parentSubject = LinkingObjects(fromType: Subject.self, property: "syllabus")
}
