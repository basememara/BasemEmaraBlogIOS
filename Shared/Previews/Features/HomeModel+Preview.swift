//
//  HomeModel+Preview.swift
//  iOS
//
//  Created by Basem Emara on 2020-11-07.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

extension HomeModel {
    
    static let preview = HomeModel().apply {
        $0.profile = HomeAPI.Profile(
            avatar: "BasemProfilePic",
            name: "John Doe",
            caption: "Quality Assurance / iOS"
        )
        
        $0.homeMenu = [
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
        ]
        
        $0.socialMenu = [
            HomeAPI.SocialItem(
                type: .twitter,
                title: "Twitter"
            ),
            HomeAPI.SocialItem(
                type: .email,
                title: "Email"
            )
        ]
    }
}
