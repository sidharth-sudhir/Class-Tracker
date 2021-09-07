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
    @IBOutlet weak var warningMessage: UILabel!
    
    
    var selectedSubject: Subject? {
        didSet {
            loadSyllabusItems()
        }
    }
    
    func verifySumOfWeights() {
        var sum: Float = 0.0
        for syllabus in syllabusItems! {
            sum += syllabus.weight
        }
        
        if sum == 100 {
            warningMessage.text = "Sum of all syllabus items is 100%"
            warningMessage.textColor = #colorLiteral(red: 0.9545845389, green: 0.8008846641, blue: 0, alpha: 1)
        } else {
            warningMessage.text = "Sum of all syllabus items is \(String(format: "%.1f", sum))%, not 100%"
            warningMessage.textColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        verifySumOfWeights()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = selectedSubject?.name
        updateSyllabusGrade()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return syllabusItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let syllabusItem = syllabusItems?[indexPath.row] {
            cell.textLabel?.text = syllabusItem.title
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 25.0)
            if syllabusItem.syllabusGrade == -1.0 {
                cell.detailTextLabel?.text = "-- / " + String(format: "%.1f", syllabusItem.weight) + " - ??%"
            } else {
                cell.detailTextLabel?.text = String(format: "%.1f", syllabusItem.syllabusGrade) + " / " + String(format: "%.1f", syllabusItem.weight) + String(format: " - %.1f", syllabusItem.syllabusGrade/syllabusItem.weight * 100) + "%"
            }
            cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 15.0)
            cell.detailTextLabel?.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            cell.textLabel?.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            cell.backgroundColor = #colorLiteral(red: 0.9930666089, green: 0.9932323098, blue: 0.9930446744, alpha: 1)
        } else {
            cell.textLabel?.text = "No Syllabus Iteams Added"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToGrades", sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! GradeListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedSyllabus = syllabusItems?[indexPath.row]
        }
    }
    
    func loadSyllabusItems() {
        syllabusItems = selectedSubject?.syllabus.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
        verifySumOfWeights()
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
        
        verifySumOfWeights()
        updateSubjectGrade()
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
                        newSyllabus.syllabusGrade = Float(weightTextField.text!)!
                        currentSubject.syllabus.append(newSyllabus)
                    }
                } catch {
                    print("Error saving syllabus: \(error)")
                }
            }
            
            self.verifySumOfWeights()
            self.updateSyllabusGrade()
        }
        
        alert.addTextField { alertTextField in
            titleTextField = alertTextField
            titleTextField.autocapitalizationType = .words
            titleTextField.placeholder = "Create new syllabus item (i.e Tests)"
        }
        
        alert.addTextField { alertTextField in
            weightTextField = alertTextField
            weightTextField.keyboardType = .decimalPad
            weightTextField.placeholder = "Enter weight of syllabus item (i.e 35)"
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    func updateSyllabusGrade() {
        for syllabusItem in syllabusItems! {
            var totalGrade: Float = 0.0
            var counter:Float = 0
            
            for grade in syllabusItem.grades {
                counter += 1
                totalGrade += grade.percentage
            }
            
            var weightedGrade: Float = -1.0
            if counter > 0 {
                weightedGrade = (totalGrade/counter)/100 * syllabusItem.weight
            }
            
            do {
                try realm.write {
                    syllabusItem.syllabusGrade = weightedGrade
                }
            } catch {
                print("Error updating syllabus grade: \(error)")
            }
        }
        
        updateSubjectGrade()
        
        tableView.reloadData()
    }
    
    func updateSubjectGrade() {
        var finalGrade: Float = 0.0
        var syllabusWeights: Float = 0.0
        if syllabusItems!.count == 0 {
            finalGrade = 100.0
            syllabusWeights = 100.0
        } else {
            for syllabusItem in syllabusItems! {
                if syllabusItem.syllabusGrade != -1.0 {
                    syllabusWeights += syllabusItem.weight
                    finalGrade += syllabusItem.syllabusGrade
                }
            }
        }
        
        do {
            try realm.write {
                selectedSubject?.subjectGrade = syllabusWeights != 0 ? finalGrade/syllabusWeights * 100 : 100.0
            }
        } catch {
            print("Error saving final grade: \(error)")
        }
        
        gradeLabel.text = String(format: "%.2f", selectedSubject!.subjectGrade) + "%"
    }
}
