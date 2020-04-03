//
//  HomeState.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2019-12-19.
//

struct HomeState: StateType {
    var profileAvatar: String = ""
    var profileName: String = ""
    var profileCaption: String = ""
    var homeMenu: [HomeAPI.MenuSection] = []
    var socialMenu: [HomeAPI.SocialItem] = []
}
