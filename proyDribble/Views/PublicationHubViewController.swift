//
//  PublicationHubViewController.swift
//  proyDribble
//
//  Created by user178067 on 12/7/20.
//

import UIKit
import Firebase

class PublicationHubViewController: UIViewController{
    
    @IBOutlet weak var publicationCollection: UICollectionView!
    @IBOutlet weak var topicCollection: UICollectionView!
    @IBOutlet weak var searchBox: UITextField!
    @IBOutlet weak var searchCenterConstraint: NSLayoutConstraint!
    
    
    private var selectedPublication: Publication!{
        didSet{
            print(selectedPublication as Any)
        }
    }
    private var user: User! {
        didSet{
            print(user as Any)
        }
    }
    
    var publications: [Publication] = [] {
        didSet{
            publications.forEach{
                publication in
                print(publication)
            }
            publicationCollection.reloadData()
        }
    }
    
    private func getUserFromDefault(){
        do{
            user = try Firestore.Decoder().decode(User.self, from: UserDefaults.standard.dictionary(forKey: "user")!)
            print(UserDefaults.standard.string(forKey: "iduser") as Any)
        } catch{
            print(error)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getPublications()
        settingUpStyles()
        getUserFromDefault()
        
        let topicLayout = UICollectionViewFlowLayout()
        topicLayout.itemSize = CGSize(width: topicCollection.frame.size.width, height: topicCollection.frame.size.height)
        topicLayout.scrollDirection = .horizontal
        topicCollection.collectionViewLayout = topicLayout
        topicCollection.register(TopicCollectionViewCell.nib(), forCellWithReuseIdentifier: TopicCollectionViewCell.identifier)
        topicCollection.delegate = self
        topicCollection.dataSource = self

        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: publicationCollection.frame.width, height: publicationCollection.frame.height)
        publicationCollection.collectionViewLayout = layout
        publicationCollection.register(PublicationHubCollectionViewCell.nib(), forCellWithReuseIdentifier: PublicationHubCollectionViewCell.identifier)
        publicationCollection.delegate = self
        publicationCollection.dataSource = self
    }
    
    private func settingUpStyles(){
        searchCenterConstraint.constant = -20.0
        searchBox.alpha = 0
        searchBox.isEnabled = false
        self.view.layoutIfNeeded()
    
    }
    
    
    
    @IBAction func beginSearch(_ sender : Any?){
        searchCenterConstraint.constant = 0
        searchBox.alpha = 1
        searchBox.isEnabled = true
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    private func getPublications(){
        Firestore.firestore().collection("publications").addSnapshotListener {
            (snapshot, error) in
            guard let documents = snapshot?.documents else {
                print("no hay documentos in publications")
                return
            }
            do{
                try self.publications = documents.compactMap({
                    (document) -> Publication? in
                    return try document.data(as: Publication.self)
                })
            }catch{
                print(error)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromHomeToHighlight" {
            let indexPath = sender as! NSIndexPath
            let destVC = segue.destination as! PublicationHighlightViewController
            destVC.publication = publications[indexPath.row]
            
        }
    }
    
    @IBAction func goBack(_ sender: Any?){
        self.navigationController?.popViewController(animated: true)
    }
}

extension PublicationHubViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView === topicCollection {
            return 10
        } else {
            return self.publications.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView === publicationCollection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PublicationHubCollectionViewCell.identifier, for: indexPath) as! PublicationHubCollectionViewCell
            cell.setup(with: UIImage(named: "test")!,with: self.publications[indexPath.row])
            cell.layer.cornerRadius = 15
            return cell
        } else if collectionView === topicCollection{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopicCollectionViewCell.identifier, for: indexPath) as! TopicCollectionViewCell
            cell.topic = "Matematica"
            return cell
        } else{
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "fromHomeToHighlight", sender: indexPath)
    }
}

extension PublicationHubViewController: UICollectionViewDelegate{
    
}

extension PublicationHubViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView === publicationCollection {
            let width = collectionView.frame.width - 40
            let height = width*0.8
            return CGSize(width: width, height: height)
        } else if collectionView === topicCollection{
            let width = collectionView.frame.size.width / 2 - 40
            let height = collectionView.frame.size.height - 20
            return CGSize(width: width, height: height)
        } else{
            return CGSize(width: 2.0, height: 2.0)
        }
        
    }
}
