//
//  NewAuthorCell.swift
//  UniLab
//
//  Created by Тимур Фатыхов on 25/09/2017.
//  Copyright © 2017 Тимур Фатыхов. All rights reserved.
//

import UIKit

class AuthorsCell: UITableViewCell, UITextFieldDelegate
{
    @IBOutlet weak var firstNameTextField: UITextField!
    var textFields : [(field: UITextField, constraint: NSLayoutConstraint)] = []
    
    var correctCharSet = CharacterSet.uppercaseLetters.union(CharacterSet.lowercaseLetters).union(CharacterSet(charactersIn: " ."))
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        firstNameTextField.delegate = self
        
        // create first bottom constraint
        let constraint = firstNameTextField.layoutMarginsGuide.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -21)
        
        constraint.isActive = true
        textFields.append((firstNameTextField, constraint))
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == ""
        {
            return true
        }
        return !CharacterSet(charactersIn: string).intersection(correctCharSet).isEmpty
    }
    
    // MARK: - Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let index = textFields.index()
        {
            (field,constr)->Bool in
            return field == textField
        }
        
        if index != textFields.count - 1
        {
            textFields[Int(index!) + 1].field.becomeFirstResponder()
        }
        else
        {
            textFields.last?.field.resignFirstResponder()
        }
        return true
    }
    
    // MARK: - Methods
    func isFieldEmpty() -> Bool
    {
        for (field,_) in textFields
        {
            if field.text == ""
            {
                return true
            }
        }
        return false
    }
    
    func addAuthor()
    {
        let previousField = textFields.last!.field
        let previousConstr = textFields.last!.constraint
        let newFrame = CGRect(x: previousField.frame.minX, y: previousField.frame.maxY + 8, width: previousField.frame.width, height: previousField.frame.height)
        let newTextField = UITextField(frame: newFrame)

        newTextField.textAlignment = .left
        newTextField.backgroundColor = UIColor.white
        newTextField.placeholder = "Full name"
        newTextField.borderStyle = .roundedRect
        newTextField.font = previousField.font
        newTextField.returnKeyType = .continue
        newTextField.clearButtonMode = .whileEditing
        newTextField.delegate = self

        self.contentView.addSubview(newTextField)
        // delete bottom constraint
        previousConstr.isActive = false

        // add new constraints
        let betweenConstr = previousField.layoutMarginsGuide.bottomAnchor.constraint(equalTo: newTextField.topAnchor, constant: -17)
        betweenConstr.isActive = true
        
        let bottomConstr = newTextField.layoutMarginsGuide.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -21)
        bottomConstr.isActive = true
        
        textFields.append((newTextField, bottomConstr))
    }
    
    func getAuthors() -> [String]
    {
        var authors : [String] = []
        
        for (field,_) in textFields
        {
            authors.append(field.text!)
        }
        return authors
    }

}
