//
//  ViewController.swift
//  Clima
//
//  Created by sky on 1/1/22.
//

import UIKit

class WeatherViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTextField.delegate = self
    }

    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
        print(searchTextField.text!)
    }
    
    // this func will be executed when user tap enter or tap on simulator return keyboard. We
    // have this func when we conform UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(searchTextField.text!)
        searchTextField.endEditing(true)
        return true
    }
    
    // when user finish editing the textField. it will work for both searchPressed and textFiledShouldReturn.
    // instead of reset text into empty string in both funcs above, we reset it here to avoid repeat code
    func textFieldDidEndEditing(_ textField: UITextField) {
        searchTextField.text = ""
        searchTextField.placeholder = "Search"
    }
    
    
    // this func will validate text in textField. If it returns true, the func textFieldDidEndEditing will be triggered
    // if it returns false, the func textFieldDidEndEditing will not be triggered
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type something"
            return false
        }
    }
}

