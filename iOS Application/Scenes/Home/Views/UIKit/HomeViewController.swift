//
//  HomeViewController.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2019-05-20.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import SwiftyPress
import UIKit
import ZamzamCore
import ZamzamUI

final class HomeViewController: UIViewController {
    private let store: Store<HomeState>
    private let interactor: HomeInteractorType?
    private var token: NotificationCenter.Token?
    
    // MARK: - Controls
    
    private lazy var tableView = UITableView(
        frame: .zero,
        style: .grouped
    ).with {
        $0.delegate = self
        $0.dataSource = self
        $0.tableHeaderView = headerView
    }
    
    private lazy var headerView = HomeHeaderView(store.state).with {
        $0.delegate = self
    }
    
    // MARK: - Initializers
    
    init(store: Store<HomeState>, interactor: HomeInteractorType?) {
        self.store = store
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepare()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

// MARK: - Configure

private extension HomeViewController {
    
    func prepare() {
        navigationController?.navigationBar.prefersLargeTitles = false
        
        view.addSubview(tableView)
        tableView.edges(to: view)
        
        store(in: &token, observer: load)
        
        interactor?.fetchProfile()
        interactor?.fetchMenu()
        interactor?.fetchSocial()
    }
    
    func load(_ state: HomeState) {
        headerView.load(state)
        tableView.reloadData()
    }
}

// MARK: - Delegates

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let item = store.state
            .homeMenu[safe: indexPath.section]?.items[safe: indexPath.row] else {
                return
        }
        
        interactor?.select(menu: item)
    }
}

extension HomeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        store.state.homeMenu.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        store.state.homeMenu[safe: section]?.items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        store.state.homeMenu[safe: section]?.title ??+ nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = store.state
            .homeMenu[safe: indexPath.section]?.items[safe: indexPath.row] else {
                return UITableViewCell()
        }
        
        return UITableViewCell(style: .default, reuseIdentifier: nil).with {
            $0.textLabel?.text = item.title
            $0.imageView?.image = UIImage(named: item.type.rawValue)
        }
    }
}

extension HomeViewController: HomeHeaderViewDelegate {
    
    func didTapSocialButton(_ sender: UIButton) {
        guard let item = Social.allCases[safe: sender.tag] else { return }
        interactor?.select(social: item)
    }
}

// MARK: - Preview

#if DEBUG && canImport(SwiftUI)
import SwiftUI

struct HomeViewController_Preview: PreviewProvider {
    
    static var previews: some View {
        Group {
            HomeViewRepresentable()
            
            HomeViewRepresentable()
                .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
                .colorScheme(.dark)
        }
    }
}

extension HomeViewController_Preview {
    
    struct HomeViewRepresentable: UIViewRepresentable {
        
        func makeUIView(context: Context) -> UIView {
            let testState = AppState(
                homeState: HomeState(
                    profileAvatar: "BasemProfilePic",
                    profileName: "John Doe",
                    profileCaption: "Quality Assurance / iOS",
                    homeMenu: [
                        HomeAPI.MenuSection(
                            title: nil,
                            items: [
                                HomeAPI.MenuItem(
                                    type: .about,
                                    title: "Company Info"
                                ),
                                HomeAPI.MenuItem(
                                    type: .portfolio,
                                    title: "Customers"
                                )
                            ]
                        ),
                        HomeAPI.MenuSection(
                            title: "Services",
                            items: [
                                HomeAPI.MenuItem(
                                    type: .seriesScalableApp,
                                    title: "Testing"
                                ),
                                HomeAPI.MenuItem(
                                    type: .seriesSwiftUtilities,
                                    title: "Reporting"
                                )
                            ]
                        ),
                        HomeAPI.MenuSection(
                            title: "Something",
                            items: [
                                HomeAPI.MenuItem(
                                    type: .coursesArchitecture,
                                    title: "Lorem Ipsum"
                                ),
                                HomeAPI.MenuItem(
                                    type: .coursesFramework,
                                    title: "Anything Else"
                                )
                            ]
                        )
                    ],
                    socialMenu: [
                        HomeAPI.SocialItem(
                            type: .twitter,
                            title: "Twitter"
                        ),
                        HomeAPI.SocialItem(
                            type: .email,
                            title: "Email"
                        )
                    ]
                )
            )
            
            return HomeViewController(
                store: Store(keyPath: \.homeState, for: testState),
                interactor: nil
            ).view ?? .init()
        }
        
        func updateUIView(_ view: UIView, context: Context) {}
    }
}
#endif
