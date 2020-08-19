//
//  Preview.swift
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

struct Preview {
    static let core = PreviewCore()
    static let store = AppStore()
}

extension Preview {
    //swiftlint:disable file_length
}

// MARK: - Data

extension Preview {
    
    static let postsState = store.postsState.apply { _ in
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
            
            store.reduce(.mergePosts(posts))
        }
    }
}

extension Preview {
    
    static let termsState = store.termsState.apply { _ in
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
            
            store.reduce(.mergeTerms(terms))
        }
    }
}

extension Preview {
    
    static let mainState = store.mainState.apply { _ in
        store.reduce(.loadMenu([
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

extension Preview {
    
    static let homeState = store.homeState.apply { _ in
        store.reduce(.loadProfile(
            HomeAPI.Profile(
                avatar: "BasemProfilePic",
                name: "John Doe",
                caption: "Quality Assurance / iOS"
            )
        ))
            
        store.reduce(.loadMenu([
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
        
        store.reduce(.loadSocial([
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

extension Preview {
    
    static let showBlogState = store.showBlogState.apply { _ in
        store.reduce(.loadLatestPosts(store.postsState.allPosts.values.shuffled().prefix(10).array))
        store.reduce(.loadPopularPosts(store.postsState.allPosts.values.shuffled().prefix(10).array))
        store.reduce(.loadTopPickPosts(store.postsState.allPosts.values.shuffled().prefix(10).array))
        store.reduce(ShowBlogReducer.loadTerms(store.termsState.allTerms.values.shuffled().prefix(10).array))
    }
}

extension Preview {
    
    static let listFavoritesState = store.listFavoritesState.apply { _ in
        store.reduce(.loadFavorites(postsState.allPosts.values.shuffled().prefix(10).array))
    }
}

extension Preview {
    
    static let listPostsState = store.listPostsState.apply { _ in
        store.reduce(ListPostsReducer.loadPosts(store.postsState.allPosts.values.shuffled().prefix(10).array))
    }
}

extension Preview {
    
    static let showPostState: ShowPostState = {
        let presenter = ShowPostPresenter(
            store.reduce,
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
        
        return store.showPostState
    }()
}

extension Preview {
    
    static let searchPostsState = store.searchPostsState.apply { _ in
        store.reduce(SearchPostsReducer.loadPosts(postsState.allPosts.values.shuffled().prefix(10).array))
    }
}

extension Preview {
    
    static let listTermsState = store.listTermsState.apply { _ in
        store.reduce(ListTermsReducer.loadTerms(termsState.allTerms.values.shuffled().prefix(25).array))
    }
}

extension Preview {
    
    static let showMoreState = store.showMoreState.apply { _ in
        store.reduce(.loadMenu([
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
        
        store.reduce(.loadSocial([
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

extension Preview {
    
    static let showSettings = store.showSettingsState.apply { _ in
        store.reduce(.loadMenu([
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
        
        store.reduce(.setAutoThemeEnabled(true))
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
