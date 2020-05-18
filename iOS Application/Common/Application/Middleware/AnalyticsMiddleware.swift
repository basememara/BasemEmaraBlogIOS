//
//  AnalyticsMiddleware.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2019-12-16.
//

struct AnalyticsMiddleware: Middleware {
    
    func callAsFunction(_ action: Action) {
        switch action {
        case MainAction.loadMenu:
            print("Analytics middleware triggered on action 'MainAction.fetchMenu'.")
        default:
            break
        }
    }
}
