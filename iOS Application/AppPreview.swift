//
//  AppPreview.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2020-05-14.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

struct AppPreview {
    // Usede to store sample data
}

extension AppPreview {
    
    static let homeState = HomeState(
        profile: HomeAPI.Profile(
            avatar: "BasemProfilePic",
            name: "John Doe",
            caption: "Quality Assurance / iOS"
        ),
        homeMenu: [
            HomeAPI.MenuSection(
                title: nil,
                items: [
                    HomeAPI.MenuItem(
                        type: .about,
                        title: "Company Info",
                        icon: "about"
                    ),
                    HomeAPI.MenuItem(
                        type: .portfolio,
                        title: "Customers",
                        icon: "portfolio"
                    )
                ]
            ),
            HomeAPI.MenuSection(
                title: "Services",
                items: [
                    HomeAPI.MenuItem(
                        type: .seriesScalableApp,
                        title: "Testing",
                        icon: "seriesScalableApp"
                    ),
                    HomeAPI.MenuItem(
                        type: .seriesSwiftUtilities,
                        title: "Reporting",
                        icon: "seriesSwiftUtilities"
                    )
                ]
            ),
            HomeAPI.MenuSection(
                title: "Something",
                items: [
                    HomeAPI.MenuItem(
                        type: .coursesArchitecture,
                        title: "Lorem Ipsum",
                        icon: "coursesArchitecture"
                    ),
                    HomeAPI.MenuItem(
                        type: .coursesFramework,
                        title: "Anything Else",
                        icon: "coursesFramework"
                    )
                ]
            )
        ],
        socialMenu: [
            HomeAPI.SocialItem(
                type: .twitter,
                title: "Twitter"
            ),
            HomeAPI.SocialItem(
                type: .email,
                title: "Email"
            )
        ]
    )
}
