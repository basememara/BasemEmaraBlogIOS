//
//  MainAction.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2019-12-15.
//

import UIKit.UIDevice

struct MainAction: MainActionType {
    private let presenter: MainPresenterType
    
    init(presenter: MainPresenterType) {
        self.presenter = presenter
    }
}

extension MainAction {
    
    func fetchMenu(for idiom: UIUserInterfaceIdiom) {
        var menu: [MainAPI.Menu] = [.blog, .favorites, .search, .more]
        
        if case .phone = idiom {
            menu.prepend(.home)
        }
        
        presenter.load(menu: menu)
    }
}
