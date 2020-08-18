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
    private let action: MainActionable?
    private let render: MainRenderable

    init(state: MainState, action: MainActionable?, render: MainRenderable) {
        self.state = state
        self.action = action
        self.render = render
    }
    
    var body: some View {
        TabView {
            ForEach(state.tabMenu) { menu in
                NavigationView {
                    ViewRepresentable(
                        viewController: self.render.rootView(for: menu.id)
                    )
                }
                .tabItem {
                    Image(menu.imageName)
                    Text(menu.title)
                }
                .tag(menu.id)
            }
        }.onAppear {
            self.action?.fetchMenu(
                for: UIDevice.current.userInterfaceIdiom
            )
        }
    }
}
#endif
