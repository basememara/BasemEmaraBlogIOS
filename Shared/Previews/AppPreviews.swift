//
//  AppPreviews.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2020-05-14.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

#if DEBUG
@testable import SwiftyPress
import SwiftUI
import UIKit
import ZamzamCore
import ZamzamUI

struct AppPreviews {
    static let shared = AppPreviews()
    
    let core = PreviewCore()
    let store = AppStore()
    
    init() {
        core.dataSeed().fetch {
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
            
            store.allPosts = Dictionary(uniqueKeysWithValues: posts.map { ($0.id, $0) })
            store.allTerms = Dictionary(uniqueKeysWithValues: terms.map { ($0.id, $0) })
        }
    }
}

// MARK: - Dependency Factory

extension AppPreviews {
    
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
    }
}

extension AppPreviews {
    
    // swiftlint:disable line_length
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

// MARK: - View

@available(iOS 13, *)
extension AppPreviews {

    struct LocalePreview<AppPreviews: View>: View {
        private let preview: AppPreviews
        
        private let allLocales = Bundle.main.localizations
            .map(Locale.init).filter { $0.identifier != "base" }
        
        var body: some View {
            ForEach(allLocales, id: \.self) { locale in
                self.preview
                    .environment(\.locale, locale)
                    .previewDisplayName("Locale: \(locale.identifier)")
            }
        }
        
        init(@ViewBuilder builder: @escaping () -> AppPreviews) {
            preview = builder()
        }
    }

    struct ContentSizeCategoryPreview<AppPreviews: View>: View {
        private let preview: AppPreviews
        private let sizeCategory: ContentSizeCategory
        
        var body: some View {
            preview
                .environment(\.sizeCategory, sizeCategory)
                .previewDisplayName("Content Size: \(sizeCategory)")
        }
        
        init(_ sizeCategory: ContentSizeCategory, @ViewBuilder builder: @escaping () -> AppPreviews) {
            self.sizeCategory = sizeCategory
            preview = builder()
        }
    }

    struct DarkThemePreview<AppPreviews: View>: View {
        private let preview: AppPreviews
        
        var body: some View {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                preview
                    .environment(\.colorScheme, .dark)
                    .previewDevice(PreviewDevice(rawValue: "iPhone Xs Max"))
            }
            .previewDisplayName("Dark Theme")
        }
        
        init(@ViewBuilder builder: @escaping () -> AppPreviews) {
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
        AppPreviews.LocalePreview { self }
    }
    
    func previewDarkTheme() -> some View {
        AppPreviews.DarkThemePreview { self }
    }
    
    func previewContentSize(_ sizeCategory: ContentSizeCategory) -> some View {
        AppPreviews.ContentSizeCategoryPreview(sizeCategory) { self }
    }
    
    func preview_iPad() -> some View {
        self
            .previewDevice(PreviewDevice(rawValue: "iPad Pro (12.9-inch) (3rd generation)"))
            .previewDisplayName("iPad")
    }
}
#endif
