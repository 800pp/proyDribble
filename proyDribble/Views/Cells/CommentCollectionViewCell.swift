//
//  CommentCollectionViewCell.swift
//  proyDribble
//
//  Created by user178067 on 12/10/20.
//

import UIKit

class CommentCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "CommentCollectionViewCell"
    @IBOutlet weak var userPhoto: UIImageView!
    @IBOutlet weak var commentText: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        settingUpStyles()
    }
    
    private func settingUpStyles(){
        //self.backgroundColor = UIColor.blue
        self.userPhoto.layer.masksToBounds = false
        self.userPhoto.layer.borderWidth = 0.0
        self.userPhoto.clipsToBounds = true
        self.userPhoto.layer.cornerRadius = 25
    }
    
    static func nib() -> UINib{
        return UINib(nibName: "CommentCollectionViewCell", bundle: nil)
    }
    
    func setup(with image: UIImage,with text: String){
        userPhoto.image = image
        commentText.text = text
    }

}
