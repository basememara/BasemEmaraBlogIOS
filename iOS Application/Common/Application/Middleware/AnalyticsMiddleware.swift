//
//  AnalyticsMiddleware.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2019-12-16.
//

struct AnalyticsMiddleware: MiddlewareType {
    
    func callAsFunction(_ input: InputType) {
        switch input {
        case MainState.Input.loadMenu:
            print("Analytics middleware triggered on action 'MainAction.fetchMenu'.")
        default:
            break
        }
    }
}
