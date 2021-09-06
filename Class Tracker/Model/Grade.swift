//
//  Grade.swift
//  Class Tracker
//
//  Created by Sidharth Sudhir on 2021-09-06.
//

import Foundation
import RealmSwift

class Grade: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var percentage: Float = 0.0
    var parentSyllabus = LinkingObjects(fromType: Syllabus.self, property: "grades")
}
