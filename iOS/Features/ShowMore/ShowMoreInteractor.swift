//
//  ShowMoreInteractor.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2020-04-02.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import UIKit.UIImage

struct ShowMoreInteractor: ShowMoreInteractable {
    private let presenter: ShowMorePresentable
    
    init(presenter: ShowMorePresentable) {
        self.presenter = presenter
    }
}

extension ShowMoreInteractor {
    
    func fetchMenu() {
        let sections = [
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
                        type: .work,
                        title: .localized(.moreMenuWorkTitle),
                        icon: UIImage.ImageName.idea.rawValue
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
        
        presenter.display(menu: sections)
    }
}

extension ShowMoreInteractor {
    
    func fetchSocial() {
        let items = [
            ShowMoreAPI.SocialItem(
                type: .github,
                title: .localized(.githubSocialTitle)
            ),
            ShowMoreAPI.SocialItem(
                type: .linkedIn,
                title: .localized(.linkedInSocialTitle)
            ),
            ShowMoreAPI.SocialItem(
                type: .twitter,
                title: .localized(.twitterSocialTitle)
            )
        ]
        
        presenter.display(social: items)
    }
}
