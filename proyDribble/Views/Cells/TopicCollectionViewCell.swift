//
//  TopicCollectionViewCell.swift
//  proyDribble
//
//  Created by user178067 on 12/14/20.
//

import UIKit

class TopicCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var topicLabel: UILabel!
    
    var topic: String = "" {
        didSet{
            topicLabel.text = topic
        }
    }

    static let identifier = "TopicCollectionViewCell"
    
    static func nib()-> UINib{
        return UINib(nibName: "TopicCollectionViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        settingUpStyles()
        // Initialization code
    }
    
    private func settingUpStyles(){
        self.backgroundColor = UIColor.gray
        self.layer.cornerRadius = 4
    }
    
    


}
