//
//  GradeListViewController.swift
//  Class Tracker
//
//  Created by Sidharth Sudhir on 2021-09-06.
//

import UIKit
import RealmSwift

class GradeListViewController: SwipeTableViewController {
    var grades: Results<Grade>?
    let realm = try! Realm()
    
    var selectedSyllabus: Syllabus? {
        didSet {
            loadGrades()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = selectedSyllabus?.title
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return grades?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let grade = grades?[indexPath.row] {
            cell.textLabel?.text = grade.title
        }
        
        return cell
    }
    
    func loadGrades() {
        grades = selectedSyllabus?.grades.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let grade = grades?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(grade)
                }
            } catch {
                print("Error deleting grade: \(error)")
            }
        }
    }
}
