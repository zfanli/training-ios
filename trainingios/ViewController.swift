//
//  ViewController.swift
//  trainingios
//
//  Created by Richard Zeng on 2019/6/14.
//  Copyright © 2019 Richard Zeng. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var todoNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //MARK: Actions
    @IBAction func changeLabelText(_ sender: UIButton) {
        // set to default if text field does not have a value
        if nameTextField.text == "" {
            todoNameLabel.text = "TODOs"
        } else {
            todoNameLabel.text = nameTextField.text
        }
    }
    

}

