//
//  ShowBlogViewController+Views.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2020-04-20.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import UIKit
import SwiftyPress
import ZamzamCore
import ZamzamUI

extension ShowBlogViewController {
    
    func makeScrollStackView(refreshAction action: Selector) -> ScrollStackView {
        ScrollStackView(
            insets: UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0),
            spacing: 16
        ).apply {
            $0.showsHorizontalScrollIndicator = false
            $0.showsVerticalScrollIndicator = false
            $0.refreshControl = UIRefreshControl().apply {
                $0.addTarget(self, action: action, for: .valueChanged)
            }
        }
    }
}

extension ShowBlogViewController {
    
    func makeTitle() -> UIView {
        UIStackView(
            arrangedSubviews: [
                UIImageView(imageNamed: "icon-nobg").apply {
                    $0.contentMode = .scaleAspectFit
                    $0.widthAnchor.constraint(equalToConstant: 30).isActive = true
                },
                ThemedLabel().apply {
                    $0.text = "Basem Emara"
                    $0.font = UIFont(name: "Helvetica", size: 21) ?? .systemFont(ofSize: 21)
                    $0.adjustsFontSizeToFitWidth = true
                    $0.minimumScaleFactor = 0.5
                }
            ]
        ).apply {
            $0.axis = .horizontal
            $0.spacing = 8
        }
    }
    
    func makeHeader(title: String, buttonTitle: String, buttonAction: Selector) -> UIView {
        UIStackView(
            arrangedSubviews: [
                ThemedSeparator().apply {
                    $0.translatesAutoresizingMaskIntoConstraints = false
                    $0.heightAnchor.constraint(equalToConstant: 1).isActive = true
                },
                UIStackView(
                    arrangedSubviews: [
                        ThemedHeadline().apply {
                            $0.text = title
                            $0.font = .preferredFont(forTextStyle: .headline)
                        },
                        UIButton(type: .system).apply {
                            $0.setTitle(buttonTitle, for: .normal)
                            $0.addTarget(self, action: buttonAction, for: .touchUpInside)
                            $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
                        }
                    ]
                ).apply {
                    $0.axis = .horizontal
                }
            ]
        ).apply {
            $0.axis = .vertical
            $0.spacing = 8
            $0.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            $0.isLayoutMarginsRelativeArrangement = true
        }
    }
    
    func makeFooter() -> UIView {
        UIStackView(
            arrangedSubviews: [
                ThemedSeparator().apply {
                    $0.translatesAutoresizingMaskIntoConstraints = false
                    $0.heightAnchor.constraint(equalToConstant: 1).isActive = true
                },
                UIStackView(
                    arrangedSubviews: [
                        ThemedButton(type: .system).apply {
                            $0.setTitle(.localized(.disclaimerButtonTitle), for: .normal)
                            $0.addTarget(self, action: #selector(didTapDisclaimerButton), for: .touchUpInside)
                        },
                        ThemedButton(type: .system).apply {
                            $0.setTitle(.localized(.privacyButtonTitle), for: .normal)
                            $0.addTarget(self, action: #selector(didTapPrivacyButton), for: .touchUpInside)
                        }
                    ]
                ).apply {
                    $0.axis = .horizontal
                    $0.distribution = .fillEqually
                    $0.spacing = 8
                },
                ThemedButton(type: .system).apply {
                    $0.setTitle(.localized(.contactButtonTitle), for: .normal)
                    $0.addTarget(self, action: #selector(didTapContactButton), for: .touchUpInside)
                }
            ]
        ).apply {
            $0.axis = .vertical
            $0.spacing = 16
            $0.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            $0.isLayoutMarginsRelativeArrangement = true
        }
    }
}

extension ShowBlogViewController {
    
    func makeLatestPostsCollectionView() -> UICollectionView {
        UICollectionView(
            frame: .zero,
            collectionViewLayout: SnapPagingLayout(
                centerPosition: true,
                peekWidth: 40,
                spacing: 20,
                inset: 16
            )
        ).apply {
            $0.register(LatestPostCollectionViewCell.self)
            $0.showsHorizontalScrollIndicator = false
            $0.showsVerticalScrollIndicator = false
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.heightAnchor.constraint(equalToConstant: 230).isActive = true
        }
    }
    
    func makePopularPostsCollectionView() -> UICollectionView {
        UICollectionView(
            frame: .zero,
            collectionViewLayout: MultiRowLayout(
                rowsCount: 3,
                inset: 16
            )
        ).apply {
            $0.register(PopularPostCollectionViewCell.self)
            $0.decelerationRate = .fast
            $0.showsHorizontalScrollIndicator = false
            $0.showsVerticalScrollIndicator = false
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.heightAnchor.constraint(equalToConstant: 300).isActive = true
        }
    }
    
    func makePickedPostsCollectionView() -> UICollectionView {
        UICollectionView(
            frame: .zero,
            collectionViewLayout: SnapPagingLayout(
                centerPosition: false,
                peekWidth: 20,
                spacing: 10,
                inset: 16
            )
        ).apply {
            $0.register(PickedPostCollectionViewCell.self)
            $0.showsHorizontalScrollIndicator = false
            $0.showsVerticalScrollIndicator = false
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.heightAnchor.constraint(equalToConstant: 150).isActive = true
        }
    }
    
    func makeTopTermsTableView() -> UITableView {
        UITableView().apply {
            $0.register(TermTableViewCell.self)
            $0.showsHorizontalScrollIndicator = false
            $0.showsVerticalScrollIndicator = false
            $0.isScrollEnabled = false
            $0.tableFooterView = UIView()
            $0.sectionHeaderHeight = 28
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.heightAnchor.constraint(equalToConstant: 280).isActive = true
        }
    }
}
