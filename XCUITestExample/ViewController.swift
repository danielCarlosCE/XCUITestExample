//
//  ViewController.swift
//  XCUITestExample
//
//  Created by Daniel Carlos on 12/2/17.
//  Copyright © 2017 Daniel Carlos. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var inputSearch: UITextField!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        (segue.destination as! ResultViewController).term = inputSearch.text!
    }


}

class ResultViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    var term: String = ""
    override func viewDidLoad() {
        titleLabel.text = "Result for \(term)"
    }
}

