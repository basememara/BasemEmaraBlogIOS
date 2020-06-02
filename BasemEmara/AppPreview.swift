//
//  AppPreview.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2020-05-14.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

#if DEBUG && canImport(SwiftUI)
import SwiftyPress
import SwiftUI
import UIKit
import ZamzamCore
import ZamzamUI

struct AppPreview {
    static let core = PreviewCore()
}

extension AppPreview {
    //swiftlint:disable file_length
}

// MARK: - Data

extension AppPreview {
    
    static let postsState = PostsState().apply { state in
        // Retrive data from seed file
        core.dataSeed().fetch {
            guard case .success(let data) = $0 else { return }
            
            let dataFormatter = DateFormatter(dateStyle: .medium)
            
            let posts = data.posts.map { post in
                PostsDataViewModel(
                    from: post,
                    mediaURL: data.media.first { $0.id == post.mediaID }?.link,
                    favorite: .random(),
                    dateFormatter: dataFormatter)
            }
            
            state(.mergePosts(posts))
        }
    }
}

extension AppPreview {
    
    static let termsState = TermsState().apply { state in
        // Retrive data from seed file
        core.dataSeed().fetch {
            guard case .success(let data) = $0 else { return }
            
            let dataFormatter = DateFormatter(dateStyle: .medium)
            
            let terms = data.terms.map {
                TermsDataViewModel(
                    id: $0.id,
                    name: $0.name,
                    count: .localizedStringWithFormat("%d", $0.count),
                    taxonomy: $0.taxonomy
                )
            }
            
            state(.mergeTerms(terms))
        }
    }
}

extension AppPreview {
    
    static let mainState = MainState().apply {
        $0(.loadMenu([
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
        ]))
    }
}

extension AppPreview {
    
    static let homeState = HomeState().apply {
        $0(.loadProfile(
            HomeAPI.Profile(
                avatar: "BasemProfilePic",
                name: "John Doe",
                caption: "Quality Assurance / iOS"
            )
        ))
            
        $0(.loadMenu([
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
        ]))
        
        $0(.loadSocial([
            HomeAPI.SocialItem(
                type: .twitter,
                title: "Twitter"
            ),
            HomeAPI.SocialItem(
                type: .email,
                title: "Email"
            )
        ]))
    }
}

extension AppPreview {
    
    static let showBlogState = ShowBlogState(
        postsState: postsState,
        termsState: termsState
    ).apply {
        $0(.loadLatestPosts(postsState.allPosts.values.shuffled().prefix(10).array))
        $0(.loadPopularPosts(postsState.allPosts.values.shuffled().prefix(10).array))
        $0(.loadTopPickPosts(postsState.allPosts.values.shuffled().prefix(10).array))
        $0(.loadTerms(termsState.allTerms.values.shuffled().prefix(10).array))
    }
}

extension AppPreview {
    
    static let listFavoritesState = ListFavoritesState(postsState: postsState).apply {
        $0(.loadFavorites(postsState.allPosts.values.shuffled().prefix(10).array))
    }
}

extension AppPreview {
    
    static let listPostsState = ListPostsState(postsState: postsState).apply {
        $0(.loadPosts(postsState.allPosts.values.shuffled().prefix(10).array))
    }
}

extension AppPreview {
    
    static let showPostState: ShowPostState = {
        let state = ShowPostState(postsState: Self.postsState)
        
        let presenter = ShowPostPresenter(
            state: { state($0) },
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
        
        return state
    }()
}

extension AppPreview {
    
    static let searchPostsState = SearchPostsState().apply {
        $0(.loadPosts(postsState.allPosts.values.shuffled().prefix(10).array))
    }
}

extension AppPreview {
    
    static let listTermsState = ListTermsState().apply {
        $0(.loadTerms(termsState.allTerms.values.shuffled().prefix(25).array))
    }
}

extension AppPreview {
    
    static let showMoreState = ShowMoreState().apply {
        $0(.loadMenu([
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
        ]))
        
        $0(.loadSocial([
            ShowMoreAPI.SocialItem(
                type: .linkedIn,
                title: .localized(.linkedInSocialTitle)
            ),
            ShowMoreAPI.SocialItem(
                type: .twitter,
                title: .localized(.twitterSocialTitle)
            )
        ]))
    }
}

extension AppPreview {
    
    static let showSettings = ShowSettingsState().apply {
        $0(.loadMenu([
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
        ]))
        
        $0(.setAutoThemeEnabled(true))
    }
}

// MARK: - Types

extension AppPreview {
    
    struct PreviewCore: SwiftyPressCore {
        
        func constantsService() -> ConstantsService {
            ConstantsMemoryService(
                environment: .development,
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
            DataFileSeed(
                forResource: "sample.json",
                inBundle: .main,
                jsonDecoder: jsonDecoder()
            )
        }
        
        func theme() -> Theme {
            AppTheme()
        }
    }
}

// MARK: - View

@available(iOS 13, *)
extension AppPreview {

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
        AppPreview.LocalePreview { self }
    }
    
    func previewDarkTheme() -> some View {
        AppPreview.DarkThemePreview { self }
    }
    
    func previewContentSize(_ sizeCategory: ContentSizeCategory) -> some View {
        AppPreview.ContentSizeCategoryPreview(sizeCategory) { self }
    }
    
    func preview_iPad() -> some View {
        self
            .previewDevice(PreviewDevice(rawValue: "iPad Pro (12.9-inch) (3rd generation)"))
            .previewDisplayName("iPad")
    }
}
#endif
