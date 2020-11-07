//
//  Preview.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2020-05-14.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

#if DEBUG && canImport(SwiftUI)
@testable import SwiftyPress
import SwiftUI
import UIKit
import ZamzamCore
import ZamzamUI

struct Preview {
    static let core = PreviewCore()
    static let store = AppStore()
    
    init() {
        Self.core.dataSeed().fetch {
            guard case .success(let data) = $0 else { return }
            
            let dataFormatter = DateFormatter(dateStyle: .medium)
            
            let posts = data.posts.map { post in
                PostsDataViewModel(
                    from: post,
                    mediaURL: data.media.first { $0.id == post.mediaID }?.link,
                    favorite: .random(),
                    dateFormatter: dataFormatter
                )
            }

            let terms = data.terms.map {
                TermsDataViewModel(
                    id: $0.id,
                    name: $0.name,
                    count: .localizedStringWithFormat("%d", $0.count),
                    taxonomy: $0.taxonomy
                )
            }
            
            Self.store.allPosts = Dictionary(uniqueKeysWithValues: posts.map { ($0.id, $0) })
            Self.store.allTerms = Dictionary(uniqueKeysWithValues: terms.map { ($0.id, $0) })
        }
    }
    
    //swiftlint:disable file_length
}

// MARK: - Data

extension Preview {
    
    static let mainState = MainState().apply {
        $0.tabMenu = [
            MainAPI.TabItem(
                id: .home,
                title: .localized(.tabHomeTitle),
                imageName: UIImage.ImageName.tabHome.rawValue
            ),
            MainAPI.TabItem(
                id: .blog,
                title: .localized(.tabBlogTitle),
                imageName: UIImage.ImageName.tabBlog.rawValue
            ),
            MainAPI.TabItem(
                id: .favorites,
                title: .localized(.tabFavoritesTitle),
                imageName: UIImage.ImageName.tabFavorite.rawValue
            ),
            MainAPI.TabItem(
                id: .search,
                title: .localized(.tabSearchTitle),
                imageName: UIImage.ImageName.tabSearch.rawValue
            ),
            MainAPI.TabItem(
                id: .more,
                title: .localized(.tabMoreTitle),
                imageName: UIImage.ImageName.tabMore.rawValue
            )
        ]
    }
}

extension Preview {
    
    static let homeState = HomeState().apply {
        $0.profile = HomeAPI.Profile(
            avatar: "BasemProfilePic",
            name: "John Doe",
            caption: "Quality Assurance / iOS"
        )
            
        $0.homeMenu = [
            HomeAPI.MenuSection(
                title: nil,
                items: [
                    HomeAPI.MenuItem(
                        type: .about,
                        title: "Company Info",
                        icon: "about"
                    ),
                    HomeAPI.MenuItem(
                        type: .portfolio,
                        title: "Customers",
                        icon: "portfolio"
                    )
                ]
            ),
            HomeAPI.MenuSection(
                title: "Services",
                items: [
                    HomeAPI.MenuItem(
                        type: .seriesScalableApp,
                        title: "Testing",
                        icon: "seriesScalableApp"
                    ),
                    HomeAPI.MenuItem(
                        type: .seriesSwiftUtilities,
                        title: "Reporting",
                        icon: "seriesSwiftUtilities"
                    )
                ]
            ),
            HomeAPI.MenuSection(
                title: "Something",
                items: [
                    HomeAPI.MenuItem(
                        type: .coursesArchitecture,
                        title: "Lorem Ipsum",
                        icon: "coursesArchitecture"
                    ),
                    HomeAPI.MenuItem(
                        type: .coursesFramework,
                        title: "Anything Else",
                        icon: "coursesFramework"
                    )
                ]
            )
        ]
        
        $0.socialMenu = [
            HomeAPI.SocialItem(
                type: .twitter,
                title: "Twitter"
            ),
            HomeAPI.SocialItem(
                type: .email,
                title: "Email"
            )
        ]
    }
}

extension Preview {
    
