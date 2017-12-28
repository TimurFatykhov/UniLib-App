//
//  BookCatalogViewController.swift
//  UniLab
//
//  Created by Тимур Фатыхов on 13/09/2017.
//  Copyright © 2017 Тимур Фатыхов. All rights reserved.
//

import UIKit
import Alamofire

class BookCatalogViewController: UITableViewController, UISearchBarDelegate, BookCatalogDelegate
{
    // MARK : - Properties
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var mainTable: UITableView!
    @IBOutlet weak var addBookButton: UIBarButtonItem!
    
    weak var delegate: LogInDelegate?
//    var usersBooks : [Book] = []
    var findedBooks : [Book] = []
    var shownBooks : [Book] = []
    var numberOfRows : Int = 0
    var currentUser : CurrentUser = CurrentUser.user
    
    var indexOfSelectedRow = -1;
    
    // MARK : - Downloaded
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        numberOfRows = currentUser.usersBooks.count
        
        searchBar.delegate = self
        
        mainTable.rowHeight = UITableViewAutomaticDimension
        mainTable.estimatedRowHeight = 200
        
        // show greeting
        let alert = UIAlertController(title: "Hello, \(CurrentUser.user.firstName!)!", message: "", preferredStyle: UIAlertControllerStyle.alert)
        self.present(alert, animated: true, completion: nil)
        let when = DispatchTime.now() + 1 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when)
        {
            alert.dismiss(animated: true)
        }
        
        if (CurrentUser.user.isAdmin)
        {
            // user is admin
            self.navigationItem.rightBarButtonItem = self.addBookButton
        }
        else
        {
            // user isn't admin
            self.navigationItem.rightBarButtonItem = nil
            // get and show user's book
            getUsersBook(booksID: CurrentUser.user.booksID!)
        }
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    // MARK: - Delegate
    func refresh()
    {
        searchBarSearchButtonClicked(searchBar)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return numberOfRows
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = mainTable.dequeueReusableCell(withIdentifier: "bookCell")! as! BookCell
        
        cell.authorLabel.text! = shownBooks[indexPath.row].authors.first!
        cell.nameLabel.text! = shownBooks[indexPath.row].name
        cell.genreLabel.text! = shownBooks[indexPath.row].genre
        cell.yearLabel.text! = shownBooks[indexPath.row].year
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath?
    {
        indexOfSelectedRow = indexPath.row
        return indexPath
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        mainTable.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let destination = segue.destination as? BookInfoViewController
        {
            destination.bookID = shownBooks[indexOfSelectedRow].id
            destination.catalogDelegate = self
        }
    }
    
    
    // MARK: - Interface interaction
    @IBAction func exitTapped(_ sender: Any)
    {
        findedBooks.removeAll()
        dismiss(animated: true)
        delegate?.clearPassword()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        if (searchBar.text! == "")
        {
            shownBooks = currentUser.usersBooks
            numberOfRows = currentUser.usersBooks.count
            tableView.reloadData()
            return
        }
        findedBooks.removeAll()
        let searchReq = searchBar.text!
        searchBookRequest(searchReq: searchReq)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        shownBooks = currentUser.usersBooks
        tableView.reloadData()
//        findedBooks.removeAll()
    }
    
    // MARK: - Request
    func searchBookRequest(searchReq : String)
    {
        let parameter : Dictionary<String, String> = ["string": searchReq]
        
        // make a request
        Alamofire.request(serverURL + "/searchBook", method: .post, parameters: parameter)
            .responseJSON
            { response in
                
                // list of finded books
                let books = response.result.value as? [Dictionary<String, Any>]
                
                if books!.count == 0 // didn't find any books
                {
                    let alert = UIAlertController(title: "No one match", message: "", preferredStyle: UIAlertControllerStyle.alert)
                    
                    // delay for alert
                    self.present(alert, animated: true, completion: nil)
                    let when = DispatchTime.now() + 2
                    DispatchQueue.main.asyncAfter(deadline: when)
                    {
                        alert.dismiss(animated: true)
                    }
                    
                    // clear table
                    self.numberOfRows = 0
                    self.shownBooks = self.findedBooks
                    self.tableView.reloadData()
                }
                else                // finded requested books
                {
                    for book in books!
                    {
                        self.findedBooks.append( Book( bookName:      book["name"] as! String,
                                                       bookAuthors:   book["authors"] as! [String],
                                                       bookGenre:     book["genre"] as! String,
                                                       bookYear:      book["year"] as! String,
                                                       bookAmount:    book["amount"] as! String,
                                                       bookID:        book["id"] as! String )
                                                )
                    }
                    
                    // show all finded books
                    self.numberOfRows = self.findedBooks.count
                    self.shownBooks = self.findedBooks
                    self.tableView.reloadData()
                }
            }
    }
    
    func getUsersBook(booksID: [String])
    {
        for id in booksID
        {
            let parameter : Dictionary<String, String> = ["id": id]
            
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
                        print(book);
                        self.currentUser.usersBooks.append( Book( bookName:      book["name"] as! String,
                                             bookAuthors:   book["authors"] as! [String],
                                             bookGenre:     book["genre"] as! String,
                                             bookYear:      book["year"] as! String,
                                             bookAmount:    book["amount"] as! String,
                                             bookID:        book["id"] as! String )
                                      )
                        self.numberOfRows = self.currentUser.usersBooks.count
                        self.shownBooks = self.currentUser.usersBooks
                        self.tableView.reloadData()
                    }
            }
        }
    }
}




















