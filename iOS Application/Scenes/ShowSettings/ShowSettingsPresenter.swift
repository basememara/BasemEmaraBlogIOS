//
//  ShowMorePresenter.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2019-05-24.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

struct ShowSettingsPresenter: ShowSettingsPresentable {
    private let dispatch: Dispatcher<ShowSettingsAction>
    
    init(dispatch: @escaping Dispatcher<ShowSettingsAction>) {
        self.dispatch = dispatch
    }
}

extension ShowSettingsPresenter {
    
    func display(menu: [ShowSettingsAPI.MenuItem]) {
        dispatch(.loadMenu(menu))
    }
}

extension ShowSettingsPresenter {
    
    func displayTheme(for response: ShowSettingsAPI.SetThemeResponse) {
        dispatch(.setAutoThemeEnabled(response.autoThemeEnabled))
    }
}
