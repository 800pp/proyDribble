//
//  RegisterViewController.swift
//  proyDribble
//
//  Created by user178067 on 12/5/20.
//

import UIKit
import Firebase
import CodableFirebase

class RegisterViewController: UIViewController{
    
    weak var anyTextField: UITextField?
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var txtDni: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var btnRegister: UIButton!
    
    private var isDniValid = false
    private var isEmailValid = false
    private var isNameValid = false
    private var isPhoneValid = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Delegates
        self.anyTextField?.delegate = self
        scrollView.delegate = self
        //NotificationCenter
        NotificationCenter.default.addObserver(self, selector: #selector(RegisterViewController.keyboardDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(RegisterViewController.keyboardWillBeHidden), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    @IBAction func closeKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    //Text validation to all textFields
    @IBAction func textValidation(_ sender: UITextField) {
        print("Tag: \(sender.tag), text: \(String(describing: sender.text))")
        let text = sender.text
        let tag = sender.tag
        switch tag {
        case 1:
            sender.layer.borderColor = text!.isValid(.dni) ? UIColor.green.cgColor : UIColor.red.cgColor
            isDniValid = text!.isValid(.dni)
        case 2:
            sender.layer.borderColor = text!.isValid(.name) ? UIColor.green.cgColor : UIColor.red.cgColor
            isNameValid = text!.isValid(.name)
        case 3:
            sender.layer.borderColor = text!.isValid(.email) ? UIColor.green.cgColor : UIColor.red.cgColor
            isEmailValid = text!.isValid(.email)
        case 4:
            sender.layer.borderColor = text!.isValid(.phone) ? UIColor.green.cgColor : UIColor.red.cgColor
            isPhoneValid = text!.isValid(.phone)
        default:
            print("Tag: \(tag). Current textfield does not have a validation!")
        }
        sender.layer.borderWidth = 0.6
        evaluateRegistrationDetails()
    }
    
    //Keyboard appeared Notification objc handler
    @objc func keyboardDidShow(notification: Notification){
        //print("keyboardDidShow fired!")
        let keyboardsize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        guard let activeTextField = anyTextField, let keyboardHeight = keyboardsize?.height else{
            return
        }
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardHeight + activeTextField.frame.height, right: 0.0)
        //scrollView.contentSize.height = scrollView.contentSize.height + keyboardHeight
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        
        let activeRect = activeTextField.convert(activeTextField.bounds, to: scrollView)
        scrollView.scrollRectToVisible(activeRect, animated: true)
    }
    
    @objc func keyboardWillBeHidden(notification: Notification){
        print("I clicked outside the keyboard!")
        let contentInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction private func goBack(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func btnRegisterClick(){
        registerUser()
    }
    
    
    private func evaluateRegistrationDetails(){
        if isNameValid && isEmailValid && isDniValid && isPhoneValid{
            btnRegister.isEnabled = true
            btnRegister.alpha = 1
        }else{
            btnRegister.isEnabled = false
            btnRegister.alpha = 0.5
        }
    }
    
    
    
    private func registerUser(){
        let document = Firestore.firestore().collection("users").document()
        let user = User(documentid: document.documentID, dni: Int(txtDni.text!)!, password: txtPassword.text!, name: txtName.text!, phone: Int(txtPhone.text!)!, mail: txtEmail.text!)
        do{
            try document.setData(from: user) {
                err in
                if let err = err {
                    print(err)
                } else{
                    do{
                        /*let encodedData =  try NSKeyedArchiver.archivedData(withRootObject: user, requiringSecureCoding: false)
                        print(encodedData)
                        UserDefaults.standard.set(encodedData, forKey: "user")*/
                        //let data  = try FirebaseEncoder().encode(user)
                        //print(data)
                        let data = try Firestore.Encoder().encode(user)
                        UserDefaults.standard.set(data, forKey: "user")
                        UserDefaults.standard.set(document.documentID, forKey: "iduser")
                        print(data)
                        self.performSegue(withIdentifier: "fromRegisterToHome", sender: self)
                    }catch{
                        print(error)
                    }
                    
                }
            }
            
            
        } catch {
            print(error)
            return
        }
        
        
    }
    
    
}

extension RegisterViewController: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //print("textFieldDidBeginEditing fired! Now focusing on: \(textField.tag)")
        anyTextField = textField
    }
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        //print("textFieldDidEndEditing fired!")
        
        anyTextField = nil
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension RegisterViewController: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("\(scrollView.contentOffset.y)")
    }
}
