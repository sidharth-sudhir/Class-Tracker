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

    @IBOutlet weak var gradeLabel: UILabel!
    
    
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
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return syllabusItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let syllabusItem = syllabusItems?[indexPath.row] {
            cell.textLabel?.text = syllabusItem.title
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 25.0)
            cell.detailTextLabel?.text = String(format: "%.1f", syllabusItem.weight)
            cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 15.0)
            cell.detailTextLabel?.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
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
    
    @IBAction func addSyllabusItemPressed(_ sender: UIBarButtonItem) {
        var titleTextField = UITextField()
        var weightTextField = UITextField()
        
        let alert = UIAlertController(title: "Add New Syllabus Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Syllabus Item", style: .default) { (action) in
            if let currentSubject = self.selectedSubject {
                do {
                    try self.realm.write {
                        let newSyllabus = Syllabus()
                        newSyllabus.title = titleTextField.text!
                        newSyllabus.weight = Float(weightTextField.text!)!
                        currentSubject.syllabus.append(newSyllabus)
                    }
                } catch {
                    print("Error saving syllabus: \(error)")
                }
            }
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { alertTextField in
            titleTextField = alertTextField
            titleTextField.placeholder = "Create new syllabus item (i.e Tests)"
        }
        
        alert.addTextField { alertTextField in
            weightTextField = alertTextField
            weightTextField.placeholder = "Enter weight of syllabus item (i.e 35)"
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
}
