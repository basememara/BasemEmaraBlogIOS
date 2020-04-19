//
//  MainView.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2020-04-12.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

#if canImport(SwiftUI)
import SwiftUI

@available(iOS 13, *)
struct MainView: View {
    @ObservedObject private var store: Store<MainState>
    private let interactor: MainInteractorType?
    private let render: MainRenderType
    
    init(store: Store<MainState>, interactor: MainInteractorType?, render: MainRenderType) {
        self.store = store
        self.interactor = interactor
        self.render = render
    }
    
    var body: some View {
        TabView {
            ForEach(store.state.tabMenu) { menu in
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
            self.interactor?.fetchMenu(
                for: UIDevice.current.userInterfaceIdiom
            )
        }
    }
}
#endif
