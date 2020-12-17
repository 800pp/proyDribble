//
//  PublicationHubCollectionViewCell.swift
//  proyDribble
//
//  Created by user178067 on 12/7/20.
//

import UIKit

class PublicationHubCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var someView: UIView!
    @IBOutlet weak var likeContainer: UIView!
    @IBOutlet weak var portraitPhoto: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var likes: UILabel!
    
    private var publictaion: Publication!{
        didSet{
            userName.text = "Por: \(publictaion.user.name)"
            title.text = publictaion.title
            likes.text = String(publictaion.likes)
        }
    }
    
    static let identifier = "PublicationHubCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //backgroundImage.tintColor = UIColor.black
        //backgroundImage.image?.withTintColor(UIColor.black)
        //backgroundImage.tintColor = UIColor.black
        settingUpStyles()
    }
    
    private func settingUpStyles(){
        portraitPhoto.layer.cornerRadius = portraitPhoto.frame.height / 2.0
        likeContainer.layer.cornerRadius = 5
        settingUpGradient()
    }

    private func settingUpGradient(){
        let gradient = CAGradientLayer()
        gradient.frame.size = someView.frame.size
        gradient.colors = [UIColor.black.withAlphaComponent(1).cgColor,UIColor.black.withAlphaComponent(0).cgColor]
        gradient.startPoint = CGPoint(x:1.0,y:1.0)
        gradient.endPoint = CGPoint(x:1.0,y:0.0)
        someView.layer.addSublayer(gradient)
        //someView.backgroundColor = UIColor.black
        someView.alpha = 0.6
    }
    
    public func setup(with image:UIImage, with p: Publication){
        backgroundImage.image = image
        self.publictaion = p
    }
    
    static func nib() -> UINib{
        return UINib(nibName: "PublicationHubCollectionViewCell", bundle: nil)
    }

}
