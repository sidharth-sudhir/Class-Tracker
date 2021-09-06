//
//  NewClassViewController.swift
//  Class Tracker
//
//  Created by Sidharth Sudhir on 2021-09-05.
//

import UIKit
import RealmSwift

class NewClassViewController: UIViewController {
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var classNameField: UITextField!
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveButton.clipsToBounds = true
        saveButton.layer.cornerRadius = 15
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        let newSubject = Subject()
        newSubject.name = classNameField.text!
        
        self.save(subject: newSubject)
        
        _ = navigationController?.popViewController(animated: true)
    }
    
    func save(subject: Subject) {
        do {
            try realm.write {
                realm.add(subject)
            }
        } catch {
            print("Error saving subject \(error)")
        }
    }
    
}
