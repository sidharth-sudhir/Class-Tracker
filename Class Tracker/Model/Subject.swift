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
    let syllabus = List<Syllabus>()
}
