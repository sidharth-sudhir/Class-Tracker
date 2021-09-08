//
//  ButtonValidationHelper.swift
//  Class Tracker
//
//  Created by Sidharth Sudhir on 2021-09-07.
//

import Foundation
import UIKit

class ButtonValidationHelper {

  var textFields: [UITextField]!
  var buttons: [UIButton]!

  init(textFields: [UITextField], buttons: [UIButton]) {

    self.textFields = textFields
    self.buttons = buttons

    attachTargetsToTextFields()
    disableButtons()
    checkForEmptyFields()
  }

  //Attach editing changed listeners to all textfields passed in
  private func attachTargetsToTextFields() {
    for textfield in textFields{
        textfield.addTarget(self, action: #selector(textFieldsIsNotEmpty), for: .editingChanged)
    }
  }

  @objc private func textFieldsIsNotEmpty(sender: UITextField) {
    sender.text = sender.text?.trimmingCharacters(in: .whitespaces)
    checkForEmptyFields()
  }


  //Returns true if the field is empty, false if it not
  private func checkForEmptyFields() {

    for textField in textFields{
        guard let textFieldVar = textField.text, !textFieldVar.isEmpty else {
            disableButtons()
            return
        }
    }
    enableButtons()
  }

  private func enableButtons() {
    for button in buttons{
        button.isEnabled = true
    }
  }

  private func disableButtons() {
    for button in buttons{
        button.isEnabled = false
    }
  }

} 
