//
//  Delegates.swift
//  UniLab
//
//  Created by Тимур Фатыхов on 19/11/2017.
//  Copyright © 2017 Тимур Фатыхов. All rights reserved.
//

import Foundation

protocol LogInDelegate: class
{
    func clearPassword()
}

protocol BookCatalogDelegate: class
{
    func refresh()
}
