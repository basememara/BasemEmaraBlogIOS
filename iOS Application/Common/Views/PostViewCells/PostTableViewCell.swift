//
//  PostTableViewCell.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-06-20.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit
import SwiftyPress
import ZamzamUI

final class PostTableViewCell: UITableViewCell {
    
    private let titleLabel = ThemedHeadline().with {
        $0.font = .preferredFont(forTextStyle: .headline)
        $0.adjustsFontForContentSizeCategory = true
        $0.numberOfLines = 2
    }
    
    private let summaryLabel = ThemedSubhead().with {
        $0.font = .preferredFont(forTextStyle: .subheadline)
        $0.numberOfLines = 2
    }
    
    private let dateLabel = ThemedCaption().with {
        $0.font = .preferredFont(forTextStyle: .footnote)
        $0.numberOfLines = 1
    }
    
    private let featuredImage = RoundedImageView(imageNamed: .placeholder)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        prepare()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup

private extension PostTableViewCell {
    
    func prepare() {
        let stackView = UIStackView(arrangedSubviews: [
            UIStackView(arrangedSubviews: [
                titleLabel.with {
                    $0.setContentHuggingPriority(.defaultHigh, for: .vertical)
                },
                summaryLabel,
                dateLabel.with {
                    $0.setContentHuggingPriority(.defaultLow, for: .vertical)
                }
            ]).with {
                $0.axis = .vertical
                $0.spacing = 10
            },
            UIView().with {
                $0.addSubview(featuredImage)
            }
        ]).with {
            $0.axis = .horizontal
            $0.spacing = 20
        }
        
        let view = ThemedView().with {
            $0.addSubview(stackView)
        }
        
        separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        addSubview(view)
        
        view.edges(to: self)
        stackView.edges(to: view, padding: 24, safeArea: true)
        
        featuredImage.aspectRatioSize()
        featuredImage.widthAnchor.constraint(equalToConstant: 70).isActive = true
        
        if let superview = featuredImage.superview {
            featuredImage.topAnchor.constraint(equalTo: superview.topAnchor).isActive = true
            featuredImage.leadingAnchor.constraint(equalTo: superview.leadingAnchor).isActive = true
            featuredImage.trailingAnchor.constraint(equalTo: superview.trailingAnchor).isActive = true
        }
    }
}

// MARK: - Delegates

extension PostTableViewCell: PostsDataViewCell {
    
    func load(_ model: PostsDataViewModel) {
        titleLabel.text = model.title
        summaryLabel.text = model.summary
        dateLabel.text = model.date
        featuredImage.setImage(from: model.imageURL)
    }
}
