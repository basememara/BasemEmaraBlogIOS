//
//  SceneRender.swift
//  Basem Emara
//
//  Created by Basem Emara on 2019-05-18.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import UIKit
import SwiftyPress

/// Dependency injector for overriding concrete scene factories.
protocol SceneRenderType {
    func launchMain() -> UIViewController
    
    func home() -> UIViewController
    func listFavorites() -> UIViewController
    func searchPosts() -> UIViewController
    
    func showBlog() -> UIViewController
    func listPosts(params: ListPostsAPI.Params, delegate: ListPostsDelegate?) -> UIViewController
    func showPost(for id: Int) -> UIViewController
    func listTerms() -> UIViewController
    
    func showMore() -> UIViewController
    func showSettings() -> UIViewController
}

extension SceneRenderType {
    
    func listPosts(params: ListPostsAPI.Params) -> UIViewController {
        listPosts(params: params, delegate: nil)
    }
}

struct SceneRender: SceneRenderType {
    private let core: SwiftyPressCore
    
    init(core: SwiftyPressCore) {
        self.core = core
    }
}

extension SceneRender {
    
    func launchMain() -> UIViewController {
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            return MainSplitViewController().with {
                $0.viewControllers = [
                    UINavigationController(rootViewController: home()),
                    MainSplitDetailViewController().with {
                        $0.viewControllers = [
                            UINavigationController(
                                rootViewController: showBlog().with {
                                    $0.tabBarItem = UITabBarItem(
                                        title: "Blog",
                                        image: UIImage(named: "tab-megaphone"),
                                        tag: Tab.blog.rawValue
                                    )
                                }
                            ),
                            UINavigationController(
                                rootViewController: listFavorites().with {
                                    $0.tabBarItem = UITabBarItem(
                                        title: "Favorites",
                                        image: UIImage(named: "tab-favorite"),
                                        tag: Tab.favorites.rawValue
                                    )
                                }
                            )
                            .with {
                                $0.navigationBar.prefersLargeTitles = true
                            },
                            UINavigationController(
                                rootViewController: searchPosts().with {
                                    $0.tabBarItem = UITabBarItem(
                                        title: "Search",
                                        image: UIImage(named: "tab-search"),
                                        tag: Tab.search.rawValue
                                    )
                                }
                            )
                            .with {
                                $0.navigationBar.prefersLargeTitles = true
                            },
                            UINavigationController(
                                rootViewController: showMore().with {
                                    $0.tabBarItem = UITabBarItem(
                                        title: "More",
                                        image: UIImage(named: "tab-more"),
                                        tag: Tab.more.rawValue
                                    )
                                }
                            )
                            .with {
                                $0.navigationBar.prefersLargeTitles = true
                            }
                        ]
                    }
                ]
            }
        default:
            return MainViewController().with {
                $0.viewControllers = [
                    UINavigationController(
                        rootViewController: home().with {
                            $0.tabBarItem = UITabBarItem(
                                title: "Home",
                                image: UIImage(named: "tab-home"),
                                tag: Tab.home.rawValue
                            )
                        }
                    ),
                    UINavigationController(
                        rootViewController: showBlog().with {
                            $0.tabBarItem = UITabBarItem(
                                title: "Blog",
                                image: UIImage(named: "tab-megaphone"),
                                tag: Tab.blog.rawValue
                            )
                        }
                    ),
                    UINavigationController(
                        rootViewController: listFavorites().with {
                            $0.tabBarItem = UITabBarItem(
                                title: "Favorites",
                                image: UIImage(named: "tab-favorite"),
                                tag: Tab.favorites.rawValue
                            )
                        }
                    )
                    .with {
                        $0.navigationBar.prefersLargeTitles = true
                    },
                    UINavigationController(
                        rootViewController: searchPosts().with {
                            $0.tabBarItem = UITabBarItem(
                                title: "Search",
                                image: UIImage(named: "tab-search"),
                                tag: Tab.search.rawValue
                            )
                        }
                    )
                    .with {
                        $0.navigationBar.prefersLargeTitles = true
                    },
                    UINavigationController(
                        rootViewController: showMore().with {
                            $0.tabBarItem = UITabBarItem(
                                title: "More",
                                image: UIImage(named: "tab-more"),
                                tag: Tab.more.rawValue
                            )
                        }
                    )
                    .with {
                        $0.navigationBar.prefersLargeTitles = true
                    }
                ]
            }
        }
    }
}

extension SceneRender {
    
    func home() -> UIViewController {
        let controller: HomeViewController = .make(fromStoryboard: Storyboard.home.rawValue)
        controller.core = HomeCore(core: core, render: self)
        return controller
    }
    
    func listFavorites() -> UIViewController {
        let controller: ListFavoritesViewController = .make(fromStoryboard: Storyboard.listFavorites.rawValue)
        controller.core = ListFavoritesCore(core: core, render: self)
        return controller
    }
    
    func searchPosts() -> UIViewController {
        let controller: SearchPostsViewController = .make(fromStoryboard: Storyboard.searchPosts.rawValue)
        controller.core = SearchPostsCore(core: core, render: self)
        return controller
    }
}

extension SceneRender {
    
    func showBlog() -> UIViewController {
        let controller: ShowBlogViewController = .make(fromStoryboard: Storyboard.showBlog.rawValue)
        controller.core = ShowBlogCore(core: core, render: self)
        return controller
    }
    
    func listPosts(params: ListPostsAPI.Params, delegate: ListPostsDelegate?) -> UIViewController {
        let controller: ListPostsViewController = .make(fromStoryboard: Storyboard.listPosts.rawValue)
        controller.params = params
        controller.delegate = delegate
        return controller
    }
    
    func showPost(for id: Int) -> UIViewController {
        let controller: ShowPostViewController = .make(fromStoryboard: Storyboard.showPost.rawValue)
        controller.postID = id
        return controller
    }
    
    func listTerms() -> UIViewController {
        .make(fromStoryboard: Storyboard.listTerms.rawValue)
    }
}

extension SceneRender {
    
    func showMore() -> UIViewController {
        .make(fromStoryboard: Storyboard.showMore.rawValue)
    }
    
    func showSettings() -> UIViewController {
        .make(fromStoryboard: Storyboard.showSettings.rawValue)
    }
}

extension SceneRender {
    
    /// Tab identifiers for routing
    enum Tab: Int {
        case home = 0
        case blog = 1
        case favorites = 2
        case search = 3
        case more = 4
    }
    
    /// Storyboard identifiers for routing
    enum Storyboard: String {
        case home = "Home"
        case listFavorites = "ListFavorites"
        case searchPosts = "SearchPosts"
        
        case showBlog = "ShowBlog"
        case listPosts = "ListPosts"
        case showPost = "ShowPost"
        case listTerms = "ListTerms"
        
        case showMore = "ShowMore"
        case showSettings = "ShowSettings"
    }
}
