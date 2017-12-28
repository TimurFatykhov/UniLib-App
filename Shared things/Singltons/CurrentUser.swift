//
//  CurrentUser.swift
//  UniLab
//
//  Created by Тимур Фатыхов on 14/11/2017.
//  Copyright © 2017 Тимур Фатыхов. All rights reserved.
//

import Foundation

final class CurrentUser
{
    static let user = CurrentUser()
    
    private init()
    {}
    
    var firstName : String?
    var lastName : String?
    var university : String?
    var faculty : String?
    var email : String?
    var phoneNumber : String?
    var password : String?
    var booksID : [String]? = []
    var usersBooks : [Book] = []
    var isAdmin : Bool = false
}
