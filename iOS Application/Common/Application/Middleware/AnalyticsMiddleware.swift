//
//  AnalyticsMiddleware.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2019-12-16.
//

struct AnalyticsMiddleware: MiddlewareType {
    
    func execute(on action: ActionType) {
        switch action {
        case MainAction.loadMenu:
            print("Analytics middleware triggered on action 'MainAction.loadMenu'.")
        default:
            break
        }
    }
}
