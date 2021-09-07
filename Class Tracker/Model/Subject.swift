//
//  Class.swift
//  Class Tracker
//
//  Created by Sidharth Sudhir on 2021-09-05.
//

import Foundation
import RealmSwift

class Subject: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var subjectGrade: Float = 100.0
    let syllabus = List<Syllabus>()
}
