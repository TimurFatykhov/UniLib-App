//
//  Extensions.swift
//  UniLab
//
//  Created by Тимур Фатыхов on 13/09/2017.
//  Copyright © 2017 Тимур Фатыхов. All rights reserved.
//

import UIKit

extension UIButton
{
    func makeRoundBorder(withColor color: UIColor, withWidth width: Float)
    {
        self.layer.cornerRadius = 15
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = CGFloat(width)
        self.clipsToBounds = true
    }
}

extension UIViewController
{
    func hideKeyboardWhenTappedAround()
    {
        let tap = UITapGestureRecognizer(target: self, action: #selector (self.hideKeyboard))
        tap.cancelsTouchesInView = true
        view.addGestureRecognizer(tap)
    }
    
    func hideKeyboard()
    {
        view.endEditing(true)
    }
}

extension UIImageView
{
    func circleLayer()
    {
        if self.frame.height == self.frame.width
        {
            self.layer.cornerRadius = self.frame.height / 2
            self.clipsToBounds = true
        }
    }
}
