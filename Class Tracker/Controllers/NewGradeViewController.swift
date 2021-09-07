//
//  NewGradeViewController.swift
//  Class Tracker
//
//  Created by Sidharth Sudhir on 2021-09-06.
//

import UIKit
import RealmSwift

class NewGradeViewController: UIViewController, DismissingViewController {
    var home: HomeViewController?
    
    var selectedSyllabus: Syllabus?
    let realm = try! Realm()
    
    @IBOutlet weak var gradeName: UITextField!
    @IBOutlet weak var gradeRecieved: UITextField!
    @IBOutlet weak var gradeOutOf: UITextField!
    @IBOutlet weak var gradePercentage: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveButton.clipsToBounds = true
        saveButton.layer.cornerRadius = 10.0
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.notifyComingHome()
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        save()
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func save() {
        if let currentSyllabus = self.selectedSyllabus {
            do {
                try realm.write {
                    let newGrade = Grade()
                    newGrade.title = gradeName.text!
                    
                    if gradeRecieved.text?.count == 0 || gradeOutOf.text?.count == 0 {
                        newGrade.percentage = Float(gradePercentage.text!)!
                    } else {
                        newGrade.percentage = (Float(gradeRecieved.text!)! / Float(gradeOutOf.text!)!) * 100
                    }
                    
                    currentSyllabus.grades.append(newGrade)
                }
            } catch {
                print("Error saving grade: \(error)")
            }
        }
    }
    
}


