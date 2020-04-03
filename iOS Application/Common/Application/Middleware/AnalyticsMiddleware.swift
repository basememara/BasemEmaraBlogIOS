//
//  AnalyticsMiddleware.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2019-12-16.
//

struct AnalyticsMiddleware: MiddlewareType {
    
    func callAsFunction(_ action: ActionType) {
        switch action {
        case MainAction.fetchMenu:
            print("Analytics middleware triggered on action 'MainAction.fetchMenu'.")
        default:
            break
        }
    }
}
