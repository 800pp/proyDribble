//
//  PublicationHighlightViewController.swift
//  proyDribble
//
//  Created by user178067 on 12/10/20.
//

import UIKit
import Firebase

class PublicationHighlightViewController: UIViewController {
    
    @IBOutlet weak var commentCollection: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var likesLable: UILabel!
    @IBOutlet weak var commentField: UITextField!
    @IBOutlet weak var commentFieldContainer: UIView!
    
    @IBOutlet weak var commentVIewBottomConstraint: NSLayoutConstraint!
    public var publication: Publication!

    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: commentCollection.frame.width, height: commentCollection.frame.height)
        commentCollection.collectionViewLayout = layout
        commentCollection.register(CommentCollectionViewCell.nib(), forCellWithReuseIdentifier: CommentCollectionViewCell.identifier)
        commentCollection.delegate = self
        commentCollection.dataSource = self
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(PublicationHighlightViewController.keyboardDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(PublicationHighlightViewController.keyboardWillBeHidden), name: UIResponder.keyboardDidHideNotification, object: nil)
        
    }
    
    @objc fileprivate func keyboardDidShow(notification: NSNotification){
        guard let frame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            print("Something went wrong....")
            return
        }
        let keyboardHeight = frame.cgRectValue.height
        commentVIewBottomConstraint.constant = keyboardHeight
        commentFieldContainer.alpha = 1
        commentFieldContainer.isHidden = false
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    @objc fileprivate func keyboardWillBeHidden(notification: NSNotification){
        commentVIewBottomConstraint.constant = 0
        commentFieldContainer.alpha = 0
        //commentFieldContainer.isHidden = true

        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        }, completion: {_ in
            self.commentFieldContainer.isHidden = true
        })
    }
    
    @IBAction func handleInsertCommentClick(_ sender: Any?){
        commentField.becomeFirstResponder()
    }
    
    
    @IBAction func hideKeyboard(_ sender: Any) {
        self.commentField.resignFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateUI()
    }
    
    public func updateUI(){
        titleLabel.text = publication.title
        descLabel.text = publication.description
        
    }
    
    @IBAction func goBack(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func insertComment(){
        let mid = UserDefaults.standard.string(forKey: "iduser")!
        do{
            let document = Firestore.firestore().collection("publications").document(publication.documentId!).collection("comments").document()
            let mdocumentid = document.documentID
            let user = try Firestore.Decoder().decode(User.self, from: UserDefaults.standard.dictionary(forKey: "user")!)
            let comment = Comment(documentId: mdocumentid, date: nil,id: mid, name: user.name, text: commentField.text!)
            try document.setData(from: comment) {
                error in
                if let error = error {
                    print(error)
                }
                else {
                    print(comment)
                }
            }
        }catch{
            print(error)
            return
        }
        
    }
    
}


extension PublicationHighlightViewController: UICollectionViewDelegate{

}

extension PublicationHighlightViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CommentCollectionViewCell.identifier, for: indexPath) as! CommentCollectionViewCell
        let comment = "This is random comment written by a random person"
        cell.setup(with: UIImage(named: "random")!, with: comment)
        return cell
    }
    
    
}

extension PublicationHighlightViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width - 20
        let height = collectionView.frame.height*0.4
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
}

extension PublicationHighlightViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        print("\(String(describing: publication))")
        return true
    }
}
