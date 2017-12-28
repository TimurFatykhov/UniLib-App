//
//  NewBoolViewController.swift
//  UniLab
//
//  Created by Тимур Фатыхов on 13/09/2017.
//  Copyright © 2017 Тимур Фатыхов. All rights reserved.
//

import UIKit
import Alamofire

class NewBookViewController: UITableViewController, UITextFieldDelegate
{
    var bookInfoCell : BookInfoCell!
    var authorsCell : AuthorsCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        bookInfoCell = tableView.dequeueReusableCell(withIdentifier: "bookInfo") as! BookInfoCell
        bookInfoCell.selectionStyle = .none
        
        authorsCell = tableView.dequeueReusableCell(withIdentifier: "authors") as! AuthorsCell
        authorsCell.selectionStyle = .none
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        print(indexPath.row)
        switch(indexPath.row)
        {
        case 0:
            return bookInfoCell
        
        case 1:
            return authorsCell
            
        default:
            let addAuthorCell = tableView.dequeueReusableCell(withIdentifier: "addAuthor")!
            addAuthorCell.selectionStyle = .none
            return addAuthorCell
        }
    }
    
    func allFieldsNotEmpty() -> Bool
    {
        return !authorsCell.isFieldEmpty() && !bookInfoCell.isFieldEmpty()
    }
    
    //MARK: - UI interactions
    @IBAction func addAuthorTapped(_ sender: UIButton)
    {
        tableView.beginUpdates()
        authorsCell.addAuthor()
        tableView.endUpdates()
    }
    
    @IBAction func cancellTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        if allFieldsNotEmpty()
        {
            if bookInfoCell.yearIsCorrect()
            {
                addBookRequest()
            }
            else
            {
                    let alert = UIAlertController(title: "I think...", message: "Year is incorrect", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Uno momento", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
            }
        }
        else
        {
            let alert = UIAlertController(title: "I think...", message: "Some fields are empty", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Uno momento", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - Request
    func addBookRequest()
    {
        let authors : [String] = authorsCell.getAuthors()
        let parameters : Dictionary<String, Any> =
            ["name":    bookInfoCell.nameTextField.text!,
             "genre":   bookInfoCell.genreTextField.text!,
             "year":    bookInfoCell.yearTextField.text!,
             "amount":  bookInfoCell.amountTextField.text!,
             "id" :     bookInfoCell.idTextField.text!,
             "authors": authors]
        
        Alamofire.request(serverURL + "/addBook", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON
            { response in
                if let _ = response.result.value as? Dictionary<String, Any>
                {
                    let alert = UIAlertController(title: "Book added", message: "", preferredStyle: UIAlertControllerStyle.alert)
                    //alert.addAction(UIAlertAction(title: "Uno momento", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                    
                    let when = DispatchTime.now() + 1 // change 2 to desired number of seconds
                    DispatchQueue.main.asyncAfter(deadline: when)
                    {
                        alert.dismiss(animated: true)
                        self.dismiss(animated: true)
                    }
                    self.dismiss(animated: true)
                }
                else
                {
                    // show alert
                    let alert = UIAlertController(title: "This book already exist", message: "", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Roger that", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
        }
    }

}
