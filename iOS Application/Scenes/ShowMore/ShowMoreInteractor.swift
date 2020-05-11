//
//  HomeInteractor.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2020-04-02.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

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
                        title: "Subscribe",
                        icon: "signup"
                    ),
                    ShowMoreAPI.MenuItem(
                        type: .feedback,
                        title: "Send me an email",
                        icon: "feedback"
                    ),
                    ShowMoreAPI.MenuItem(
                        type: .work,
                        title: "Work with me",
                        icon: "idea"
                    ),
                    ShowMoreAPI.MenuItem(
                        type: .rate,
                        title: "Rate my app",
                        icon: "rating"
                    ),
                    ShowMoreAPI.MenuItem(
                        type: .share,
                        title: "Share my app",
                        icon: "megaphone"
                    ),
                    ShowMoreAPI.MenuItem(
                        type: .settings,
                        title: "Settings",
                        icon: "settings"
                    )
                ]
            ),
            ShowMoreAPI.MenuSection(
                title: "Social",
                items: [
                    ShowMoreAPI.MenuItem(
                        type: .social,
                        title: "",
                        icon: ""
                    )
                ]
            ),
            ShowMoreAPI.MenuSection(
                title: "Other",
                items: [
                    ShowMoreAPI.MenuItem(
                        type: .developedBy,
                        title: "Developed by Basem Emara",
                        icon: "design"
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
                title: "GitHub"
            ),
            ShowMoreAPI.SocialItem(
                type: .linkedIn,
                title: "LinkedIn"
            ),
            ShowMoreAPI.SocialItem(
                type: .twitter,
                title: "Twitter"
            )
        ]
        
        presenter.display(social: items)
    }
}
