//
//  PostTableViewCell.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-06-20.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell, PostsDataViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var featuredImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.backgroundColor = .black
        titleLabel.textColor = .white
        summaryLabel.textColor = .lightGray
        dateLabel.textColor = .lightGray
        selectionColor = UIColor(rgb: (38, 38, 40))
        favoriteButton.tintColor = .white
        moreButton.tintColor = .white
    }
    
    @IBAction func favoriteButtonTapped() {
    }
    
    @IBAction func moreButtonTapped() {
    }
}

extension PostTableViewCell {
    
    func bind(_ model: PostsDataViewModel) {
        titleLabel.text = model.title
        summaryLabel.text = model.summary
        dateLabel.text = model.date
        featuredImage.setURL(model.imageURL)
    }
}
