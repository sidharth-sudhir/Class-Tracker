//
//  ViewController.swift
//  Class Tracker
//
//  Created by Sidharth Sudhir on 2021-08-28.
//

import UIKit
import RealmSwift

class SubjectListViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var subjects: Results<Subject>?
    
    @IBOutlet weak var addClassButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadSubjects()
        
        addClassButton.clipsToBounds = true
        addClassButton.layer.cornerRadius = 25
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subjects?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let subject = subjects?[indexPath.row] {
            cell.textLabel?.text = subject.name
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToSyllabus", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if sender as? NSObject != self.addClassButton {
            let destinationVC = segue.destination as! SyllabusListViewController
            
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.selectedSubject = subjects?[indexPath.row]
            }   
        }
    }
    
    
    func loadSubjects() {
        subjects  = realm.objects(Subject.self)
    
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let subjectForDeletion = self.subjects?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(subjectForDeletion)
                }
            } catch {
                print("Error deleting subject, \(error)")
            }
        }
    }
}

