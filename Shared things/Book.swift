//
//  Book.swift
//  UniLab
//
//  Created by Тимур Фатыхов on 19/11/2017.
//  Copyright © 2017 Тимур Фатыхов. All rights reserved.
//

import Foundation

class Book : NSObject
{
    var authors: [String] = []
    var name:    String
    var genre:   String
    var year:    String
    var amount:  String
    var id:      String
    
    init(bookName: String, bookAuthors: [String], bookGenre: String, bookYear: String, bookAmount: String, bookID: String)
    {
        name = bookName
        genre = bookGenre
        year = bookYear
        amount = bookAmount
        id = bookID
        
        for author in bookAuthors
        {
            authors.append(author)
        }
    }
}
