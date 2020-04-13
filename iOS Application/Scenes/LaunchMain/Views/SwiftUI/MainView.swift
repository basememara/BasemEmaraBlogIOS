//
//  MainView.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2020-04-12.
//

#if canImport(SwiftUI)
import SwiftUI

@available(iOS 13, *)
struct MainView: View {
    @ObservedObject private var store: Store<MainState>
    private let interactor: MainInteractorType?
    
    init(store: Store<MainState>, interactor: MainInteractorType?) {
        self.store = store
        self.interactor = interactor
    }
    
    var body: some View {
        TabView {
            ForEach(store.state.tabMenu) { menu in
                NavigationView {
                    ViewRepresentable(viewController: menu.view)
                }
                .tabItem {
                    Image(menu.item.imageName)
                    Text(menu.item.title)
                }
                .tag(menu.item.id)
            }
        }.onAppear {
            self.interactor?.fetchMenu(
                for: UIDevice.current.userInterfaceIdiom
            )
        }
    }
}
#endif
