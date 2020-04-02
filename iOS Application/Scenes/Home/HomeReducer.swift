//
//  HomeReducer.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2019-12-29.
//

struct HomeReducer: HomeReducerType {
    private let render: HomeRenderType
    
    init(render: HomeRenderType) {
        self.render = render
    }
}

extension HomeReducer {
    
    func callAsFunction(_ state: inout HomeState, _ action: HomeAction) {
        switch action {
        case .loadProfile(let avatar, let name, let caption):
            state.profileAvatar = avatar
            state.profileName = name
            state.profileCaption = caption
        case .loadMenu(let sections):
            state.homeMenu = sections
        case .loadSocial(let social):
            state.socialMenu = social
        case .selectMenu(let item):
            switch item.type {
            case .about:
                render.showAbout()
            case .portfolio:
                render.showPortfolio()
            case .seriesScalableApp:
                render.showSeriesScalableApp(title: item.title)
            case .seriesSwiftUtilities:
                render.showSeriesSwiftUtilities(title: item.title)
            case .coursesArchitecture:
                render.showCoursesArchitecture()
            case .coursesFramework:
                render.showCoursesFramework()
            case .consultingDevelopment:
                render.showConsultingDevelopment()
            case .consultingMentorship:
                render.showConsultingMentorship()
            }
        case .selectSocial(let social):
            render.show(social: social)
        }
    }
}
