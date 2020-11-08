//
//  ShowMoreModel+Preview.swift
//  iOS
//
//  Created by Basem Emara on 2020-11-07.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import UIKit.UIImage

extension ShowMoreModel {
    
    static let preview = ShowMoreModel().apply {
        $0.moreMenu = [
            ShowMoreAPI.MenuSection(
                title: "Basem Emara",
                items: [
                    ShowMoreAPI.MenuItem(
                        type: .subscribe,
                        title: .localized(.moreMenuSubscribeTitle),
                        icon: UIImage.ImageName.signup.rawValue
                    ),
                    ShowMoreAPI.MenuItem(
                        type: .feedback,
                        title: .localized(.moreMenuFeedbackTitle),
                        icon: UIImage.ImageName.feedback.rawValue
                    ),
                    ShowMoreAPI.MenuItem(
                        type: .rate,
                        title: .localized(.moreMenuRateTitle),
                        icon: UIImage.ImageName.rating.rawValue
                    ),
                    ShowMoreAPI.MenuItem(
                        type: .share,
                        title: .localized(.moreMenuShareTitle),
                        icon: UIImage.ImageName.megaphone.rawValue
                    ),
                    ShowMoreAPI.MenuItem(
                        type: .settings,
                        title: .localized(.settings),
                        icon: UIImage.ImageName.settings.rawValue
                    )
                ]
            ),
            ShowMoreAPI.MenuSection(
                title: .localized(.moreMenuSocialSectionTitle),
                items: [
                    ShowMoreAPI.MenuItem(
                        type: .social,
                        title: "",
                        icon: ""
                    )
                ]
            ),
            ShowMoreAPI.MenuSection(
                title: .localized(.moreMenuOtherSectionTitle),
                items: [
                    ShowMoreAPI.MenuItem(
                        type: .developedBy,
                        title: .localized(.moreMenuDevelopedByTitle),
                        icon: UIImage.ImageName.design.rawValue
                    )
                ]
            )
        ]
        
        $0.socialMenu = [
            ShowMoreAPI.SocialItem(
                type: .linkedIn,
                title: .localized(.linkedInSocialTitle)
            ),
            ShowMoreAPI.SocialItem(
                type: .twitter,
                title: .localized(.twitterSocialTitle)
            )
        ]
    }
}
