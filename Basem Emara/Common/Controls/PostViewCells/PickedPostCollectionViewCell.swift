//
//  PickedPostCollectionViewCell.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-06-25.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit
import ZamzamKit

class PickedPostCollectionViewCell: UICollectionViewCell, PostsDataViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var featuredImage: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    
    @IBAction func favoriteButtonTapped() {
        
    }
}

extension PickedPostCollectionViewCell {
    
    func bind(_ model: PostsDataViewModel) {
        titleLabel.text = model.title
        summaryLabel.text = model.summary
        featuredImage.setURL(model.imageURL)
    }
}
