//
//  ProfileViewController.swift
//  proyDribble
//
//  Created by user178067 on 12/8/20.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController{

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var preferencesCollection: UICollectionView!
    @IBOutlet weak var publicationsCollection: UICollectionView!
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var profilePhotoWidth: NSLayoutConstraint!
    
    private var myPublications: [Publication] = [] {
        didSet{
            for p in myPublications{
                print(p)
            }
            publicationsCollection.reloadData()
            preferencesCollection.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layoutIfNeeded()
        scrollView.delegate = self
        setupCollectionsView()
        getPublications()
    }
    
        private func getPublications(){
            let id = UserDefaults.standard.string(forKey: "iduser")!
            print("\(id)")
            Firestore.firestore().collection("publications").whereField("user.id",isEqualTo: id).addSnapshotListener {
                (snapshot, error) in
                guard let documents = snapshot?.documents else {
                    print("no hay documentos in publications")
                    return
                }
                do{
                    try self.myPublications = documents.compactMap({
                        (document) -> Publication? in
                        print("\(document.data())")
                        return try document.data(as: Publication.self)
                    })
                }catch{
                    print(error)
                }
            }
        }
    
    
    private func setupCollectionsView(){
        let layout1 = UICollectionViewFlowLayout();
        layout1.itemSize = CGSize(width: preferencesCollection.frame.width, height: preferencesCollection.frame.width)
        layout1.scrollDirection = .horizontal
        preferencesCollection.collectionViewLayout = layout1
        let layout2 = UICollectionViewFlowLayout()
        layout2.itemSize = CGSize(width: publicationsCollection.frame.width, height: publicationsCollection.frame.height)
        layout2.scrollDirection = .horizontal
        publicationsCollection.collectionViewLayout = layout2
        preferencesCollection.delegate = self
        publicationsCollection.delegate = self
        preferencesCollection.dataSource = self
        publicationsCollection.dataSource = self
        
        //Register cells
        //publicationsCollection cells
        publicationsCollection.register(PublicationHubCollectionViewCell.nib(), forCellWithReuseIdentifier: PublicationHubCollectionViewCell.identifier)
        //preferencesCollection cells
        preferencesCollection.register(TopicCollectionViewCell.nib(), forCellWithReuseIdentifier: TopicCollectionViewCell.identifier)
    }
}

extension ProfileViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollY = scrollView.contentOffset.y
        //let newWidth = profilePhoto.frame.height - scrollY
        print("\(scrollY) --- newWidth:  ---  \(profilePhoto.frame.height - scrollY) --- initialHeight: \(self.view.frame.width*0.4)")
        //to do: get self.view.frame.width into a variable
        let newWidth = (self.view.frame.width*0.4) - scrollY
        if (newWidth >= self.view.frame.width*0.2 && newWidth <= self.view.frame.width*0.4 ) {
            //When condition is met, do something!
            profilePhotoWidth.constant = newWidth
            profilePhotoWidth.priority = UILayoutPriority(1000)
            self.view.layoutIfNeeded()
        }
        
    }
}

extension ProfileViewController: UICollectionViewDelegate{
    
}

extension ProfileViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView === publicationsCollection {
            return myPublications.count
        }else{
            return myPublications.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
       
        if collectionView === publicationsCollection {
            /*cell.frame.size = CGSize(width: collectionView.frame.width - 40, height: collectionView.frame.height - 40)*/
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PublicationHubCollectionViewCell.identifier, for: indexPath) as! PublicationHubCollectionViewCell
            cell.setup(with: UIImage(named: "test")!,with: myPublications[indexPath.row])
            cell.layer.cornerRadius = 15
            return cell
        }else{
            /*cell.frame.size = CGSize(width: collectionView.frame.width - 100, height: collectionView.frame.height - 100)*/
            let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: TopicCollectionViewCell.identifier, for: indexPath) as! TopicCollectionViewCell
            
            return cell
        }
    }
}

extension ProfileViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width - 40
        let height = collectionView.frame.height - 40
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}
