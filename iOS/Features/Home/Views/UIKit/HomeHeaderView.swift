//
//  HomeHeaderView.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2020-03-30.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import SwiftyPress
import UIKit
import ZamzamUI

// MARK: - Protocol

@objc protocol HomeHeaderViewDelegate: AnyObject {
    func didTapSocialButton(_ sender: UIButton)
}

// MARK: - View

class HomeHeaderView: UIView {
    private weak var delegate: HomeHeaderViewDelegate?
    
    // MARK: - Controls
    
    private lazy var stackView = UIStackView().apply {
        $0.axis = .vertical
        $0.alignment = .center
        $0.distribution = .fill
        $0.spacing = 8
    }
    
    private lazy var profileAvatarImageView = RoundedImageView().apply {
        $0.contentMode = .scaleAspectFit
        $0.heightAnchor.constraint(equalTo: $0.widthAnchor, multiplier: 1).isActive = true
    }
    
    private lazy var profileNameLabel = ThemedHeadline().apply {
        $0.font = .preferredFont(forTextStyle: .headline)
        $0.setContentHuggingPriority(.defaultHigh, for: .vertical)
        $0.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        $0.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 752), for: .vertical)
    }
    
    private lazy var profileCaptionLabel = ThemedSubhead().apply {
        $0.font = .preferredFont(forTextStyle: .footnote)
        $0.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        $0.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 751), for: .vertical)
    }
    
    private lazy var socialStackView = UIStackView().apply {
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .fillEqually
        $0.spacing = 12
    }
    
    // MARK: - Initializers
    
    init(delegate: HomeHeaderViewDelegate?) {
        self.delegate = delegate
        
        super.init(frame: .zero)
        self.prepare()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }
}

// MARK: - Setup

private extension HomeHeaderView {
    
    func prepare() {
        frame.size.height = 200
        addSubview(stackView)
        
        stackView.addArrangedSubviews([
            profileAvatarImageView,
            profileNameLabel,
            profileCaptionLabel,
            socialStackView
        ])
        
        let insets = UIEdgeInsets(top: 8, left: 8, bottom: 16, right: 8)
        stackView.edges(to: self, insets: insets)
    }
}

// MARK: - State

extension HomeHeaderView {
    
    func load(profile: HomeAPI.Profile) {
        profileAvatarImageView.image = UIImage(named: profile.avatar)
        profileNameLabel.text = profile.name
        profileCaptionLabel.text = profile.caption
    }
    
    func load(socialMenu: [HomeAPI.SocialItem]) {
        socialStackView
            .deleteArrangedSubviews()
            .addArrangedSubviews(socialMenu.compactMap {
                guard let delegate = delegate else { return nil }
                
                return SocialButton(
                    social: $0.type,
                    target: delegate,
                    action: #selector(delegate.didTapSocialButton)
                )
            })
    }
}
