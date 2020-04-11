//
//  MainInteractor.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2019-12-15.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import UIKit.UIDevice

struct MainInteractor: MainInteractorType {
    private let presenter: MainPresenterType
    
    init(presenter: MainPresenterType) {
        self.presenter = presenter
    }
}

extension MainInteractor {
    
    func fetchMenu(for idiom: UIUserInterfaceIdiom) {
        var menu: [MainAPI.Menu] = [.blog, .favorites, .search, .more]
        
        if case .phone = idiom {
            menu.prepend(.home)
        }
        
        presenter.display(menu: menu)
    }
}
