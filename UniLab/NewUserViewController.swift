//
//  NewUserViewController.swift
//  UniLab
//
//  Created by Тимур Фатыхов on 13/09/2017.
//  Copyright © 2017 Тимур Фатыхов. All rights reserved.
//

import UIKit
import Alamofire
import PhoneNumberKit

class NewUserViewController: UIViewController, UITextFieldDelegate
{
    // MARK: - UI Properties
    @IBOutlet weak var firstNameTextField:   UITextField!
    @IBOutlet weak var lastNameTextField:    UITextField!
    @IBOutlet weak var universityTextField:  UITextField!
    @IBOutlet weak var facultyTextField:     UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var emailTextField:       UITextField!
    @IBOutlet weak var passwordTextField:    UITextField!
    @IBOutlet weak var repeatTextField:      UITextField!
    @IBOutlet weak var knowMeBetterButton:   UIButton!
    @IBOutlet weak var scrollView:           UIScrollView!
    
    // MARK: - Properties
    var characterSet = CharacterSet.uppercaseLetters.union(CharacterSet.lowercaseLetters)
    var emailSet = CharacterSet.uppercaseLetters.union(CharacterSet.lowercaseLetters).union(CharacterSet(charactersIn: "1234567890_.@"))
    var phoneNumberSet = CharacterSet(charactersIn: "1234567890-()+ ")
    
    let phoneNumberKit = PhoneNumberKit()
    
    // Mark: - DidLoad
    override func viewDidLoad()
    {
        self.hideKeyboardWhenTappedAround()
        
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        universityTextField.delegate = self
        facultyTextField.delegate = self
        phoneNumberTextField.delegate = self
        passwordTextField.delegate = self
        repeatTextField.delegate = self
        emailTextField.delegate = self
        
        knowMeBetterButton.isEnabled = false
        super.viewDidLoad()
        knowMeBetterButton.makeRoundBorder(withColor: UIColor.white, withWidth: 1)
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Interactive
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if textField == repeatTextField || textField == passwordTextField
        {
            let point = CGPoint(x: 0, y: 175)
            scrollView.setContentOffset(point, animated: true)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        let point = CGPoint(x: 0, y: 0)
        scrollView.setContentOffset(point, animated: true)
    }
    
    @IBAction func textChanged(_ sender: UITextField)
    {
        if  repeatTextField.text != "" &&
            firstNameTextField.text != "" &&
            lastNameTextField.text != "" &&
            universityTextField.text != "" &&
            facultyTextField.text != "" &&
            phoneNumberTextField.text != "" &&
            passwordTextField.text != "" &&
            emailTextField.text != ""
        {
            knowMeBetterButton.isEnabled = true
            knowMeBetterButton.alpha = 1
        }
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == ""
        {
            return true
        }
        switch (textField)
        {
        case firstNameTextField, lastNameTextField, universityTextField, facultyTextField:
            return !CharacterSet(charactersIn: string).intersection(characterSet).isEmpty
        case emailTextField:
            return !CharacterSet(charactersIn: string).intersection(emailSet).isEmpty
        case phoneNumberTextField:
            return !CharacterSet(charactersIn: string).intersection(phoneNumberSet).isEmpty
        default:
            return true
        }
    }
    
    @IBAction func editingChanged(_ sender: UITextField)
    {
        sender.text = PartialFormatter().formatPartial(sender.text!)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        switch textField
        {
        case firstNameTextField:
            lastNameTextField.becomeFirstResponder()
            
        case lastNameTextField:
            universityTextField.becomeFirstResponder()
            
        case universityTextField:
            facultyTextField.becomeFirstResponder()
            
        case facultyTextField:
            phoneNumberTextField.becomeFirstResponder()
            
        case phoneNumberTextField:
            emailTextField.becomeFirstResponder()
            
        case emailTextField:
            passwordTextField.becomeFirstResponder()
            
        case passwordTextField:
            repeatTextField.becomeFirstResponder()
            
        case repeatTextField:
            hideKeyboard()
        default:
            break
        }
        return false
    }
    
    @IBAction func cancelTapped(_ sender: UIBarButtonItem)
    {
        dismiss(animated: true)
    }

    @IBAction func doneButtonClick(_ sender: Any)
    {
        if passwordTextField.text != repeatTextField.text
        {
            let alert = UIAlertController(title: "I think...", message: "Password repeated incorrectly", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            passwordTextField.text = ""
            repeatTextField.text = ""
            knowMeBetterButton.isEnabled = false
            knowMeBetterButton.alpha = 0.5
        }
        else
        {
            addUserRequest()
        }
    }
    
    // MARK: - Request
    func addUserRequest()
    {
        let parameters : Dictionary<String, String> =
            ["firstName": firstNameTextField.text!,
             "lastName": lastNameTextField.text!,
             "university": universityTextField.text!,
             "faculty": facultyTextField.text!,
             "phoneNumber": phoneNumberTextField.text!,
             "email": emailTextField.text!,
             "password": passwordTextField.text!]
        
        Alamofire.request(serverURL + "/addUser", method: .post, parameters: parameters)
            .responseJSON
            { response in
                if let _ = response.result.value as? Dictionary<String, Any>
                {
                    self.dismiss(animated: true)
                }
                else
                {
                    // show alert
                    let alert = UIAlertController(title: "This email is occupied, try another", message: "", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Oups, okay", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
