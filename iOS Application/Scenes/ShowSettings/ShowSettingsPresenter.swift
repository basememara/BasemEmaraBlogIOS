//
//  ShowMorePresenter.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2019-05-24.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

struct ShowSettingsPresenter: ShowSettingsPresenterType {
    private let send: SendAction<ShowSettingsState>
    
    init(send: @escaping SendAction<ShowSettingsState>) {
        self.send = send
    }
}

extension ShowSettingsPresenter {
    
    func display(menu: [ShowSettingsAPI.MenuItem]) {
        send(.loadMenu(menu))
    }
}

extension ShowSettingsPresenter {
    
    func displayTheme(for response: ShowSettingsAPI.SetThemeResponse) {
        send(.setAutoThemeEnabled(response.autoThemeEnabled))
    }
}
