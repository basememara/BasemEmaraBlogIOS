//
//  HomeInteractor.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2020-04-02.
//

import SwiftyPress

enum HomeAction: ActionType {
    case loadProfile(avatar: String, name: String, caption: String)
    case loadMenu([HomeAPI.MenuSection])
    case loadSocial([HomeAPI.SocialItem])
    case selectMenu(HomeAPI.MenuItem)
    case selectSocial(Social)
}

// MARK: - Logic

struct HomeInteractor: HomeInteractorType {
    let action: (HomeAction) -> Void
}

extension HomeInteractor {
    
    func fetchProfile() {
        action(.loadProfile(
            avatar: "BasemProfilePic",
            name: "Basem Emara",
            caption: "Mobile Architect / iOS Jedi"
        ))
    }
    
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
        
        action(.loadMenu(sections))
    }
    
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
        
        action(.loadSocial(items))
    }
    
    func select(menu: HomeAPI.MenuItem) {
        action(.selectMenu(menu))
    }
    
    func select(social: Social) {
        action(.selectSocial(social))
    }
}
