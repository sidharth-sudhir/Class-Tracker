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
        
        self.view.clipsToBounds = true
        self.view.layer.cornerRadius = 10.0
        
        setupAddTargetIsNotEmptyTextFields()
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
    
    func setupAddTargetIsNotEmptyTextFields() {
        saveButton.isEnabled = false
        saveButton.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        gradeName.addTarget(self, action: #selector(textFieldsIsNotEmpty),
                                    for: .editingChanged)
        gradePercentage.addTarget(self, action: #selector(textFieldsIsNotEmpty),
                                    for: .editingChanged)
        gradeRecieved.addTarget(self, action: #selector(textFieldsIsNotEmpty),
                                    for: .editingChanged)
        gradeOutOf.addTarget(self, action: #selector(textFieldsIsNotEmpty),
                                    for: .editingChanged)
    }
    
    @objc func textFieldsIsNotEmpty(sender: UITextField) {
        guard
            let name = gradeName.text,
            let percentage = gradePercentage.text,
            let recieved = gradeRecieved.text,
            let outOf = gradeOutOf.text,
            !name.isEmpty,
            percentage.isValidNumber || (recieved.isValidNumber && outOf.isValidDenominator)
        else {
            saveButton.isEnabled = false
            saveButton.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            return
        }
        saveButton.isEnabled = true
        saveButton.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
    }
    
}

extension String {
    var isValidNumber: Bool {
        let num = Float(self)
        return num != nil && num! >= 0.0
    }
    
    var isValidDenominator: Bool {
        let num = Float(self)
        return num != nil && num! > 0.0
    }
}
