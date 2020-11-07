//
//  MainView.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2020-04-12.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

#if canImport(SwiftUI)
import SwiftUI
import ZamzamUI

@available(iOS 13, *)
struct MainView: View {
    @ObservedObject private var state: MainState
    private let interactor: MainInteractable?
    private let render: MainRenderable

    init(state: MainState, interactor: MainInteractable?, render: MainRenderable) {
        self.state = state
        self.interactor = interactor
        self.render = render
    }
    
    var body: some View {
        TabView {
            ForEach(state.tabMenu ?? []) { menu in
                NavigationView {
                    ViewRepresentable(
                        viewController: render.rootView(for: menu.id)
                    )
                }
                .tabItem {
                    Image(menu.imageName)
                    Text(menu.title)
                }
                .tag(menu.id)
            }
        }.onAppear {
            self.interactor?.fetchMenu(
                for: UIDevice.current.userInterfaceIdiom
            )
        }
    }
}
#endif
