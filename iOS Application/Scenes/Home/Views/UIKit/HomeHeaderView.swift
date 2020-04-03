//
//  HomeHeaderView.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2020-03-30.
//

import SwiftyPress
import UIKit
import ZamzamUI

@objc protocol HomeHeaderViewDelegate: AnyObject {
    func didTapSocialButton(_ sender: UIButton)
}

class HomeHeaderView: UIView {
    weak var delegate: HomeHeaderViewDelegate?
    
    private lazy var stackView = UIStackView().with {
        $0.axis = .vertical
        $0.alignment = .center
        $0.distribution = .fill
        $0.spacing = 8
    }
    
    private lazy var profileAvatarImageView = RoundedImageView().with {
        $0.contentMode = .scaleAspectFit
        $0.heightAnchor.constraint(equalTo: $0.widthAnchor, multiplier: 1).isActive = true
    }
    
    private lazy var profileNameLabel = ThemedHeadline().with {
        $0.font = .preferredFont(forTextStyle: .headline)
        $0.setContentHuggingPriority(.defaultHigh, for: .vertical)
        $0.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        $0.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 752), for: .vertical)
    }
    
    private lazy var profileCaptionLabel = ThemedSubhead().with {
        $0.font = .preferredFont(forTextStyle: .footnote)
        $0.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        $0.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 751), for: .vertical)
    }
    
    private lazy var socialStackView = UIStackView().with {
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .fillEqually
        $0.spacing = 12
    }
    
    convenience init(_ state: HomeState) {
        self.init()
        self.prepare()
        self.load(state)
    }
}

private extension HomeHeaderView {
    
    func prepare() {
        frame.size.height = 200 // TODO: Extract to design tokens
        addSubview(stackView)
        
        stackView.addArrangedSubviews([
            profileAvatarImageView,
            profileNameLabel,
            profileCaptionLabel,
            socialStackView
        ])
        
        let insets = UIEdgeInsets(top: 8, left: 8, bottom: 16, right: 8) // TODO: Extract to design tokens
        stackView.edges(to: self, insets: insets)
    }
}

extension HomeHeaderView {
    
    func load(_ state: HomeState) {
        profileAvatarImageView.image = UIImage(named: state.profileAvatar)
        profileNameLabel.text = state.profileName
        profileCaptionLabel.text = state.profileCaption
        
        socialStackView
            .deleteArrangedSubviews()
            .addArrangedSubviews(state.socialMenu.map { social in
                UIButton(type: .custom).with {
                    $0.setImage(UIImage(named: social.type.rawValue), for: .normal)
                    $0.contentMode = .scaleAspectFit
                    $0.heightAnchor.constraint(equalToConstant: 32).isActive = true
                    $0.heightAnchor.constraint(equalTo: $0.widthAnchor, multiplier: 1).isActive = true
                    
                    if let delegate = delegate, let index = social.type.index() {
                        $0.addTarget(delegate, action: #selector(delegate.didTapSocialButton), for: .touchUpInside)
                        $0.tag = index
                    }
                }
            })
    }
}