    static let showBlogState = ShowBlogState().apply {
        $0.latestPosts = store.allPosts?.values.shuffled().prefix(10).array
        $0.popularPosts = store.allPosts?.values.shuffled().prefix(10).array
        $0.topPickPosts = store.allPosts?.values.shuffled().prefix(10).array
        $0.terms = store.allTerms?.values.shuffled().prefix(10).array
    }
}

extension Preview {
    
    static let listFavoritesState = ListFavoritesState().apply {
        $0.favorites = store.allPosts?.values.shuffled().prefix(10).array
    }
}

extension Preview {
    
    static let listPostsState = ListPostsState().apply {
        $0.posts = store.allPosts?.values.shuffled().prefix(10).array
    }
}

extension Preview {
    
    static let showPostState: ShowPostState = {
        let model = ShowPostState()
        
        let presenter = ShowPostPresenter(
            model,
            constants: core.constants(),
            templateFile: Bundle.main.string(file: "post.html"),
            styleSheetFile: Bundle.main.string(file: "style.css")
        )
        
        core.dataSeed().fetch {
            guard case .success(let data) = $0, let post = data.posts.first else { return }
            
            presenter.displayPost(
                for: ShowPostAPI.Response(
                    post: post,
                    media: data.media.first { $0.id == post.mediaID },
                    categories: data.terms.filter { $0.taxonomy == .category },
                    tags: data.terms.filter { $0.taxonomy == .tag },
                    author: data.authors.first,
                    favorite: true
                )
            )
        }
        
        return model
    }()
}

extension Preview {
    
    static let searchPostsState = SearchPostsState().apply {
        $0.posts = store.allPosts?.values.shuffled().prefix(10).array
    }
}

extension Preview {
    
    static let listTermsState = ListTermsState().apply {
        $0.terms = store.allTerms?.values.shuffled().prefix(25).array
    }
}

extension Preview {
    
    static let showMoreState = ShowMoreState().apply {
        $0.moreMenu = [
            ShowMoreAPI.MenuSection(
                title: "Basem Emara",
                items: [
                    ShowMoreAPI.MenuItem(
                        type: .subscribe,
                        title: .localized(.moreMenuSubscribeTitle),
                        icon: UIImage.ImageName.signup.rawValue
                    ),
                    ShowMoreAPI.MenuItem(
                        type: .feedback,
                        title: .localized(.moreMenuFeedbackTitle),
                        icon: UIImage.ImageName.feedback.rawValue
                    ),
                    ShowMoreAPI.MenuItem(
                        type: .rate,
                        title: .localized(.moreMenuRateTitle),
                        icon: UIImage.ImageName.rating.rawValue
                    ),
                    ShowMoreAPI.MenuItem(
                        type: .share,
                        title: .localized(.moreMenuShareTitle),
                        icon: UIImage.ImageName.megaphone.rawValue
                    ),
                    ShowMoreAPI.MenuItem(
                        type: .settings,
                        title: .localized(.settings),
                        icon: UIImage.ImageName.settings.rawValue
                    )
                ]
            ),
            ShowMoreAPI.MenuSection(
                title: .localized(.moreMenuSocialSectionTitle),
                items: [
                    ShowMoreAPI.MenuItem(
                        type: .social,
                        title: "",
                        icon: ""
                    )
                ]
            ),
            ShowMoreAPI.MenuSection(
                title: .localized(.moreMenuOtherSectionTitle),
                items: [
                    ShowMoreAPI.MenuItem(
                        type: .developedBy,
                        title: .localized(.moreMenuDevelopedByTitle),
                        icon: UIImage.ImageName.design.rawValue
                    )
                ]
            )
        ]
        
        $0.socialMenu = [
            ShowMoreAPI.SocialItem(
                type: .linkedIn,
                title: .localized(.linkedInSocialTitle)
            ),
            ShowMoreAPI.SocialItem(
                type: .twitter,
                title: .localized(.twitterSocialTitle)
            )
        ]
    }
}

extension Preview {
    
