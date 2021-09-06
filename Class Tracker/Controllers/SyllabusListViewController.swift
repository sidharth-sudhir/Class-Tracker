//
//  SyllabusListViewController.swift
//  Class Tracker
//
//  Created by Sidharth Sudhir on 2021-09-05.
//

import UIKit
import RealmSwift

class SyllabusListViewController: SwipeTableViewController {

    var syllabusItems: Results<Syllabus>?
    let realm = try! Realm()

    var selectedSubject: Subject? {
        didSet {
            loadSyllabusItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = selectedSubject?.name
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return syllabusItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let syllabusItem = syllabusItems?[indexPath.row] {
            cell.textLabel?.text = syllabusItem.title
        } else {
            cell.textLabel?.text = "No Syllabus Iteams Added"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Syllabus Item was selected. The index was simply: \(indexPath.row)")
    }
    
    func loadSyllabusItems() {
        syllabusItems = selectedSubject?.syllabus.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let syllabus = syllabusItems?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(syllabus)
                }
            } catch {
                print("Error deleting syllabus, \(error)")
            }
        }
    }
}
