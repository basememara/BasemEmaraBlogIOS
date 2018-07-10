//
//  PopularPostCollectionViewCell.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-06-24.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit
import ZamzamKit

class PopularPostCollectionViewCell: UICollectionViewCell, PostsDataViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var featuredImage: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.backgroundColor = .black
        titleLabel.textColor = .white
        summaryLabel.textColor = .lightGray
        favoriteButton.tintColor = .white
        featuredImage.cornerRadius = 10
    }
    
    @IBAction func favoriteButtonTapped() {
        
    }
}

extension PopularPostCollectionViewCell {
    
    func bind(_ model: PostsDataViewModel) {
        titleLabel.text = model.title
        summaryLabel.text = model.summary
        featuredImage.setURL(model.imageURL)
    }
}
