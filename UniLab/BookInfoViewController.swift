//
//  BookInfoViewController.swift
//  UniLab
//
//  Created by Тимур Фатыхов on 13/09/2017.
//  Copyright © 2017 Тимур Фатыхов. All rights reserved.
//

import UIKit
import Alamofire

class BookInfoViewController: UIViewController
{
    // MARK: - Properties
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var authorsTextView: UITextView!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var bookItButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    var book : Book!
    var bookID : String!
    weak var catalogDelegate : BookCatalogDelegate?
    
    // MARK: - Configuring
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        updateBookData() // update data in self.book
        
        bookItButton.setTitleColor(UIColor.gray, for: .disabled)
        bookItButton.makeRoundBorder(withColor: UIColor.white, withWidth: 1)
        deleteButton.makeRoundBorder(withColor: UIColor.red, withWidth: 1)
        
        if (CurrentUser.user.isAdmin)
        {
            bookItButton.isHidden = true
        }
        else
        {
            deleteButton.isHidden = true
        }
    }
    
    // MARK: - UI Interaction
    @IBAction func bookItTapped(_ sender: Any)
    {
        bookItButton.isEnabled = false
        bookItRequest(bookNumber: book.id, userEmail: CurrentUser.user.email!)
        CurrentUser.user.usersBooks.append(self.book)
        CurrentUser.user.booksID?.append(self.book.id)
        amountLabel.text = String(Int(amountLabel.text!)! - 1)
    }
    
    @IBAction func deleteTapped(_ sender: Any)
    {
        let deleteAlert = UIAlertController(title: "Delete", message: "Book will be lost.", preferredStyle: UIAlertControllerStyle.alert)
        
        deleteAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            self.deleteBookRequest(withBookNumber: self.book.id)
            self.catalogDelegate!.refresh()
            self.navigationController?.popViewController(animated: true)
        }))
        
        deleteAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            
        }))
        
        present(deleteAlert, animated: true, completion: nil)
    }
    
    // MARK: - Requests
    func bookItRequest(bookNumber: String, userEmail: String)
    {
        let parameters : Dictionary<String, String> = ["id": bookNumber, "email": userEmail]
        
        Alamofire.request(serverURL + "/bookIt", method: .post, parameters: parameters)
            .responseJSON()
                {response in
                    print(response)
                }
    }
    
    func deleteBookRequest(withBookNumber bookNumber: String)
    {
        let parameters : Dictionary<String, String> = ["id": bookNumber]
        
        Alamofire.request(serverURL + "/deleteIt", method: .post, parameters: parameters)
            .responseJSON()
                {response in
                    print(response)
                }
    }
    
    func updateBookData()
    {
        let parameter : Dictionary<String, String> = ["id": bookID]
        
        // make a request
        Alamofire.request(serverURL + "/searchBookWithID", method: .post, parameters: parameter)
            .responseJSON
            { response in
                
                // list of finded books
                let books = response.result.value as? [Dictionary<String, Any>]
                
                if books!.count == 0 // didn't find any books
                {
                    print("no books")
                }
                else                // finded requested books
                {
                    let book = books!.first!
                    self.book = Book( bookName:      book["name"] as! String,
                                                              bookAuthors:   book["authors"] as! [String],
                                                              bookGenre:     book["genre"] as! String,
                                                              bookYear:      book["year"] as! String,
                                                              bookAmount:    book["amount"] as! String,
                                                              bookID:        book["id"] as! String )
                    
                    var authors = String()
                    for author in self.book.authors
                    {
                        authors += author + "\n"
                    }
                    self.authorsTextView.text = authors
                    self.genreLabel.text = self.book.genre
                    self.yearLabel.text = self.book.year
                    self.amountLabel.text = self.book.amount
                    self.titleLabel.text = self.book.name
                    
                    if (self.book.amount == "0")
                    {
                        self.bookItButton.isEnabled = false
                    }
                    if (CurrentUser.user.booksID?.contains(self.book.id))!
                    {
                        self.bookItButton.isEnabled = false
                    }
                }
        }
    }
}











