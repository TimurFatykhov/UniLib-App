//
//  NewBookCell.swift
//  UniLab
//
//  Created by Тимур Фатыхов on 25/09/2017.
//  Copyright © 2017 Тимур Фатыхов. All rights reserved.
//

import UIKit

class BookInfoCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var genreTextField: UITextField!
    @IBOutlet weak var yearTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var idTextField: UITextField!
    
    var characterSet = CharacterSet.uppercaseLetters.union(CharacterSet.lowercaseLetters).union(CharacterSet(charactersIn: "1234567890 -№"))
    var numberSet = CharacterSet(charactersIn: "1234567890")
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        nameTextField.delegate = self
        genreTextField.delegate = self
        yearTextField.delegate = self
        amountTextField.delegate = self
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == ""
        {
            return true
        }
        switch (textField)
        {
        case nameTextField, genreTextField:
            return !CharacterSet(charactersIn: string).intersection(characterSet).isEmpty
        case yearTextField, amountTextField:
            return !CharacterSet(charactersIn: string).intersection(numberSet).isEmpty
        default:
            return true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField
        {
        case nameTextField:
            genreTextField.becomeFirstResponder()
            
        case genreTextField:
            yearTextField.becomeFirstResponder()
            
        case yearTextField:
            amountTextField.becomeFirstResponder()
            
        case amountTextField:
            amountTextField.resignFirstResponder()
        default:
            break
        }
        return false
    }
    
    func isFieldEmpty() -> Bool
    {
        if nameTextField.text == "" || genreTextField.text == "" || yearTextField.text == "" || amountTextField.text == ""
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    func yearIsCorrect() -> Bool
    {
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        
        if Int(yearTextField.text!)! <= components.year!
        {
            return true
        }
        else
        {
            return false
        }
    }
}
