//
//  HomeInteractor.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2020-04-02.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

struct HomeInteractor: HomeInteractable {
    private let presenter: HomePresentable
    
    init(presenter: HomePresentable) {
        self.presenter = presenter
    }
}

extension HomeInteractor {
    
    func fetchProfile() {
        presenter.display(
            profile: HomeAPI.Profile(
                avatar: "BasemProfilePic",
                name: .localized(.homeProfileName),
                caption: .localized(.homeProfileCaption)
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
                        title: .localized(.homeMenuAboutTitle),
                        icon: "about"
                    ),
                    HomeAPI.MenuItem(
                        type: .portfolio,
                        title: .localized(.homeMenuPortfolioTitle),
                        icon: "portfolio"
                    )
                ]
            ),
            HomeAPI.MenuSection(
                title: "Series",
                items: [
                    HomeAPI.MenuItem(
                        type: .seriesScalableApp,
                        title: .localized(.homeMenuSeriesScalableAppTitle),
                        icon: "seriesScalableApp"
                    ),
                    HomeAPI.MenuItem(
                        type: .seriesSwiftUtilities,
                        title: .localized(.homeMenuSeriesSwiftUtilitiesTitle),
                        icon: "seriesSwiftUtilities"
                    )
                ]
            ),
            HomeAPI.MenuSection(
                title: "Courses",
                items: [
                    HomeAPI.MenuItem(
                        type: .coursesArchitecture,
                        title: .localized(.homeMenuCoursesArchitectureTitle),
                        icon: "coursesArchitecture"
                    ),
                    HomeAPI.MenuItem(
                        type: .coursesFramework,
                        title: .localized(.homeMenuCoursesFrameworkTitle),
                        icon: "coursesFramework"
                    )
                ]
            ),
            HomeAPI.MenuSection(
                title: "Consulting",
                items: [
                    HomeAPI.MenuItem(
                        type: .consultingDevelopment,
                        title: .localized(.homeMenuConsultingDevelopmentTitle),
                        icon: "consultingDevelopment"
                    ),
                    HomeAPI.MenuItem(
                        type: .consultingMentorship,
                        title: .localized(.homeMenuConsultingMentorshipTitle),
                        icon: "consultingMentorship"
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
                title: .localized(.githubSocialTitle)
            ),
            HomeAPI.SocialItem(
                type: .linkedIn,
                title: .localized(.linkedInSocialTitle)
            ),
            HomeAPI.SocialItem(
                type: .twitter,
                title: .localized(.twitterSocialTitle)
            ),
            HomeAPI.SocialItem(
                type: .email,
                title: .localized(.emailSocialTitle)
            )
        ]
        
        presenter.display(social: items)
    }
}
