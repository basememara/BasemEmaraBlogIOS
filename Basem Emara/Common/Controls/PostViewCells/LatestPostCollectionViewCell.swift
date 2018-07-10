//
//  PostCollectionViewCell.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-06-20.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit
import ZamzamKit

class LatestPostCollectionViewCell: UICollectionViewCell, PostsDataViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var featuredImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.cornerRadius = 10
        containerView.backgroundColor = UIColor(rgb: (38, 38, 40))
        titleLabel.textColor = .white
        summaryLabel.textColor = .lightGray
    }
}

extension LatestPostCollectionViewCell {
    
    func bind(_ model: PostsDataViewModel) {
        titleLabel.text = model.title
        summaryLabel.text = model.summary
        featuredImage.setURL(model.imageURL)
    }
}
