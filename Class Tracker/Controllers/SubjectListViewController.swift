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
    
    var gradeImages = [#imageLiteral(resourceName: "LetterAPlus"), #imageLiteral(resourceName: "LetterA"), #imageLiteral(resourceName: "LetterAMinus"), #imageLiteral(resourceName: "LetterBPlus"), #imageLiteral(resourceName: "LetterB"), #imageLiteral(resourceName: "LetterBMinus"), #imageLiteral(resourceName: "LetterCPlus"), #imageLiteral(resourceName: "LetterC"), #imageLiteral(resourceName: "LetterCMinus"), #imageLiteral(resourceName: "LetterDPlus"), #imageLiteral(resourceName: "LetterD"), #imageLiteral(resourceName: "LetterDMinus"), #imageLiteral(resourceName: "LetterF"), #imageLiteral(resourceName: "Question")]
    
    var subjects: Results<Subject>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSubjects()
        tableView.separatorStyle = .singleLine
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
            cell.textLabel?.font = UIFont.systemFont(ofSize: 25.0, weight: .semibold)
            cell.detailTextLabel?.text = String(format: "%.0f", subject.subjectGrade) + "%"
            cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 15.0)
            cell.imageView?.image = getLetterGrade(currentGrade: subject.subjectGrade)
            cell.detailTextLabel?.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            cell.backgroundColor = #colorLiteral(red: 0.9930666089, green: 0.9932323098, blue: 0.9930446744, alpha: 1)
            cell.textLabel?.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToSyllabus", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! SyllabusListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedSubject = subjects?[indexPath.row]
        }
    }
    
    func save(subject: Subject) {
        do {
            try realm.write {
                realm.add(subject)
            }
        } catch {
            print("Error saving subject \(error)")
        }
        
        tableView.reloadData()
    }
    
    @IBAction func addSubjectPressed(_ sender: Any) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Class", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newSubject = Subject()
            newSubject.name = textField.text!
            
            self.save(subject: newSubject)
        }
        
        alert.addAction(action)
        
        alert.addTextField { (field) in
            textField = field
            textField.autocapitalizationType = .words
            textField.placeholder = "Add a new Subject (i.e Math)"
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    
    func loadSubjects() {
        subjects  = realm.objects(Subject.self)
    
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let subjectForDeletion = self.subjects?[indexPath.row] {
            do {
                try self.realm.write {
                    for subject in subjectForDeletion.syllabus {
                        for grade in subject.grades {
                            self.realm.delete(grade)
                        }
                        self.realm.delete(subject)
                    }
                    self.realm.delete(subjectForDeletion)
                }
            } catch {
                print("Error deleting subject, \(error)")
            }
        }
    }
    
    func getLetterGrade(currentGrade: Float) -> UIImage {
        switch currentGrade {
        case _ where currentGrade >= 95.0:
            return gradeImages[0]
        case _ where currentGrade >= 87.0:
            return gradeImages[1]
        case _ where currentGrade >= 80.0:
            return gradeImages[2]
        case _ where currentGrade >= 77.0:
            return gradeImages[3]
        case _ where currentGrade >= 73.0:
            return gradeImages[4]
        case _ where currentGrade >= 70.0:
            return gradeImages[5]
        case _ where currentGrade >= 67.0:
            return gradeImages[6]
        case _ where currentGrade >= 63.0:
            return gradeImages[7]
        case _ where currentGrade >= 60.0:
            return gradeImages[8]
        case _ where currentGrade >= 57.0:
            return gradeImages[9]
        case _ where currentGrade >= 53.0:
            return gradeImages[10]
        case _ where currentGrade >= 50.0:
            return gradeImages[11]
        case _ where currentGrade >= 0.0:
            return gradeImages[12]
        default:
            return gradeImages[13]
        }
    }
}

