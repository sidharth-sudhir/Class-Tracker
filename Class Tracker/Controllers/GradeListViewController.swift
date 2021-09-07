//
//  GradeListViewController.swift
//  Class Tracker
//
//  Created by Sidharth Sudhir on 2021-09-06.
//

import UIKit
import RealmSwift

protocol HomeViewController : AnyObject {
    func comingHome()
}

protocol DismissingViewController : AnyObject {
    var home : HomeViewController? {get set}
}

extension DismissingViewController where Self : UIViewController {
    func notifyComingHome() {
        if self.isBeingDismissed || self.isMovingFromParent {
            self.home?.comingHome()
        }
    }
}

class GradeListViewController: SwipeTableViewController, HomeViewController {
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
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 25.0)
            cell.detailTextLabel?.text = String(format: "%.1f", grade.percentage) + "%"
            cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 15.0)
            cell.detailTextLabel?.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
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
    
    @IBAction func addNewGradePressed(_ sender: Any) {
        performSegue(withIdentifier: "goToCreateGrade", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! NewGradeViewController
        destinationVC.selectedSyllabus = selectedSyllabus
        destinationVC.home = self
    }
    
    func comingHome() {
        tableView.reloadData()
    }
    
}
