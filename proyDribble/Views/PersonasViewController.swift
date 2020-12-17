//
//  PersonasViewController.swift
//  proyDribble
//
//  Created by user178067 on 12/16/20.
//

import UIKit

class PersonasViewController: UIViewController {

    @IBOutlet weak var siguiendoCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: siguiendoCollection.frame.size.width, height: siguiendoCollection.frame.size.height)
        siguiendoCollection.collectionViewLayout = layout
        siguiendoCollection.delegate = self
        siguiendoCollection.dataSource = self
        siguiendoCollection.register(PersonasCollectionViewCell.nib(), forCellWithReuseIdentifier: PersonasCollectionViewCell.identifier)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension PersonasViewController: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PersonasCollectionViewCell.identifier, for: indexPath) as! PersonasCollectionViewCell
        return cell
    }
}

extension PersonasViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.size.width - 40, height: collectionView.frame.size.height / 3)
    }
}
