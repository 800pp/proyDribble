//
//  LoginFormVIewController.swift
//  proyDribble
//
//  Created by user178067 on 12/7/20.
//

import UIKit
import Firebase

class LoginFormVIewController: UIViewController {
    
    weak var anyTextField: UITextField?
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mainLogo: UIImageView!
    @IBOutlet var mainWidth: NSLayoutConstraint!
    @IBOutlet weak var somelabel: UILabel!
    @IBOutlet weak var btnLogin: UIButton!
    
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    var isUsernameValid = false
    var isPasswordValid = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        anyTextField?.delegate = self
        /*let userFS = UserFS()
        userFS.getUsers()*/
        // Do any additional setup after loading the view.
        //getUsers()
        NotificationCenter.default.addObserver(self, selector: #selector(LoginFormVIewController.keyboardDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginFormVIewController.keyboardWillBeHidden), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    @IBAction private func segueRegister(){
        performSegue(withIdentifier: "fromLogintoRegister", sender: self)
    }
    
    @IBAction func textValidation(_ sender: UITextField) {
        print("Tag: \(sender.tag), text: \(String(describing: sender.text))")
        let text = sender.text
        let tag = sender.tag
        switch tag {
        case 1:
            //sender.backgroundColor = text!.isValid(.dni) ? UIColor.blue : UIColor.red
            let isValid = text!.isValid(.dni) || text!.isValid(.email)
            sender.layer.borderColor =  isValid ? UIColor.green.cgColor : UIColor.red.cgColor
            isUsernameValid = isValid
        case 2:
            sender.layer.borderColor = !text!.isEmpty ? UIColor.green.cgColor : UIColor.red.cgColor
            isPasswordValid = !text!.isEmpty
            print(isPasswordValid)
        default:
            print("Tag: \(tag). Current textfield does not have a validation!")
        }
        sender.layer.borderWidth = 0.4
        evaluateCredentials()
    }
    
    
    
    /*private func getUsers(){
        Firestore.firestore().collection("users").addSnapshotListener{
            (snapshot, error) in
            guard let documents = snapshot?.documents else {
                print("no hay users")
                return
            }
            do{
                try self.users = documents.compactMap({
                    (document) -> User? in
                    return try document.data(as: User.self)
                })
            }catch{
                print(error)
            }
        }
    }*/
    
    @objc func keyboardDidShow(notification: Notification){
        print("keyboardDidShow fired!")
        //
        let keyboardsize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        guard let activeTextField = anyTextField, let keyboardHeight = keyboardsize?.height else{
            return
        }
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardHeight, right: 0.0)
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
    
    @IBAction func hideKeyboard(_ sender: Any?){
        self.view.endEditing(true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func handleLoginClick(_ sender: Any?){
        evaluateLogin()
    }
    
    private func evaluateLogin(){
        let username = txtUsername.text!
        let password = txtPassword.text!
        let users = Firestore.firestore().collection("users")
        let query: Query
        if username.isValid(.dni) {
            query = users.whereField("dni", isEqualTo: Int(username)!)
        }else{
            query = users.whereField("mail", isEqualTo: username)
        }
        query.getDocuments{
            (snapshot,err) in
            if let err = err {
                print(err)
                return
            } else {
                do{
                    if snapshot!.documents.count == 0 {
                        print("Username does not exists")
                        return
                    }else{
                        let user = try snapshot!.documents[0].data(as: User.self)!
                        let isValidated = user.password == password
                        if isValidated {
                            print("Username and password do exist")
                                do{
                                    let data = try Firestore.Encoder().encode(user)
                                    UserDefaults.standard.setValue(data, forKey: "user")
                                    UserDefaults.standard.setValue(user.documentid, forKey: "iduser")
                                    self.performSegue(withIdentifier: "fromLoginToHome", sender: LoginFormVIewController.self)
                                }catch{
                                    print(error)
                                }
                            
                        } else{
                            print("Username does exist but password doesn't")
                        }
                    }
                    
                }
                catch{
                    print(err!)
                    return
                }
                
            }
        }
    }
    
    private func evaluateCredentials(){
        if isUsernameValid && isPasswordValid {
            btnLogin.isEnabled = true
            btnLogin.alpha = 1
        }else{
            btnLogin.isEnabled = false
            btnLogin.alpha = 0.5
        }
    }

}

extension LoginFormVIewController: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("textFieldDidBeginEditing fired! Now focusing on: \(textField.tag)")
        /*var rect = mainLogo.frame
        rect.size.width = view.frame.width / 4
        mainLogo.frame = rect
        mainLogo.layoutIfNeeded()*/
        //self.mainWidth.isActive = false
        self.mainWidth.priority = UILayoutPriority(rawValue: 998)
        UIView.animate(withDuration: 0.4){
            self.view.layoutIfNeeded()
        }
        anyTextField = textField
    }
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        //print("textFieldDidEndEditing fired!")
        //self.mainWidth.accessibilityActivate()
        self.mainWidth.priority = UILayoutPriority(rawValue: 1000)
        UIView.animate(withDuration: 0.4){
            //self.mainLogo.layoutIfNeeded()
            self.view.layoutIfNeeded()
        }
        
        
        anyTextField = nil
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
