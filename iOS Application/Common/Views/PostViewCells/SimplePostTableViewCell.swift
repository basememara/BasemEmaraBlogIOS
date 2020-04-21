//
//  SimplePostTableViewCell.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-07.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit
import SwiftyPress

class SimplePostTableViewCell: UITableViewCell, PostsDataViewCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var detailLabel: UILabel!
}

extension SimplePostTableViewCell {
    
    func load(_ model: PostsDataViewModel) {
        titleLabel.text = model.title
        detailLabel.text = model.date
    }
}
