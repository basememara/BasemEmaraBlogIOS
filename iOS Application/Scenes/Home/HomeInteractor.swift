//
//  HomeInteractor.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2020-04-02.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

struct HomeInteractor: HomeInteractorType {
    private let presenter: HomePresenterType
    
    init(presenter: HomePresenterType) {
        self.presenter = presenter
    }
}

extension HomeInteractor {
    
    func fetchProfile() {
        presenter.display(
            profile: HomeAPI.Profile(
                avatar: "BasemProfilePic",
                name: "Basem Emara",
                caption: "Mobile Architect / iOS Jedi"
            )
        )
    }
}

extension HomeInteractor {
    
    func fetchMenu() {
        let sections = [
            HomeAPI.MenuSection(
                title: nil,
                items: [
                    HomeAPI.MenuItem(
                        type: .about,
                        title: "About me"
                    ),
                    HomeAPI.MenuItem(
                        type: .portfolio,
                        title: "Portfolio"
                    )
                ]
            ),
            HomeAPI.MenuSection(
                title: "Series",
                items: [
                    HomeAPI.MenuItem(
                        type: .seriesScalableApp,
                        title: "Building Scalable iOS App"
                    ),
                    HomeAPI.MenuItem(
                        type: .seriesSwiftUtilities,
                        title: "Swift Utility Belt"
                    )
                ]
            ),
            HomeAPI.MenuSection(
                title: "Courses",
                items: [
                    HomeAPI.MenuItem(
                        type: .coursesArchitecture,
                        title: "iOS Architecture Masterclass"
                    ),
                    HomeAPI.MenuItem(
                        type: .coursesFramework,
                        title: "Building Swift Frameworks"
                    )
                ]
            ),
            HomeAPI.MenuSection(
                title: "Consulting",
                items: [
                    HomeAPI.MenuItem(
                        type: .consultingDevelopment,
                        title: "iOS Development"
                    ),
                    HomeAPI.MenuItem(
                        type: .consultingMentorship,
                        title: "Mentorship Express"
                    )
                ]
            )
        ]
        
        presenter.display(menu: sections)
    }
}

extension HomeInteractor {
    
    func fetchSocial() {
        let items = [
            HomeAPI.SocialItem(
                type: .github,
                title: "GitHub"
            ),
            HomeAPI.SocialItem(
                type: .linkedIn,
                title: "LinkedIn"
            ),
            HomeAPI.SocialItem(
                type: .twitter,
                title: "Twitter"
            ),
            HomeAPI.SocialItem(
                type: .email,
                title: "Email"
            )
        ]
        
        presenter.display(social: items)
    }
}
