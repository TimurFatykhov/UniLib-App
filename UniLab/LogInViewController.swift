//
//  LogInViewController.swift
//  UniLab
//
//  Created by Тимур Фатыхов on 13/09/2017.
//  Copyright © 2017 Тимур Фатыхов. All rights reserved.
//

import UIKit
import Alamofire

class LogInViewController: UIViewController, UITextFieldDelegate, LogInDelegate
{
    @IBOutlet weak var emailTextView: UITextField!
    @IBOutlet weak var passwordTextView: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad()
    {
        self.hideKeyboardWhenTappedAround()
        super.viewDidLoad()
        signInButton.makeRoundBorder(withColor: UIColor.white, withWidth: 1)
        signUpButton.makeRoundBorder(withColor: UIColor.white, withWidth: 1)
        emailTextView.attributedPlaceholder = NSAttributedString(string: "Email",attributes: [NSForegroundColorAttributeName: UIColor.white])
        passwordTextView.attributedPlaceholder = NSAttributedString(string: "Password",attributes: [NSForegroundColorAttributeName: UIColor.white])
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField
        {
        case emailTextView:
            passwordTextView.becomeFirstResponder()
        case passwordTextView:
            hideKeyboard()
            logIn()
        default:
            break
        }
        return false
    }
    
    func clearPassword()
    {
        passwordTextView.text = ""
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let destination = segue.destination as? UINavigationController
        {
            if let catalogView = destination.topViewController as? BookCatalogViewController
            {
                catalogView.delegate = self
            }
        }
    }
    
    // MARK: - Interactiive with interface
    @IBAction func logInTapped(_ sender: UIButton)
    {
        logIn()
    }
    
    // MARK: - Requests
    func logIn()
    {
        let parameters : Dictionary<String, String> = ["email": emailTextView.text!, "password": passwordTextView.text!]
        Alamofire.request(serverURL + "/verification", method: .post, parameters: parameters)
        .responseJSON
            { response in
                if let user = response.result.value as? Dictionary<String, Any> // user exists
                {
                    self.performSegue(withIdentifier: "loginToCatalog", sender: nil)
                    let currentUser = CurrentUser.user
                    currentUser.firstName = user["firstName"] as? String
                    currentUser.lastName = user["lastName"] as? String
                    currentUser.university = user["university"] as? String
                    currentUser.faculty = user["faculty"] as? String
                    currentUser.phoneNumber = user["phoneNumber"] as? String
                    currentUser.email = user["email"] as? String
                    currentUser.password = user["password"] as? String
                    currentUser.booksID = user["booksID"] as? [String]
                    if let _ = user["admin"] as? String
                    {
                        currentUser.isAdmin = true;
                    }
                    else
                    {
                        currentUser.isAdmin = false;
                    }
                    currentUser.usersBooks = [];
                }
                else    // user does not exist
                {
                    // show alert
                    let alert = UIAlertController(title: "Incorrect email or password :(", message: "", preferredStyle: UIAlertControllerStyle.alert)
                    self.present(alert, animated: true, completion: nil)
                    let when = DispatchTime.now() + 1 // change 2 to desired number of seconds
                    DispatchQueue.main.asyncAfter(deadline: when)
                    {
                        alert.dismiss(animated: true)
                    }
                }
            }
    }
}
