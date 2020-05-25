//
//  NotificationViewController.swift
//  Post Notification Extension
//
//  Created by Basem Emara on 2018-05-20.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController {

    // MARK: - Controls
    
    private lazy var titleLabel = UILabel().apply {
        $0.font = .preferredFont(forTextStyle: .headline)
        $0.numberOfLines = 0
    }
    
    private lazy var detailLabel = UILabel().apply {
        $0.font = .preferredFont(forTextStyle: .subheadline)
        $0.numberOfLines = 0
    }
    
    private lazy var featuredImage = UIImageView(imageNamed: .placeholder).apply {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 200))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepare()
    }
}

// MARK: - Setup

private extension NotificationViewController {
    
    func prepare() {
        // Compose layout
        let stackView = UIStackView(arrangedSubviews: [
            featuredImage,
            UIView().apply {
                $0.addSubview(
                    titleLabel.apply {
                        $0.setContentHuggingPriority(.init(rawValue: 751), for: .vertical)
                        $0.setContentCompressionResistancePriority(.init(rawValue: 752), for: .vertical)
                    }
                )
            },
            UIView().apply {
                $0.addSubview(
                    detailLabel.apply {
                        $0.setContentHuggingPriority(.init(rawValue: 750), for: .vertical)
                        $0.setContentCompressionResistancePriority(.init(rawValue: 751), for: .vertical)
                    }
                )
            }
        ]).apply {
            $0.axis = .vertical
            $0.distribution = .fill
            $0.alignment = .fill
            $0.spacing = 16
        }
        
        view.addSubview(stackView)
        
        stackView.edges(to: view, insets: UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0), safeArea: true)
        titleLabel.edges(to: titleLabel.superview, insets: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
        detailLabel.edges(to: detailLabel.superview, insets: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
        
        featuredImage.translatesAutoresizingMaskIntoConstraints = false
        featuredImage.heightAnchor.constraint(greaterThanOrEqualToConstant: 200).isActive = true
    }
}

// MARK: - Delegates

extension NotificationViewController: UNNotificationContentExtension {
    
    func didReceive(_ notification: UNNotification) {
        titleLabel.text = notification.request.content.title
        detailLabel.text = notification.request.content.body
        
        featuredImage.setImage(
            from: notification.request.content.userInfo["mediaURL"] as? String
        )
    }
}
