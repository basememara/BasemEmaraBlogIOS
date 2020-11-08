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
    @ObservedObject var model: MainModel
    let interactor: MainInteractable?
    let render: MainRenderable
    
    var body: some View {
        TabView {
            ForEach(model.tabMenu ?? []) { menu in
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