    static let showSettings = ShowSettingsState().apply {
        $0.settingsMenu = [
            ShowSettingsAPI.MenuItem(
                type: .theme,
                title: .localized(.settingsMenuThemeTitle),
                icon: UIImage.ImageName.theme.rawValue
            ),
            ShowSettingsAPI.MenuItem(
                type: .notifications,
                title: .localized(.settingsMenuNotificationsTitle),
                icon: UIImage.ImageName.notifications.rawValue
            ),
            ShowSettingsAPI.MenuItem(
                type: .ios,
                title: .localized(.settingsMenuPhoneSettingsTitle),
                icon: UIImage.ImageName.phone.rawValue
            )
        ]
        
        $0.autoThemeEnabled = true
    }
}

// MARK: - Types

extension Preview {
    
    struct PreviewCore: SwiftyPressCore {
        
        func constantsService() -> ConstantsService {
            ConstantsStaticService(
                isDebug: true,
                itunesName: "",
                itunesID: "",
                baseURL: URL(safeString: "https://example.com"),
                baseREST: "",
                wpREST: "",
                email: "",
                privacyURL: "",
                disclaimerURL: nil,
                styleSheet: "",
                googleAnalyticsID: "",
                featuredCategoryID: 0,
                defaultFetchModifiedLimit: 0,
                taxonomies: [],
                postMetaKeys: [],
                minLogLevel: .none
            )
        }
        
        func preferencesService() -> PreferencesService {
            PreferencesDefaultsService(defaults: .standard)
        }
        
        func logServices() -> [LogService] {[]}
        
        func dataSeed() -> DataSeed {
            PreviewSeed()
        }
        
        func theme() -> Theme {
            AppTheme()
        }
        
        // swiftlint:disable line_length
        // swiftlint:disable nesting
        // swiftlint:disable function_body_length
        private struct PreviewSeed: DataSeed {
            func configure() {}
            func fetch(completion: (Result<SeedPayload, SwiftyPressError>) -> Void) {
                let payload = SeedPayload(
                    posts: [
                        Post(
                            id: 41373,
                            slug: "protocol-oriented-themes-for-ios-apps",
                            type: "post",
                            title: "Protocol-Oriented Themes for iOS Apps",
                            content: "<p>Themes are usually downplayed as an after-thought instead of being an integral part of the development process. How many times have you inherited a codebase where the design team wants to tweak it, or business wants you to clone the app with a whole different theme.</p>",
                            excerpt: "Themes are usually downplayed as an after-thought instead of being an integral part of the development process. How many times have you inherited a codebase where the design team wants to tweak it, or business wants you to clone the app with a whole different theme. In this post, I'm going to show you the native way of theming an iOS app as intended by Apple that is often overlooked.",
                            link: "https://basememara.com/protocol-oriented-themes-for-ios-apps/",
                            commentCount: 9,
                            authorID: 2,
                            mediaID: 41397,
                            terms: [
                                53,
                                62,
                                55,
                                81
                            ],
                            meta: [:],
                            createdAt: Date(fromString: "2018-09-29T17:12:15") ?? .distantPast,
                            modifiedAt: Date(fromString: "2020-05-20T00:12:19") ?? .distantPast
                        )
                    ],
                    authors: [
                        Author(
                            id: 2,
                            name: "Basem Emara",
                            link: "https://basememara.com",
                            avatar: "https://secure.gravatar.com/avatar/8def0d36f56d3e6720a44e41bf6f9a71?s=96&d=mm&r=g",
                            content: "Basem is a mobile and software IT professional with over 15 years of experience as an architect, developer, and consultant for dozens of projects that span over various industries for Fortune 500 enterprises, government agencies, and startups. In 2014, Swift was released and Basem brought his vast knowledge and experiences to help pioneer the language to build scalable enterprise iOS &amp; watchOS apps, later mentoring teams worldwide.",
                            createdAt: Date(fromString: "2015-02-02T03:39:52") ?? .distantPast,
                            modifiedAt: Date(fromString: "2020-03-19T04:50:01") ?? .distantPast
                        )
                    ],
                    media: [
                        Media(
                            id: 41397,
                            link: "https://basememara.com/wp-content/uploads/2018/09/Theme-Screenshot.png",
                            width: 2194,
                            height: 1554,
                            thumbnailLink: "https://basememara.com/wp-content/uploads/2018/09/Theme-Screenshot-500x354.png",
                            thumbnailWidth: 500,
                            thumbnailHeight: 354
                        )
                    ],
                    terms: [
                        Term(
                            id: 53,
                            parentID: 0,
                            slug: "ios",
                            name: "ios",
                            content: nil,
                            taxonomy: .tag,
                            count: 19
                        ),
                        Term(
                            id: 62,
                            parentID: 0,
                            slug: "protocol-oriented-programming",
                            name: "protocol-oriented-programming",
                            content: nil,
                            taxonomy: .tag,
                            count: 9
                        ),
                        Term(
                            id: 55,
                            parentID: 0,
                            slug: "swift",
                            name: "Swift",
                            content: nil,
                            taxonomy: .category,
                            count: 34
                        ),
                        Term(
                            id: 81,
                            parentID: 0,
                            slug: "uikit",
                            name: "uikit",
                            content: nil,
                            taxonomy: .tag,
                            count: 1
                        )
                    ]
                )
                
                completion(.success(payload))
            }
        }
    }
}

