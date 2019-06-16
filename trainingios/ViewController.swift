//
//  ViewController.swift
//  trainingios
//
//  Created by Richard Zeng on 2019/6/14.
//  Copyright © 2019 Richard Zeng. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var todoNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Handle the text field’s user input through delegate callbacks.
        nameTextField.delegate = self
    }
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        todoNameLabel.text = textField.text
    }
    
    //MARK: Actions
    @IBAction func resetLabelName(_ sender: UIButton) {
        todoNameLabel.text = "TODOs"
    }
    
}

