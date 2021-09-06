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
    var parentSubject = LinkingObjects(fromType: Subject.self, property: "syllabus")
}
