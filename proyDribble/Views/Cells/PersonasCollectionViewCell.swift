//
//  PersonasCollectionViewCell.swift
//  proyDribble
//
//  Created by user178067 on 12/16/20.
//

import UIKit

class PersonasCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    private var user: User!
    
    static let identifier = "PersonasCollectionViewCell"
    
    static func nib()-> UINib{
        return UINib(nibName: identifier, bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    private func setup(with u: User){
        self.user = u
    }
    
}
