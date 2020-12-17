//
//  NewPublicationViewController.swift
//  proyDribble
//
//  Created by user178067 on 12/10/20.
//

import UIKit
import Firebase

class NewPublicationViewController: UIViewController {

    weak var anyTextField: UITextField?
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var descField: UITextField!
    @IBOutlet weak var btnPublication: UIButton!
    
    private var isTitleValid = false
    private var isDescValid = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.anyTextField?.delegate = self
        scrollView.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(RegisterViewController.keyboardDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(RegisterViewController.keyboardWillBeHidden), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
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
    
    @IBAction func imagePicker(){
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func closeKeyboard(_ sender: Any?){
        self.view.endEditing(true)
    }
    
    @IBAction func handlePublicationClick(_ sender: Any?){
        addPublication()
    }
    
    @IBAction func textValidation(_ sender: UITextField) {
        print("Tag: \(sender.tag), text: \(String(describing: sender.text))")
        let text = sender.text
        let tag = sender.tag
        switch tag {
        case 1:
            //sender.backgroundColor = text!.isValid(.dni) ? UIColor.blue : UIColor.red
            
            sender.layer.borderColor = !text!.isEmpty ? UIColor.green.cgColor : UIColor.red.cgColor
            isTitleValid = !text!.isEmpty
        case 2:
            sender.layer.borderColor = !text!.isEmpty ? UIColor.green.cgColor : UIColor.red.cgColor
            isDescValid = !text!.isEmpty
        default:
            print("Tag: \(tag). Current textfield does not have a validation!")
        }
        sender.layer.borderWidth = 0.4
        evaluateCredentials()
    }
    
    private func evaluateCredentials(){
        if isTitleValid && isDescValid{
            btnPublication.alpha = 1
            btnPublication.isEnabled = true
        }else {
            btnPublication.alpha = 0.5
            btnPublication.isEnabled = false
        }
    }
    
    private func addPublication(){
        let mtitle = titleField.text!
        let mdesc = descField.text!
        let id = UserDefaults.standard.string(forKey: "iduser")!
        guard let objUser = try? Firestore.Decoder().decode(User.self, from: UserDefaults.standard.dictionary(forKey: "user")!) else {
            print("Somthing when wrong...")
            return
        }

        let muser = tempUser(id: id, name: objUser.name)
        let newPublication = Publication(likes: 0, title: mtitle, description: mdesc, user: muser)
        let publications = Firestore.firestore().collection("publications")
            do {
                _ = try publications.addDocument(from: newPublication) {
                    error in
                    if let error = error {
                        print(error)
                    }
                    else{
                        print("this worked!")
                    }
                }
            }catch{
                print(error)
            }
        }
    
    
}

extension NewPublicationViewController: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //print("textFieldDidBeginEditing fired! Now focusing on: \(textField.tag)")
        if(textField.tag == 1){anyTextField = textField}
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

extension NewPublicationViewController: UIScrollViewDelegate{
    
}

extension NewPublicationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
}