// MARK: - View

@available(iOS 13, *)
extension Preview {

    struct LocalePreview<Preview: View>: View {
        private let preview: Preview
        
        private let allLocales = Bundle.main.localizations
            .map(Locale.init).filter { $0.identifier != "base" }
        
        var body: some View {
            ForEach(allLocales, id: \.self) { locale in
                self.preview
                    .environment(\.locale, locale)
                    .previewDisplayName("Locale: \(locale.identifier)")
            }
        }
        
        init(@ViewBuilder builder: @escaping () -> Preview) {
            preview = builder()
        }
    }

    struct ContentSizeCategoryPreview<Preview: View>: View {
        private let preview: Preview
        private let sizeCategory: ContentSizeCategory
        
        var body: some View {
            preview
                .environment(\.sizeCategory, sizeCategory)
                .previewDisplayName("Content Size: \(sizeCategory)")
        }
        
        init(_ sizeCategory: ContentSizeCategory, @ViewBuilder builder: @escaping () -> Preview) {
            self.sizeCategory = sizeCategory
            preview = builder()
        }
    }

    struct DarkThemePreview<Preview: View>: View {
        private let preview: Preview
        
        var body: some View {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                preview
                    .environment(\.colorScheme, .dark)
                    .previewDevice(PreviewDevice(rawValue: "iPhone Xs Max"))
            }
            .previewDisplayName("Dark Theme")
        }
        
        init(@ViewBuilder builder: @escaping () -> Preview) {
            preview = builder()
        }
    }
}

@available(iOS 13, *)
extension UIViewController {
    
    var previews: some View {
        ViewRepresentable(viewController: self).previews
    }
    
    var previewsAll: some View {
        ViewRepresentable(viewController: self).previewsAll
    }
}

@available(iOS 13, *)
extension View {
    
    var previews: some View {
        Group {
            previewDarkTheme()
            previewSupportedLocales()
        }
    }
    
    var previewsAll: some View {
        Group {
            previewDarkTheme()
            previewSupportedLocales()
            previewContentSize(.extraSmall)
            previewContentSize(.extraExtraExtraLarge)
            preview_iPad()
        }
    }
    
    func previewSupportedLocales() -> some View {
        Preview.LocalePreview { self }
    }
    
    func previewDarkTheme() -> some View {
        Preview.DarkThemePreview { self }
    }
    
    func previewContentSize(_ sizeCategory: ContentSizeCategory) -> some View {
        Preview.ContentSizeCategoryPreview(sizeCategory) { self }
    }
    
    func preview_iPad() -> some View {
        self
            .previewDevice(PreviewDevice(rawValue: "iPad Pro (12.9-inch) (3rd generation)"))
            .previewDisplayName("iPad")
    }
}
#endif
